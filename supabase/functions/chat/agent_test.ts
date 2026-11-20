import { assert, assertEquals } from "@std/assert";
import { beginTurn, type Deps, isFollowUp, runTurn, type TurnInput } from "./agent.ts";
import { Catalog } from "./catalog.ts";
import type { Triage } from "./decider.ts";
import type { ChatChunk, ChatModel, ChatRequest } from "./llm.ts";
import { MockChat, MockDecider } from "./mocks.ts";
import { parseProfile, systemPrompt } from "./prompt.ts";
import { ModelQuotaExceeded } from "./quota.ts";
import { RedFlagDetector } from "./redflag.ts";
import { bookingRef, idempotencyKey, isFull, TIME_WINDOWS } from "./slots.ts";
import type { StreamEvent } from "./sse.ts";
import { MemoryStore } from "./testing.ts";

const NOW = new Date("2026-11-20T04:30:00Z");
const USAGE = { model: "test", input_tokens: 10, output_tokens: 5, cost_usd: 0, latency_ms: 1 };

class ScriptedChat implements ChatModel {
  readonly model = "test";
  requests: ChatRequest[] = [];
  constructor(private readonly rounds: ChatChunk[][]) {}
  async *stream(req: ChatRequest) {
    this.requests.push(structuredClone(req));
    const round = this.rounds.shift() ?? [{ type: "text", delta: "ok" }];
    for (const c of round) yield c;
    yield { type: "done", usage: USAGE } as ChatChunk;
  }
}

const text = (t: string): ChatChunk => ({ type: "text", delta: t });
const call = (name: string, args: unknown, id = name): ChatChunk => ({
  type: "tool_calls",
  calls: [{
    id,
    type: "function",
    function: { name, arguments: typeof args === "string" ? args : JSON.stringify(args) },
  }],
});

function setup(opts: { chat?: ChatModel; decider?: (m: string[]) => Triage } = {}) {
  const store = new MemoryStore(() => NOW);
  let n = 0;
  const deps: Deps = {
    store,
    chat: opts.chat ?? new MockChat(),
    decider: new MockDecider(opts.decider),
    detector: new RedFlagDetector(),
    catalog: new Catalog(),
    now: () => NOW,
    newId: () => `id-${++n}`,
  };
  return { store, deps };
}

let seq = 0;
function input(text: string, extra: Partial<TurnInput> = {}): TurnInput {
  return {
    userId: "u1",
    conversationId: "c1",
    clientMessageId: `m${++seq}`,
    kind: "text",
    locale: "en",
    text,
    ...extra,
  };
}

async function turn(deps: Deps, inp: TurnInput) {
  const begin = await beginTurn(deps, inp);
  const events: StreamEvent[] = [];
  if (begin.kind === "run") await runTurn(deps, inp, begin, (e) => events.push(e));
  return { begin, events, names: events.map((e) => e.event) };
}

const free = (date: string) => TIME_WINDOWS.find((w) => w !== "07-09" && !isFull(date, w))!;
const fullSlot = () => {
  for (const d of ["2026-11-21", "2026-11-22", "2026-11-23", "2026-11-24", "2026-11-25"]) {
    const w = TIME_WINDOWS.find((w) => isFull(d, w));
    if (w) return { d, w };
  }
  throw new Error("no full slot");
};
const bookArgs = (date: string, time_window: string) => ({
  package_id: "pkg_thyroid_profile",
  date,
  time_window,
  address_label: "Home",
  patient_name: "Priya",
});

Deno.test("search turn: ack, tool_started, package_cards, text, done", async () => {
  const chat = new ScriptedChat([[call("search_packages", { query: "thyroid" })], [
    text("These are "),
    text("commonly ordered."),
  ]]);
  const { deps, store } = setup({ chat });
  const { names, events } = await turn(deps, input("I want to check my thyroid"));
  assertEquals(names, ["ack", "tool_started", "package_cards", "text_delta", "text_delta", "done"]);
  assertEquals((events[2].data.packages as { id: string }[])[0].id, "pkg_thyroid_profile");
  assertEquals(chat.requests[1].messages.at(-1)!.role, "tool");
  assert(!JSON.stringify(chat.requests[1].messages.at(-1)).includes("price"), "prices never reach the model");
  assertEquals(store.usage.map((u) => u.kind), ["decision", "chat", "chat"]);
  assertEquals(store.messages[0].status, "completed");
});

