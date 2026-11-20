import { type Catalog, forModel, type Locale } from "./catalog.ts";
import { type Decider, escalation } from "./decider.ts";
import { type ChatMessage, type ChatModel, LlmError, type ToolCall } from "./llm.ts";
import {
  type AgentProfile,
  DISCLAIMER,
  EMPTY_REPLY,
  FALLBACK_REPLY,
  looksLikeDiagnosis,
  systemPrompt,
  TOOLS,
} from "./prompt.ts";
import { ModelQuotaExceeded } from "./quota.ts";
import type { RedFlagDetector } from "./redflag.ts";
import { alternatives, bookableDates, bookingRef, idempotencyKey, isBookable, isFull, TIME_WINDOWS } from "./slots.ts";
import type { StreamEvent } from "./sse.ts";
import type { Conversation, Store } from "./store.ts";
import { validateBook, validateForm, validateSearch } from "./validate.ts";

export interface Deps {
  store: Store;
  chat: ChatModel;
  decider: Decider;
  detector: RedFlagDetector;
  catalog: Catalog;
  now: () => Date;
  newId: () => string;
}

export interface TurnInput {
  userId: string;
  conversationId: string;
  clientMessageId: string;
  kind: "text" | "action";
  locale: Locale;
  text: string;
  profile?: AgentProfile;
}

export type Begin =
  | { kind: "error"; status: number; code: string; message: string }
  | { kind: "replay"; events: StreamEvent[] }
  | { kind: "run"; userMessageId: string; conversation: Conversation };

const MAX_TOOL_ROUNDS = 3;
const STALE_TURN_MS = 90_000;
const BOOKING_INTENT = /\b(book|booking|schedule|appointment|slot|reserve|collection)|बुक|स्लॉट|कलेक्शन|अपॉइंटमेंट/i;
const HISTORY_TURNS = 10;
const HELPLINES = { urgent: ["112", "108"], crisis: ["14416"] };

export async function beginTurn(deps: Deps, input: TurnInput): Promise<Begin> {
  const { store } = deps;
  let conv = await store.getConversation(input.conversationId);
  if (!conv) {
    await store.createConversation({
      id: input.conversationId,
      user_id: input.userId,
      locale: input.locale,
      flagged: false,
    });
    conv = await store.getConversation(input.conversationId);
  }
  if (!conv || conv.user_id !== input.userId) {
    return { kind: "error", status: 403, code: "forbidden", message: "conversation belongs to another user" };
  }

  let existing = await store.findUserMessage(conv.id, input.clientMessageId);
  if (!existing) {
    const id = deps.newId();
    const inserted = await store.insertUserMessage({
      id,
      conversation_id: conv.id,
      user_id: input.userId,
      client_message_id: input.clientMessageId,
      kind: input.kind,
      text: input.text,
    });
    if (inserted === "inserted") return { kind: "run", userMessageId: id, conversation: conv };
    existing = await store.findUserMessage(conv.id, input.clientMessageId);
    if (!existing) throw new Error("message vanished after conflict");
  }

  if (existing.status === "completed") {
    const events = await store.replyEvents(existing.id);
    if (events) return { kind: "replay", events };
  }
  const staleBefore = new Date(deps.now().getTime() - STALE_TURN_MS).toISOString();
  if (existing.status === "completed" || await store.claimStale(existing.id, staleBefore)) {
    return { kind: "run", userMessageId: existing.id, conversation: conv };
  }
  return { kind: "error", status: 409, code: "in_progress", message: "this message is still being processed" };
}

