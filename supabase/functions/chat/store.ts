import type { SupabaseClient } from "@supabase/supabase-js";
import type { Locale } from "./catalog.ts";
import type { StreamEvent } from "./sse.ts";

export interface Conversation {
  id: string;
  user_id: string;
  locale: Locale;
  flagged: boolean;
}

export interface UserMessage {
  id: string;
  status: "processing" | "completed" | "failed";
  updated_at: string;
}

export interface HistoryTurn {
  role: "user" | "assistant";
  text: string;
}

export interface BookingRow {
  booking_ref: string;
  user_id: string;
  conversation_id: string;
  package_id: string;
  slot_date: string;
  time_window: string;
  address_label: string;
  patient_name: string;
  status: string;
  idempotency_key: string;
}

export interface SafetyCheck {
  message_id: string;
  keyword_match: string[];
  decider_model?: string;
  decider_probs?: Record<string, number>;
  outcome: "urgent" | "crisis" | "pass" | "decider_unavailable" | "skipped";
  latency_ms?: number;
}

export interface UsageRow {
  user_id: string;
  conversation_id: string;
  kind: "chat" | "decision";
  model: string;
  status: "ok" | "rate_limited" | "upstream_error" | "invalid_tool_call";
  input_tokens: number;
  output_tokens: number;
  cost_usd: number;
  latency_ms: number;
}

export interface Store {
  getConversation(id: string): Promise<Conversation | null>;
  createConversation(c: Conversation): Promise<void>;
  flagConversation(id: string): Promise<void>;
  findUserMessage(conversationId: string, clientMessageId: string): Promise<UserMessage | null>;
  insertUserMessage(m: {
    id: string;
    conversation_id: string;
    user_id: string;
    client_message_id: string;
    kind: "text" | "action";
    text: string;
  }): Promise<"inserted" | "conflict">;
  setUserMessageStatus(id: string, status: UserMessage["status"]): Promise<void>;
  claimStale(id: string, staleBefore: string): Promise<boolean>;
  saveAssistantReply(r: {
    id: string;
    conversation_id: string;
    user_id: string;
    reply_to: string;
    text: string;
    events: StreamEvent[];
  }): Promise<void>;
  replyEvents(userMessageId: string): Promise<StreamEvent[] | null>;
  history(conversationId: string, excludeId: string, turns: number): Promise<HistoryTurn[]>;
  recentUserTexts(conversationId: string, n: number): Promise<string[]>;
  findBooking(idempotencyKey: string): Promise<BookingRow | null>;
  insertBooking(b: BookingRow): Promise<BookingRow>;
  logSafety(s: SafetyCheck): Promise<void>;
  logUsage(u: UsageRow): Promise<void>;
  usageCountSince(since: string): Promise<number>;
  userTurnsSince(userId: string, since: string): Promise<number>;
}

function must<T>(r: { data: T; error: { message: string } | null }): T {
  if (r.error) throw new Error(r.error.message);
  return r.data;
}

export class SupabaseStore implements Store {
  constructor(private readonly db: SupabaseClient) {}

  async getConversation(id: string) {
    return must(await this.db.from("conversations").select("id,user_id,locale,flagged").eq("id", id).maybeSingle());
  }

  async createConversation(c: Conversation) {
    const { error } = await this.db.from("conversations").insert(c);
    if (error && error.code !== "23505") throw new Error(error.message);
  }

  async flagConversation(id: string) {
    must(await this.db.from("conversations").update({ flagged: true }).eq("id", id));
  }

  async findUserMessage(conversationId: string, clientMessageId: string) {
    return must(
      await this.db.from("messages").select("id,status,updated_at")
        .eq("conversation_id", conversationId).eq("client_message_id", clientMessageId).maybeSingle(),
    );
  }

  async insertUserMessage(m: Parameters<Store["insertUserMessage"]>[0]) {
    const { error } = await this.db.from("messages").insert({
      id: m.id,
      conversation_id: m.conversation_id,
      user_id: m.user_id,
      client_message_id: m.client_message_id,
      role: "user",
      kind: m.kind,
      content: { text: m.text },
      status: "processing",
    });
    if (error?.code === "23505") return "conflict";
    if (error) throw new Error(error.message);
    return "inserted";
  }

  async setUserMessageStatus(id: string, status: UserMessage["status"]) {
    must(await this.db.from("messages").update({ status, updated_at: new Date().toISOString() }).eq("id", id));
  }

