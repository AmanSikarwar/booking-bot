import { assert, assertEquals, assertRejects } from "@std/assert";
import { type ChatChunk, LlmError, OpenRouterChat } from "./llm.ts";
import { escalation, OpenRouterDecider } from "./decider.ts";
import { ModelQuotaExceeded, withModelBudget } from "./quota.ts";

function sseResponse(lines: string[], split = 7): Response {
  const raw = lines.map((l) => `data: ${l}\n\n`).join("");
  const parts = raw.match(new RegExp(`.{1,${split}}`, "gs"))!;
  return new Response(
    new ReadableStream({
      start(c) {
        for (const p of parts) c.enqueue(new TextEncoder().encode(p));
        c.close();
      },
    }),
    { status: 200, headers: { "content-type": "text/event-stream" } },
  );
}

async function collect(gen: AsyncGenerator<ChatChunk>) {
  const out: ChatChunk[] = [];
  for await (const c of gen) out.push(c);
  return out;
}

Deno.test("chat adapter: assembles fragmented tool calls in order", async () => {
  const chunks = [
    {
      model: "google/gemma",
      choices: [{ delta: { tool_calls: [{ index: 0, id: "a", function: { name: "search_", arguments: '{"que' } }] } }],
    },
    { choices: [{ delta: { tool_calls: [{ index: 1, id: "b", function: { name: "book_slot", arguments: "{}" } }] } }] },
    { choices: [{ delta: { tool_calls: [{ index: 0, function: { name: "packages", arguments: 'ry":"sugar"}' } }] } }] },
    { choices: [], usage: { prompt_tokens: 120, completion_tokens: 9, cost: 0 } },
  ].map((c) => JSON.stringify(c)).concat("[DONE]");
  const model = new OpenRouterChat("k", "google/gemma", () => Promise.resolve(sseResponse(chunks)));
  const out = await collect(model.stream({ messages: [{ role: "user", content: "sugar" }] }));
  const calls = out.find((c) => c.type === "tool_calls");
  assert(calls?.type === "tool_calls");
  assertEquals(calls.calls.map((c) => [c.id, c.function.name, c.function.arguments]), [
    ["a", "search_packages", '{"query":"sugar"}'],
    ["b", "book_slot", "{}"],
  ]);
  const done = out.at(-1);
  assert(done?.type === "done" && done.usage.input_tokens === 120 && done.usage.model === "google/gemma");
});

Deno.test("chat adapter: streams text deltas", async () => {
  const chunks = ["Hi ", "there"].map((t) => JSON.stringify({ choices: [{ delta: { content: t } }] })).concat("[DONE]");
  const model = new OpenRouterChat("k", "m", () => Promise.resolve(sseResponse(chunks, 3)));
  const text = (await collect(model.stream({ messages: [] }))).flatMap((c) => c.type === "text" ? [c.delta] : []);
  assertEquals(text.join(""), "Hi there");
});

Deno.test("chat adapter: 429 is a rate limit with retry-after, not retried", async () => {
  let calls = 0;
  const model = new OpenRouterChat("k", "m", () => {
    calls++;
    return Promise.resolve(new Response("slow down", { status: 429, headers: { "retry-after": "7" } }));
  });
  const err = await assertRejects(() => collect(model.stream({ messages: [] })), LlmError);
  assertEquals([err.code, err.retryAfter, calls], ["rate_limited", 7, 1]);
});

Deno.test("chat adapter: 5xx retried once then fails", async () => {
  let calls = 0;
  const model = new OpenRouterChat("k", "m", () => {
    calls++;
    return Promise.resolve(new Response("boom", { status: 502 }));
  });
  const err = await assertRejects(() => collect(model.stream({ messages: [] })), LlmError);
  assertEquals([err.code, calls], ["upstream_error", 2]);
});

Deno.test("model budget blocks upstream retries at the quota boundary", async () => {
  let reservations = 0;
  let requests = 0;
  const budgetedFetch = withModelBudget(
    () => Promise.resolve(++reservations === 1 ? null : { code: "quota_exhausted", retry_after: 120 }),
    () => {
      requests++;
      return Promise.resolve(new Response("upstream failure", { status: 502 }));
    },
  );
  const chat = new OpenRouterChat("k", "m", budgetedFetch);
  const err = await assertRejects(() => collect(chat.stream({ messages: [] })), ModelQuotaExceeded);
  assertEquals([err.retryAfter, requests, reservations], [120, 1, 2]);
});