export async function runTurn(
  deps: Deps,
  input: TurnInput,
  begin: Extract<Begin, { kind: "run" }>,
  emit: (e: StreamEvent) => void,
): Promise<void> {
  const { store, catalog, locale } = { ...deps, locale: input.locale };
  const conv = begin.conversation;
  const messageId = begin.userMessageId;
  const events: StreamEvent[] = [];
  const usage = { model_requests: 0, input_tokens: 0, output_tokens: 0 };
  const record = (event: string, data: Record<string, unknown>) => {
    const e = { event, data };
    events.push(e);
    emit(e);
  };
  const log = (u: Omit<Parameters<Store["logUsage"]>[0], "user_id" | "conversation_id">) => {
    usage.model_requests++;
    usage.input_tokens += u.input_tokens;
    usage.output_tokens += u.output_tokens;
    return store.logUsage({ ...u, user_id: input.userId, conversation_id: conv.id });
  };

  const finish = async (text: string) => {
    const assistantId = deps.newId();
    const done = { event: "done", data: { assistant_message_id: assistantId, usage } };
    events.push(done);
    await store.saveAssistantReply({
      id: assistantId,
      conversation_id: conv.id,
      user_id: input.userId,
      reply_to: messageId,
      text,
      events,
    });
    await store.setUserMessageStatus(messageId, "completed");
    emit(done);
  };

  const fail = async (code: string, message: string, retryable: boolean, retryAfter?: number) => {
    emit({ event: "error", data: { code, message, retryable, ...(retryAfter ? { retry_after: retryAfter } : {}) } });
    await store.setUserMessageStatus(messageId, "failed");
    emit({ event: "done", data: { assistant_message_id: null, usage } });
  };

  const escalate = async (outcome: "urgent" | "crisis", category: string) => {
    await store.flagConversation(conv.id);
    if (outcome === "urgent") record("urgent_care", { category, helplines: HELPLINES.urgent });
    else record("crisis_support", { category, helplines: HELPLINES.crisis });
    await finish("");
  };

  emit({ event: "ack", data: { client_message_id: input.clientMessageId, replay: false } });

  try {
    const hit = deps.detector.detect(input.text);
    const keywordFloor = async (decider: "decider_unavailable" | "skipped") => {
      await store.logSafety({ message_id: messageId, keyword_match: hit!.matches, outcome: hit!.outcome });
      console.warn(`soft keyword match escalated without decider (${decider})`);
      return await escalate(hit!.outcome, hit!.categories[0]);
    };
    if (hit && !hit.soft) {
      await store.logSafety({ message_id: messageId, keyword_match: hit.matches, outcome: hit.outcome });
      return await escalate(hit.outcome, hit.categories[0]);
    }

    const now = deps.now();
    if (input.kind === "text") {
      const recent = await store.recentUserTexts(conv.id, 3);
      const t = await deps.decider.triage(recent.length ? recent : [input.text], locale);
      if (t.ok) {
        await log({
          kind: "decision",
          model: t.model,
          status: "ok",
          input_tokens: t.inputTokens,
          output_tokens: t.outputTokens,
          cost_usd: t.costUsd,
          latency_ms: t.latencyMs,
        });
        const outcome = escalation(t.probs);
        await store.logSafety({
          message_id: messageId,
          keyword_match: hit?.matches ?? [],
          decider_model: t.model,
          decider_probs: t.probs,
          outcome: outcome ?? "pass",
          latency_ms: t.latencyMs,
        });
        if (outcome) return await escalate(outcome, "decider");
      } else {
        if (t.reason !== "timeout") {
          await log({
            kind: "decision",
            model: deps.decider.model,
            status: t.reason === "rate_limited" ? "rate_limited" : "upstream_error",
            input_tokens: 0,
            output_tokens: 0,
            cost_usd: 0,
            latency_ms: t.latencyMs,
          });
        }
        console.warn(`decider unavailable: ${t.reason}`);
        if (hit) return await keywordFloor("decider_unavailable");
        await store.logSafety({
          message_id: messageId,
          keyword_match: [],
          decider_model: deps.decider.model,
          outcome: "decider_unavailable",
          latency_ms: t.latencyMs,
        });
      }
    } else {
      if (hit) return await keywordFloor("skipped");
      await store.logSafety({ message_id: messageId, keyword_match: [], outcome: "skipped" });
    }

    const history = await store.history(conv.id, messageId, HISTORY_TURNS);
    const messages: ChatMessage[] = [
      { role: "system", content: systemPrompt(locale, now, conv.flagged, input.profile) },
      ...history.map((h) => ({ role: h.role, content: h.text }) as ChatMessage),
      { role: "user", content: input.text },
    ];
    let text = "";
    let invalid = 0;
    let quotaAfterCard = false;

    for (let round = 0; round <= MAX_TOOL_ROUNDS; round++) {
      let roundText = "";
      let calls: ToolCall[] = [];
      try {
        for await (const c of deps.chat.stream({ messages, tools: round < MAX_TOOL_ROUNDS ? TOOLS : undefined })) {
          if (c.type === "text") {
            roundText += c.delta;
            record("text_delta", { text: c.delta });
          } else if (c.type === "tool_calls") {
            calls = c.calls;
          } else {
            await log({
              kind: "chat",
              model: c.usage.model,
              status: "ok",
              input_tokens: c.usage.input_tokens,
              output_tokens: c.usage.output_tokens,
              cost_usd: c.usage.cost_usd,
              latency_ms: c.usage.latency_ms,
            });
          }
        }
      } catch (e) {
        if (
          e instanceof ModelQuotaExceeded &&
          events.some((event) =>
            ["package_cards", "booking_form", "booking_confirmed", "slot_unavailable"].includes(event.event)
          )
        ) {
          quotaAfterCard = true;
          break;
        }
        if (e instanceof LlmError) {
          await log({
            kind: "chat",
            model: deps.chat.model,
            status: e.code,
            input_tokens: 0,
            output_tokens: 0,
            cost_usd: 0,
            latency_ms: e.latencyMs,
          });
        }
        throw e;
      }
      text += roundText;
      if (!calls.length) break;

      messages.push({ role: "assistant", content: roundText || null, tool_calls: calls });
      let fallback = false;
      for (const call of calls) {
        const r = await runTool(call);
        if (r.invalid && ++invalid >= 2) {
          fallback = true;
          break;
        }
        messages.push({ role: "tool", tool_call_id: call.id, content: JSON.stringify(r.content) });
      }
      if (fallback) {
        record("package_cards", { query: input.text, packages: catalog.search(input.text) });
        const reply = (text ? "\n\n" : "") + FALLBACK_REPLY[locale];
        record("text_delta", { text: reply });
        text += reply;
        break;
      }
    }

    if (!text.trim() && !quotaAfterCard) {
      const shown = events.some((e) =>
        e.event === "package_cards" || e.event === "booking_confirmed" || e.event === "slot_unavailable"
      );
      text = shown ? FALLBACK_REPLY[locale] : EMPTY_REPLY[locale];
      record("text_delta", { text });
    }
    if (looksLikeDiagnosis(text)) {
      console.warn(`diagnosis-like output flagged for message ${messageId}`);
      record("text_delta", { text: DISCLAIMER[locale] });
      text += DISCLAIMER[locale];
    }
    await finish(text);
  } catch (e) {
    if (e instanceof ModelQuotaExceeded) {
      await fail("quota_exhausted", "daily model quota reached", true, e.retryAfter);
    } else if (e instanceof LlmError && e.code === "rate_limited") {
      await fail("rate_limited", "the model is busy", true, e.retryAfter);
    } else {
      console.error(e);
      await fail("llm_unavailable", "the assistant is unavailable", true);
    }
  }

  async function runTool(call: ToolCall): Promise<{ content: Record<string, unknown>; invalid?: boolean }> {
    if (call.function.name === "search_packages") {
      const v = validateSearch(call.function.arguments);
      if (!v.ok) return { content: { error: v.error }, invalid: true };
      record("tool_started", { tool: "search_packages" });
      const { query, ...opts } = v.value;
      const results = catalog.search(query, opts);
      record("package_cards", { query, packages: results });
      return { content: { results: forModel(results, locale) } };
    }
    if (call.function.name === "show_booking_form") {
      const v = validateForm(call.function.arguments, catalog, deps.now());
      if (!v.ok) return { content: { error: v.error }, invalid: true };
      if (input.kind !== "action" && !BOOKING_INTENT.test(input.text)) {
        return {
          content: {
            status: "not_shown",
            message: "The user has not asked to book yet. Do not show the form; let them pick a package first.",
          },
        };
      }
      record("tool_started", { tool: "show_booking_form" });
      const f = v.value;
      const pkg = catalog.byId(f.package_id)!;
      const now = deps.now();
      const availability = Object.fromEntries(
        bookableDates(now).map((d) => [d, TIME_WINDOWS.filter((w) => isBookable(d, w, now) && !isFull(d, w))]),
      );
      record("booking_form", {
        package_id: pkg.id,
        package_name: pkg.name,
        fasting_hours: pkg.fasting_hours,
        prefill: {
          date: f.date ?? null,
          time_window: f.time_window ?? null,
          address_label: f.address_label ?? null,
          patient_name: f.patient_name ?? null,
        },
        availability,
      });
      return { content: { status: "form_shown" } };
    }
    if (call.function.name === "book_slot") {
      const v = validateBook(call.function.arguments, catalog, deps.now());
      if (!v.ok) return { content: { error: v.error }, invalid: true };
      record("tool_started", { tool: "book_slot" });
      const a = v.value;
      const fresh = await store.getConversation(conv.id);
      const messages = await store.bookingSafetyMessages(conv.id, 50);
      if (
        fresh?.flagged || messages.some(({ text, checks }) => {
          const hit = deps.detector.detect(text);
          return hit && (!hit.soft || !checks.length || checks.some((check) => check.outcome !== "pass"));
        })
      ) {
        return { content: { error: "booking_blocked_for_safety", message: "Do not book. Advise urgent care." } };
      }
      const key = await idempotencyKey({
        userId: input.userId,
        packageId: a.package_id,
        date: a.date,
        window: a.time_window,
        patientName: a.patient_name,
      });
      const pkg = catalog.byId(a.package_id)!;
      let booking = await store.findBooking(key);
      if (!booking) {
        if (isFull(a.date, a.time_window)) {
          const alts = alternatives(a.date, a.time_window, deps.now());
          record("slot_unavailable", {
            requested: { date: a.date, time_window: a.time_window },
            alternatives: alts,
            package_id: a.package_id,
            package_name: pkg.name,
            address_label: a.address_label,
            patient_name: a.patient_name,
          });
          return { content: { status: "unavailable", alternatives: alts } };
        }
        booking = await store.insertBooking({
          booking_ref: bookingRef(key),
          user_id: input.userId,
          conversation_id: conv.id,
          package_id: a.package_id,
          slot_date: a.date,
          time_window: a.time_window,
          address_label: a.address_label,
          patient_name: a.patient_name,
          status: "confirmed",
          idempotency_key: key,
        });
      }
      record("booking_confirmed", {
        booking_ref: booking.booking_ref,
        package_id: booking.package_id,
        package_name: pkg.name,
        date: booking.slot_date,
        time_window: booking.time_window,
        address_label: booking.address_label,
        patient_name: booking.patient_name,
        status: booking.status,
        fasting_hours: pkg.fasting_hours,
      });
      return {
        content: {
          status: "confirmed",
          booking_ref: booking.booking_ref,
          date: booking.slot_date,
          time_window: booking.time_window,
          fasting_hours: pkg.fasting_hours,
        },
      };
    }
    return { content: { error: `unknown tool ${call.function.name}` }, invalid: true };
  }
}