  async claimStale(id: string, staleBefore: string) {
    const rows = must(
      await this.db.from("messages").update({ status: "processing", updated_at: new Date().toISOString() })
        .eq("id", id).or(`status.eq.failed,and(status.eq.processing,updated_at.lt.${staleBefore})`).select("id"),
    );
    return (rows?.length ?? 0) > 0;
  }

  async saveAssistantReply(r: Parameters<Store["saveAssistantReply"]>[0]) {
    must(await this.db.from("messages").delete().eq("reply_to", r.reply_to));
    must(
      await this.db.from("messages").insert({
        id: r.id,
        conversation_id: r.conversation_id,
        user_id: r.user_id,
        reply_to: r.reply_to,
        role: "assistant",
        content: { text: r.text, events: r.events },
        status: "completed",
      }),
    );
  }

  async replyEvents(userMessageId: string) {
    const row = must(
      await this.db.from("messages").select("content").eq("reply_to", userMessageId).maybeSingle(),
    ) as { content: { events: StreamEvent[] } } | null;
    return row?.content.events ?? null;
  }

  async history(conversationId: string, excludeId: string, turns: number) {
    const rows = must(
      await this.db.from("messages").select("id,role,content,status,reply_to")
        .eq("conversation_id", conversationId).neq("id", excludeId)
        .order("created_at", { ascending: false }).limit(turns * 2),
    ) as { role: "user" | "assistant"; content: { text?: string; events?: StreamEvent[] }; status: string }[];
    return rows.reverse().filter((r) => r.role === "assistant" || r.status === "completed")
      .map((r) => ({
        role: r.role,
        text: r.role === "assistant" ? assistantHistoryText(r.content) : r.content.text ?? "",
      }));
  }

  async recentUserTexts(conversationId: string, n: number) {
    const rows = must(
      await this.db.from("messages").select("content").eq("conversation_id", conversationId).eq("role", "user")
        .eq("kind", "text").order("created_at", { ascending: false }).limit(n),
    ) as { content: { text: string } }[];
    return rows.reverse().map((r) => r.content.text);
  }

  async findBooking(idempotencyKey: string) {
    return must(await this.db.from("bookings").select("*").eq("idempotency_key", idempotencyKey).maybeSingle());
  }

  async insertBooking(b: BookingRow) {
    const { data, error } = await this.db.from("bookings").insert(b).select("*").single();
    if (error?.code === "23505") return (await this.findBooking(b.idempotency_key))!;
    if (error) throw new Error(error.message);
    return data;
  }

  async logSafety(s: SafetyCheck) {
    must(await this.db.from("safety_checks").insert(s));
  }

  async logUsage(u: UsageRow) {
    must(await this.db.from("llm_usage").insert({ ...u, provider: "openrouter" }));
  }

  async usageCountSince(since: string) {
    const { count, error } = await this.db.from("llm_usage").select("id", { count: "exact", head: true })
      .gte("created_at", since);
    if (error) throw new Error(error.message);
    return count ?? 0;
  }

  async userTurnsSince(userId: string, since: string) {
    const { count, error } = await this.db.from("messages").select("id", { count: "exact", head: true })
      .eq("user_id", userId).eq("role", "user").gte("created_at", since);
    if (error) throw new Error(error.message);
    return count ?? 0;
  }
}

export function assistantHistoryText(content: { text?: string; events?: StreamEvent[] }): string {
  const notes: string[] = [];
  for (const e of content.events ?? []) {
    if (e.event === "package_cards") {
      const pkgs = (e.data.packages as { id: string; name: { en: string } }[]).map((p) => `${p.id} (${p.name.en})`);
      notes.push(`[cards shown: ${pkgs.join(", ")}]`);
    } else if (e.event === "booking_confirmed") {
      notes.push(`[booked: ${e.data.booking_ref} ${e.data.package_id} ${e.data.date} ${e.data.time_window}]`);
    } else if (e.event === "booking_form") {
      notes.push(`[booking form shown for ${e.data.package_id}]`);
    } else if (e.event === "slot_unavailable") {
      notes.push(`[slot full; alternatives offered: ${JSON.stringify(e.data.alternatives)}]`);
    } else if (e.event === "urgent_care" || e.event === "crisis_support") {
      notes.push(`[safety card shown: ${e.event}]`);
    }
  }
  return [content.text ?? "", ...notes].filter(Boolean).join("\n");
}