Deno.test("chat adapter: mid-stream error chunk throws", async () => {
  const chunks = [
    JSON.stringify({ choices: [{ delta: { content: "Hi" } }] }),
    JSON.stringify({ error: { message: "provider died" } }),
  ];
  const model = new OpenRouterChat("k", "m", () => Promise.resolve(sseResponse(chunks)));
  await assertRejects(() => collect(model.stream({ messages: [] })), LlmError, "provider died");
});

const decision = (body: unknown, status = 200) => () => Promise.resolve(new Response(JSON.stringify(body), { status }));

Deno.test("decider: parses choice probabilities", async () => {
  const d = new OpenRouterDecider(
    "k",
    "pplx",
    decision({
      model: "perplexity/pplx-decider-flash-v1.3",
      answers: {
        urgency: {
          type: "choice",
          choice: "emergency",
          probabilities: { emergency: 0.8, mental_health_crisis: 0.05, routine: 0.15 },
        },
      },
      usage: { input_tokens: 50, output_tokens: 1, cost: 0 },
    }),
  );
  const t = await d.triage(["my left arm went numb"], "en");
  assert(t.ok && t.probs.emergency === 0.8 && t.model.startsWith("perplexity"));
});

Deno.test("decider: fails open on refusal, malformed, rate limit and timeout", async () => {
  const refusal = await new OpenRouterDecider("k", "m", decision({ answers: { urgency: { type: "refusal" } } })).triage(
    [],
    "en",
  );
  const malformed = await new OpenRouterDecider(
    "k",
    "m",
    decision({ answers: { urgency: { probabilities: { emergency: "high" } } } }),
  ).triage([], "en");
  const limited = await new OpenRouterDecider("k", "m", decision({}, 429)).triage([], "en");
  const slow = await new OpenRouterDecider(
    "k",
    "m",
    (_u, init) =>
      new Promise((_, reject) => init!.signal!.addEventListener("abort", () => reject(init!.signal!.reason))),
    20,
  ).triage([], "en");
  assertEquals([refusal, malformed, limited, slow].map((t) => !t.ok && t.reason), [
    "refusal",
    "malformed",
    "rate_limited",
    "timeout",
  ]);
});

Deno.test("decider: threshold boundaries", () => {
  assertEquals(escalation({ emergency: 0.45, mental_health_crisis: 0, routine: 0.55 }), "urgent");
  assertEquals(escalation({ emergency: 0.4499, mental_health_crisis: 0.25, routine: 0.3 }), "crisis");
  assertEquals(escalation({ emergency: 0.32, mental_health_crisis: 0.01, routine: 0.67 }), null);
  assertEquals(escalation({ emergency: 0.24, mental_health_crisis: 0.24, routine: 0.52 }), null);
  assertEquals(escalation({ emergency: 0.5, mental_health_crisis: 0.5, routine: 0 }), "urgent");
  assertEquals(escalation({ emergency: 0.3, mental_health_crisis: 0.7, routine: 0 }), "crisis");
});

Deno.test("chat adapter: sends fallback models after the primary", async () => {
  let sent: Record<string, unknown> = {};
  const model = new OpenRouterChat("k", "primary:free", (_u, init) => {
    sent = JSON.parse(init!.body as string);
    return Promise.resolve(sseResponse(["[DONE]"]));
  }, ["backup:free"]);
  await collect(model.stream({ messages: [] }));
  assertEquals([sent.model, sent.models], ["primary:free", ["primary:free", "backup:free"]]);
  assertEquals(sent.provider, { require_parameters: true });
});

Deno.test("chat adapter: models array is capped at 3 entries", async () => {
  let sent: Record<string, unknown> = {};
  const model = new OpenRouterChat("k", "p", (_u, init) => {
    sent = JSON.parse(init!.body as string);
    return Promise.resolve(sseResponse(["[DONE]"]));
  }, ["a", "b", "c"]);
  await collect(model.stream({ messages: [] }));
  assertEquals(sent.models, ["p", "a", "b"]);
});