Deno.test("replay: same client_message_id returns stored events without model calls", async () => {
  const { deps, store } = setup();
  const inp = input("sugar test");
  const first = await turn(deps, inp);
  const usageBefore = store.usage.length;
  const again = await beginTurn(deps, inp);
  assert(again.kind === "replay");
  assertEquals(again.events.map((e) => e.event), first.names.slice(1));
  assertEquals(store.usage.length, usageBefore);
});

Deno.test("in progress returns 409, stale processing is reclaimed", async () => {
  const { deps, store } = setup();
  const inp = input("sugar");
  const b = await beginTurn(deps, inp);
  assert(b.kind === "run");
  const again = await beginTurn(deps, inp);
  assert(again.kind === "error" && again.status === 409);
  store.messages[0].updated_at = "2026-11-20T04:00:00.000Z";
  assertEquals((await beginTurn(deps, inp)).kind, "run");
});

Deno.test("failed message is reprocessed on resend", async () => {
  const chat = new ScriptedChat([]);
  chat.stream = () => {
    throw new Error("boom");
  };
  const { deps, store } = setup({ chat });
  const inp = input("sugar");
  const { names } = await turn(deps, inp);
  assertEquals(names, ["ack", "error", "done"]);
  assertEquals(store.messages[0].status, "failed");
  deps.chat = new MockChat();
  assertEquals((await turn(deps, inp)).names.at(-1), "done");
  assertEquals(store.messages[0].status, "completed");
});

Deno.test("conversation owned by another user is forbidden", async () => {
  const { deps } = setup();
  await turn(deps, input("hi"));
  const b = await beginTurn(deps, input("hi", { userId: "intruder" }));
  assert(b.kind === "error" && b.status === 403);
});

Deno.test("keyword red flag: urgent card, flagged, zero model requests", async () => {
  const { deps, store } = setup();
  const { names, events } = await turn(deps, input("seene mein dard ho raha hai"));
  assertEquals(names, ["ack", "urgent_care", "done"]);
  assertEquals(events[1].data.helplines, ["112", "108"]);
  assertEquals(store.usage.length, 0);
  assert(store.conversations.get("c1")!.flagged);
});

Deno.test("keyword self-harm: crisis card", async () => {
  const { deps } = setup();
  assertEquals((await turn(deps, input("I want to kill myself"))).names, ["ack", "crisis_support", "done"]);
});

Deno.test("decider escalates paraphrase across messages, chat model not called", async () => {
  const chat = new ScriptedChat([]);
  const seen: string[][] = [];
  const { deps, store } = setup({
    chat,
    decider: (msgs) => {
      seen.push(msgs);
      const emergency = msgs.join(" ").includes("numb") ? 0.6 : 0.01;
      return {
        ok: true,
        probs: { emergency, mental_health_crisis: 0, routine: 1 - emergency },
        model: "d",
        latencyMs: 1,
        inputTokens: 1,
        outputTokens: 1,
        costUsd: 0,
      };
    },
  });
  await turn(deps, input("my chest feels weird today"));
  const before = chat.requests.length;
  const { names } = await turn(deps, input("and now my left arm is numb"));
  assertEquals(names, ["ack", "urgent_care", "done"]);
  assertEquals(chat.requests.length, before);
  assertEquals(seen.at(-1)!.length, 2);
  assertEquals(store.safety.at(-1)!.outcome, "urgent");
});

Deno.test("decider unavailable fails open and is logged", async () => {
  const { deps, store } = setup({ decider: () => ({ ok: false, reason: "timeout", latencyMs: 1500 }) });
  const { names } = await turn(deps, input("vitamin test"));
  assertEquals(names.at(-1), "done");
  assert(names.includes("package_cards"));
  assertEquals(store.safety[0].outcome, "decider_unavailable");
});

Deno.test("card action skips the decider", async () => {
  let calls = 0;
  const { deps, store } = setup({ decider: () => (calls++, { ok: false, reason: "timeout", latencyMs: 0 }) });
  await turn(deps, input("I want to book Thyroid Profile", { kind: "action" }));
  assertEquals(calls, 0);
  assertEquals(store.safety[0].outcome, "skipped");
});

