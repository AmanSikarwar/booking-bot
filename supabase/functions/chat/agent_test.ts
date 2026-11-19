import { assert, assertEquals } from "@std/assert";
import { beginTurn, type Deps, runTurn, type TurnInput } from "./agent.ts";
import { Catalog } from "./catalog.ts";
import type { Triage } from "./decider.ts";
import type { ChatChunk, ChatModel, ChatRequest } from "./llm.ts";
import { MockChat, MockDecider } from "./mocks.ts";
import { systemPrompt } from "./prompt.ts";
import { RedFlagDetector } from "./redflag.ts";
import { isFull, TIME_WINDOWS } from "./slots.ts";
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

function setup(opts: { chat?: ChatModel; decider?: (m: string[]) => Triage; limits?: Partial<Deps["limits"]> } = {}) {
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
    limits: { userTurnsPerDay: 25, globalRequestsPerDay: 900, staleMs: 90_000, ...opts.limits },
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

Deno.test("quota: global budget exhausted keeps message retryable", async () => {
  const { deps, store } = setup({ limits: { globalRequestsPerDay: 0 } });
  const { events } = await turn(deps, input("sugar"));
  const err = events.find((e) => e.event === "error")!;
  assertEquals([err.data.code, err.data.retryable], ["quota_exhausted", true]);
  assertEquals(store.messages[0].status, "failed");
  assertEquals(store.usage.length, 0);
});

Deno.test("quota: red flags still work when quota is exhausted", async () => {
  const { deps } = setup({ limits: { globalRequestsPerDay: 0 } });
  assertEquals((await turn(deps, input("can't breathe"))).names, ["ack", "urgent_care", "done"]);
});

Deno.test("quota: per-user daily cap", async () => {
  const { deps } = setup({ limits: { userTurnsPerDay: 1 } });
  await turn(deps, input("sugar"));
  const { events } = await turn(deps, input("thyroid"));
  assertEquals(events.find((e) => e.event === "error")!.data.code, "user_daily_limit");
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
  const m = prompt.match(/Thyroid Profile, (\w+) (\d+) (\w+), 7–9 am[\s\S]*?date "(\d{4}-\d{2}-\d{2})"/)!;
  const [, day, , , iso] = m;
  assertEquals(day, new Date(`${iso}T00:00:00Z`).toLocaleDateString("en-IN", { weekday: "long", timeZone: "UTC" }));
  assertEquals(iso, "2026-11-22");
});