Deno.test("booking: confirmed once, reprocess returns the same booking", async () => {
  const date = "2026-11-22";
  const w = free(date);
  const mk = () => new ScriptedChat([[call("book_slot", bookArgs(date, w))], [text("Done.")]]);
  const { deps, store } = setup({ chat: mk() });
  const inp = input("yes, book it");
  const { names, events } = await turn(deps, inp);
  assertEquals(names, ["ack", "tool_started", "booking_confirmed", "text_delta", "done"]);
  const ref = events[2].data.booking_ref;
  store.messages[0].status = "failed";
  deps.chat = mk();
  const again = await turn(deps, inp);
  assertEquals(again.events.find((e) => e.event === "booking_confirmed")!.data.booking_ref, ref);
  assertEquals(store.bookings.length, 1);
});

Deno.test("booking: full slot offers alternatives", async () => {
  const { d, w } = fullSlot();
  const chat = new ScriptedChat([[call("book_slot", bookArgs(d, w))], [text("That slot's full.")]]);
  const { deps, store } = setup({ chat });
  const { events } = await turn(deps, input("yes"));
  const ev = events.find((e) => e.event === "slot_unavailable")!;
  assertEquals((ev.data.alternatives as unknown[]).length, 3);
  assertEquals(store.bookings.length, 0);
});

Deno.test("booking: blocked when the conversation is flagged", async () => {
  const date = "2026-11-22";
  const chat = new ScriptedChat([[call("book_slot", bookArgs(date, free(date)))], [text("I can't book that.")]]);
  const { deps, store } = setup({ chat });
  await turn(deps, input("I fainted yesterday"));
  const { names } = await turn(deps, input("ok book the thyroid test"));
  assert(!names.includes("booking_confirmed"));
  assertEquals(store.bookings.length, 0);
  assert(JSON.stringify(chat.requests[1].messages.at(-1)).includes("booking_blocked_for_safety"));
});

Deno.test("invalid tool call: one correction, then deterministic fallback", async () => {
  const chat = new ScriptedChat([[call("book_slot", "{bad json")], [call("book_slot", { package_id: "nope" })]]);
  const { deps } = setup({ chat });
  const { names, events } = await turn(deps, input("book something for thyroid"));
  assertEquals(chat.requests.length, 2);
  assert(JSON.stringify(chat.requests[1].messages.at(-1)).includes("arguments must be a JSON object"));
  assertEquals(names.slice(-3), ["package_cards", "text_delta", "done"]);
  assert((events.at(-2)!.data.text as string).includes("commonly ordered"));
});

Deno.test("max 3 tool rounds, then tools disabled", async () => {
  const s = (id: string) => call("search_packages", { query: "sugar" }, id);
  const chat = new ScriptedChat([[s("a")], [s("b")], [s("c")], [text("Final answer.")]]);
  const { deps } = setup({ chat });
  await turn(deps, input("sugar"));
  assertEquals(chat.requests.length, 4);
  assertEquals(chat.requests[3].tools, undefined);
});

const exhaustedChat: ChatModel = {
  model: "test",
  // deno-lint-ignore require-yield
  async *stream() {
    throw new ModelQuotaExceeded(90);
  },
};

Deno.test("quota: model budget exhaustion keeps message retryable", async () => {
  const { deps, store } = setup({ chat: exhaustedChat });
  const { events } = await turn(deps, input("sugar"));
  const err = events.find((e) => e.event === "error")!;
  assertEquals([err.data.code, err.data.retryable, err.data.retry_after], ["quota_exhausted", true, 90]);
  assertEquals(store.messages[0].status, "failed");
  assertEquals(store.usage.map((u) => u.kind), ["decision"]);
});

Deno.test("quota: red flags still work when quota is exhausted", async () => {
  const { deps, store } = setup({ chat: exhaustedChat });
  assertEquals((await turn(deps, input("can't breathe"))).names, ["ack", "urgent_care", "done"]);
  assertEquals(store.usage.length, 0);
});

Deno.test("quota: a booking remains completed when its follow-up model call is blocked", async () => {
  const date = "2026-11-22";
  const first = new ScriptedChat([[call("book_slot", bookArgs(date, free(date)))]]);
  const { deps, store } = setup({
    chat: {
      model: first.model,
      async *stream(req) {
        if (first.requests.length) throw new ModelQuotaExceeded(90);
        yield* first.stream(req);
      },
    },
  });
  const { names } = await turn(deps, input("book the test", { kind: "action" }));
  assertEquals(names, ["ack", "tool_started", "booking_confirmed", "done"]);
  assertEquals(store.messages[0].status, "completed");
  assertEquals(store.bookings.length, 1);
});

Deno.test("output check appends disclaimer to diagnosis-like text", async () => {
  const chat = new ScriptedChat([[text("You probably have thyroid issues.")]]);
  const { deps } = setup({ chat });
  const { events } = await turn(deps, input("what do I have?"));
  assert((events.at(-2)!.data.text as string).includes("not a diagnosis"));
});

Deno.test("history carries card notes so the model can book the right id", async () => {
  const chat = new ScriptedChat([[call("search_packages", { query: "thyroid" })], [text("Here.")], [text("Confirm?")]]);
  const { deps } = setup({ chat });
  await turn(deps, input("thyroid"));
  await turn(deps, input("book the first one"));
  const hist = JSON.stringify(chat.requests[2].messages);
  assert(hist.includes("pkg_thyroid_profile"));
});

Deno.test("mock chat books from a structured slot action", async () => {
  const date = "2026-11-22";
  const { deps, store } = setup();
  const msg = `Book pkg_thyroid_profile on ${date} ${free(date)} at Home for Priya`;
  const { names } = await turn(deps, input(msg, { kind: "action" }));
  assert(names.includes("booking_confirmed"));
  assertEquals(store.bookings[0].patient_name, "Priya");
});

Deno.test("empty model text after cards falls back to the template reply", async () => {
  const chat = new ScriptedChat([[call("search_packages", { query: "sugar" })], []]);
  const { deps } = setup({ chat });
  const { events } = await turn(deps, input("पापा के लिए शुगर टेस्ट", { locale: "hi" }));
  const last = events.at(-2)!;
  assertEquals(last.event, "text_delta");
  assert((last.data.text as string).includes("आमतौर पर"));
});

Deno.test("few-shot booking example uses a real bookable date with the matching weekday", () => {
  const prompt = systemPrompt("en", NOW, false);
  const [, day, iso] = prompt.match(/thyroid one for (\w+) morning[\s\S]*?date "(\d{4}-\d{2}-\d{2})"/)!;
  assertEquals(day, new Date(`${iso}T00:00:00Z`).toLocaleDateString("en-IN", { weekday: "long", timeZone: "UTC" }));
  assertEquals(iso, "2026-11-22");
  assert(prompt.includes(`on ${iso} 07-09 at Home for Priya.`));
});

Deno.test("show_booking_form emits a pre-filled form with only open slots", async () => {
  const chat = new ScriptedChat([
    [call("show_booking_form", {
      package_id: "pkg_thyroid_profile",
      patient_name: "Priya",
      date: "2026-11-22",
      time_window: "07–09",
    })],
    [text("Please check the details and tap Confirm booking.")],
  ]);
  const { deps } = setup({ chat });
  const { events } = await turn(deps, input("book the thyroid test for Priya on Sunday morning"));
  const formIndex = events.findIndex((e) => e.event === "booking_form");
  assert(formIndex > 0);
  assertEquals(events[formIndex - 1], { event: "tool_started", data: { tool: "show_booking_form" } });
  const form = events[formIndex];
  const prefill = form.data.prefill as Record<string, unknown>;
  assertEquals([prefill.patient_name, prefill.date, prefill.time_window], ["Priya", "2026-11-22", "07-09"]);
  const availability = form.data.availability as Record<string, string[]>;
  assertEquals(Object.keys(availability).length, 8);
  for (const [d, windows] of Object.entries(availability)) {
    assert(windows.every((w) => !isFull(d, w as typeof TIME_WINDOWS[number])), `${d} offers a full slot`);
  }
  assertEquals(availability["2026-11-20"].includes("07-09"), false, "past window today is not offered");
  assertEquals(JSON.parse((chat.requests[1].messages.at(-1) as { content: string }).content).status, "form_shown");
});

Deno.test("show_booking_form drops invalid prefill but keeps the form", async () => {
  const chat = new ScriptedChat([
    [call("show_booking_form", { package_id: "pkg_thyroid_profile", date: "2027-01-01", time_window: "13-15" })],
    [text("ok")],
  ]);
  const { deps } = setup({ chat });
  const { events } = await turn(deps, input("book thyroid"));
  const prefill = events.find((e) => e.event === "booking_form")!.data.prefill as Record<string, unknown>;
  assertEquals([prefill.date, prefill.time_window], [null, null]);
});

Deno.test("show_booking_form with an unknown package is an invalid call", async () => {
  const chat = new ScriptedChat([[call("show_booking_form", { package_id: "nope" })], [text("Let me search first.")]]);
  const { deps } = setup({ chat });
  const { names } = await turn(deps, input("book something"));
  assert(!names.includes("booking_form"));
  assert(JSON.stringify(chat.requests[1].messages.at(-1)).includes("package_id must be"));
});

Deno.test("show_booking_form is refused when the user only asked about tests", async () => {
  const chat = new ScriptedChat([
    [call("search_packages", { query: "full body" })],
    [call("show_booking_form", { package_id: "pkg_full_body" })],
    [text("Here are two options.")],
  ]);
  const { deps } = setup({ chat });
  const { names } = await turn(deps, input("Full body checkup"));
  assert(!names.includes("booking_form"));
  assertEquals(JSON.parse((chat.requests[2].messages.at(-1) as { content: string }).content).status, "not_shown");
});

Deno.test("show_booking_form is allowed for Hindi booking requests and card actions", async () => {
  for (const [text_, kind] of [["पापा के लिए शुगर टेस्ट बुक करना है", "text"], ["any", "action"]] as const) {
    const chat = new ScriptedChat([[call("show_booking_form", { package_id: "pkg_diabetes_care" })], [text("ok")]]);
    const { deps } = setup({ chat });
    const { names } = await turn(deps, input(text_, { kind }));
    assert(names.includes("booking_form"), text_);
  }
});

Deno.test("profile context reaches the prompt; junk profiles are ignored", () => {
  const profile = parseProfile({
    patients: [
      { name: "Priya Sharma", relation: "self" },
      { name: "Ramesh Sharma", relation: "father" },
      { name: "x", relation: "boss" },
      { name: "", relation: "mother" },
    ],
    addresses: ["Home", "Papa's house", 42],
  })!;
  assertEquals(profile.patients.map((p) => p.name), ["Priya Sharma", "Ramesh Sharma"]);
  assertEquals(profile.addresses, ["Home", "Papa's house"]);
  const prompt = systemPrompt("en", NOW, false, profile);
  assert(prompt.includes("Ramesh Sharma (the user's father)"));
  assert(prompt.includes("Saved address labels: Home, Papa's house"));
  assertEquals(parseProfile("nope"), undefined);
  assertEquals(parseProfile({ patients: "x" }), undefined);
  assert(!systemPrompt("en", NOW, false).includes("Saved patients"));
});

Deno.test("the turn sends profile context to the model", async () => {
  const chat = new ScriptedChat([[text("ok")]]);
  const { deps } = setup({ chat });
  await turn(
    deps,
    input("book a sugar test for papa", {
      profile: { patients: [{ name: "Ramesh Sharma", relation: "father" }], addresses: ["Home"] },
    }),
  );
  assert((chat.requests[0].messages[0] as { content: string }).content.includes("Ramesh Sharma"));
});

const SOFT = "My father had a heart attack two years ago, which tests should he do yearly?";
const triage = (emergency: number): Triage | { ok: false; reason: "timeout"; latencyMs: number } =>
  emergency < 0 ? { ok: false, reason: "timeout", latencyMs: 1500 } : {
    ok: true,
    probs: { emergency, mental_health_crisis: 0.01, routine: 0.99 - emergency },
    model: "mock/decider",
    latencyMs: 0,
    inputTokens: 0,
    outputTokens: 0,
    costUsd: 0,
  };

Deno.test("soft keyword match: the decider clears it and the chat continues", async () => {
  const { deps, store } = setup({ chat: new ScriptedChat([[text("ok")]]), decider: () => triage(0.1) as Triage });
  const { names } = await turn(deps, input(SOFT));
  assert(!names.includes("urgent_care"));
  assertEquals(store.safety.at(-1)!.keyword_match, ["heart attack"]);
  assertEquals(store.safety.at(-1)!.outcome, "pass");
  assert(!store.conversations.get("c1")!.flagged);
});

Deno.test("soft keyword match: triage can still escalate when chat quota is exhausted", async () => {
  const { deps } = setup({ chat: exhaustedChat, decider: () => triage(0.7) as Triage });
  assertEquals((await turn(deps, input(SOFT))).names, ["ack", "urgent_care", "done"]);
});

Deno.test("booking: a soft match must have a recorded safety pass", async () => {
  const date = "2026-11-22";
  const chat = new ScriptedChat([
    [call("book_slot", bookArgs(date, free(date)))],
    [text("Booking is paused.")],
    [text("I can help with test packages.")],
    [call("book_slot", bookArgs(date, free(date)))],
    [text("Done.")],
  ]);
  const { deps, store } = setup({ chat, decider: () => triage(0.1) as Triage });
  const soft = input(SOFT);
  const pending = await beginTurn(deps, soft);
  assert(pending.kind === "run");
  assert(!(await turn(deps, input("book the test", { kind: "action" }))).names.includes("booking_confirmed"));
  assertEquals(store.bookings.length, 0);
  await runTurn(deps, soft, pending, () => {});
  assert((await turn(deps, input("book the test", { kind: "action" }))).names.includes("booking_confirmed"));
});

Deno.test("soft keyword match: escalates when the decider is unavailable or skipped", async () => {
  const down = setup({ decider: () => triage(-1) as Triage });
  assertEquals((await turn(down.deps, input(SOFT))).names, ["ack", "urgent_care", "done"]);
  const action = setup();
  assertEquals((await turn(action.deps, input(SOFT, { kind: "action" }))).names, ["ack", "urgent_care", "done"]);
});

Deno.test("hard keyword match never reaches the decider", async () => {
  let called = false;
  const { deps } = setup({ decider: () => (called = true, triage(0) as Triage) });
  await turn(deps, input("I had a heart attack years ago and now I have chest pain again"));
  assert(!called);
});

Deno.test("follow-ups (replay or in-progress poll) are recognised; new messages and other users' ids are not", async () => {
  const { deps, store } = setup({ chat: new ScriptedChat([[text("ok")]]) });
  const first = input("thyroid test");
  assert(!(await isFollowUp(store, first)), "a new message pays quota");
  const begin = await beginTurn(deps, first);
  assert(await isFollowUp(store, first), "a poll while processing is free");
  if (begin.kind === "run") await runTurn(deps, first, begin, () => {});
  assert(await isFollowUp(store, first), "a replay of a completed turn is free");
  assert(!(await isFollowUp(store, { ...first, userId: "intruder" })), "someone else's ids are not");
  assert(!(await isFollowUp(store, { ...first, clientMessageId: "m-new" })), "a new id in the same chat pays");
});

Deno.test("booking: a reference already taken by another booking falls through to the next variant", async () => {
  const date = "2026-11-22";
  const w = free(date);
  const { deps, store } = setup({
    chat: new ScriptedChat([[call("book_slot", bookArgs(date, w))], [text("Done.")]]),
  });
  const key = await idempotencyKey({
    userId: "u1",
    packageId: bookArgs(date, w).package_id,
    date,
    window: w,
    patientName: bookArgs(date, w).patient_name,
  });
  store.bookings.push({
    ...bookArgs(date, w),
    booking_ref: bookingRef(key),
    user_id: "u2",
    conversation_id: "c2",
    slot_date: date,
    status: "confirmed",
    idempotency_key: "someone-else",
  } as never);
  const { names, events } = await turn(deps, input("yes, book it"));
  assert(names.includes("booking_confirmed"));
  assertEquals(events.find((e) => e.event === "booking_confirmed")!.data.booking_ref, bookingRef(key, 1));
});

Deno.test("booking: the same slot booked again with a new address moves the booking, not duplicates it", async () => {
  const date = "2026-11-22";
  const w = free(date);
  const { deps, store } = setup({
    chat: new ScriptedChat([[call("book_slot", bookArgs(date, w))], [text("Done.")]]),
  });
  const first = await turn(deps, input("book it"));
  const ref = first.events.find((e) => e.event === "booking_confirmed")!.data.booking_ref;
  deps.chat = new ScriptedChat([[call("book_slot", { ...bookArgs(date, w), address_label: "Office" })], [
    text("Moved."),
  ]]);
  const moved = await turn(deps, input("make it Office instead"));
  const confirmed = moved.events.find((e) => e.event === "booking_confirmed")!.data;
  assertEquals([confirmed.booking_ref, confirmed.address_label], [ref, "Office"]);
  assertEquals(store.bookings.length, 1);
  assertEquals(store.bookings[0].address_label, "Office");
});
