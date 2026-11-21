import { escalation, OpenRouterDecider, THRESHOLDS } from "../supabase/functions/chat/decider.ts";
import { RedFlagDetector } from "../supabase/functions/chat/redflag.ts";

const KEY = Deno.env.get("OPENROUTER_API_KEY");
if (!KEY) throw new Error("Set OPENROUTER_API_KEY, for example with --env-file=.env");
const models = Deno.args.length ? Deno.args : ["perplexity/pplx-decider-flash-v1.3:free", "typesafe/jev-1.13"];
const dir = new globalThis.URL(".", import.meta.url).pathname;

interface SafetyCase {
  text: string;
  locale: "en" | "hi";
  expected: "urgent" | "crisis" | "routine";
  group: string;
  history?: string[];
}
const cases: SafetyCase[] = JSON.parse(Deno.readTextFileSync(`${dir}cases/safety.json`));
const detector = new RedFlagDetector();
const deciders = models.map((m) => new OpenRouterDecider(KEY, m, fetch, 15_000));

const results = models.map(() => ({
  outcomes: [] as string[],
  probs: [] as string[],
  ms: [] as number[],
  tokens: [] as number[],
  cost: 0,
  errors: 0,
}));
for (const c of cases) {
  const hit = detector.detect(c.text);
  for (const [i, d] of deciders.entries()) {
    const r = results[i];
    if (hit && !hit.soft) {
      r.outcomes.push(hit.outcome);
      r.probs.push("keyword");
      continue;
    }
    const t = await d.triage([...(c.history ?? []), c.text].slice(-3), c.locale);
    if (!t.ok) {
      r.errors++;
      r.outcomes.push(hit?.outcome ?? `error: ${t.reason}`);
      r.probs.push("");
      continue;
    }
    r.outcomes.push(escalation(t.probs) ?? "routine");
    r.probs.push(`${t.probs.emergency.toFixed(2)} / ${t.probs.mental_health_crisis.toFixed(2)}`);
    r.ms.push(t.latencyMs);
    r.tokens.push(t.inputTokens);
    r.cost += t.costUsd;
  }
  Deno.stderr.writeSync(new TextEncoder().encode("."));
}
console.error();

const flagged = (o: string) => o === "urgent" || o === "crisis";
const quantile = (a: number[], q: number) =>
  [...a].sort((x, y) => x - y)[Math.min(a.length - 1, Math.floor(a.length * q))] ?? 0;
const pos = cases.filter((c) => c.expected !== "routine").length;
const row = (label: string, f: (r: typeof results[number]) => string | number) =>
  `| ${label} | ${results.map((r) => f(r)).join(" | ")} |`;
const cell = (s: string) => s.replace(/\|/g, "\\|");

const md = [
  `# Decider comparison`,
  ``,
  `Run ${
    new Date().toISOString()
  } straight against OpenRouter's Decisions API, outside the deployed function. Messages caught by a hard keyword match never reach a decider, as on the server. Multi-turn cases send up to the last three user messages. Thresholds: emergency ${THRESHOLDS.emergency}, crisis ${THRESHOLDS.mental_health_crisis}. The server gives up on the decider after ${THRESHOLDS.decider_timeout_ms} ms; this run waits up to 15 s to measure the tail.`,
  ``,
  `| | ${models.join(" | ")} |`,
  `|---|${models.map(() => "---").join("|")}|`,
  row(
    "Red flags caught",
    (r) => `${cases.filter((c, i) => c.expected !== "routine" && flagged(r.outcomes[i])).length}/${pos}`,
  ),
  row(
    "Right card",
    (r) => `${cases.filter((c, i) => c.expected !== "routine" && r.outcomes[i] === c.expected).length}/${pos}`,
  ),
  row(
    "False alarms",
    (r) => `${cases.filter((c, i) => c.expected === "routine" && flagged(r.outcomes[i])).length}/${cases.length - pos}`,
  ),
  row("Decider calls", (r) => r.ms.length),
  row("Errors", (r) => r.errors),
  row(
    "Latency p50 / p95 / max (ms)",
    (r) => `${quantile(r.ms, 0.5)} / ${quantile(r.ms, 0.95)} / ${Math.max(0, ...r.ms)}`,
  ),
  row(
    `Calls over ${THRESHOLDS.decider_timeout_ms} ms`,
    (r) => r.ms.filter((m) => m > THRESHOLDS.decider_timeout_ms).length,
  ),
  row("Median input tokens", (r) => quantile(r.tokens, 0.5)),
  row("Cost per call (USD)", (r) => (r.ms.length ? (r.cost / r.ms.length).toFixed(7) : "0")),
  row(
    "Highest emergency score on a routine message",
    (r) =>
      Math.max(
        0,
        ...cases.flatMap((c, i) =>
          c.expected === "routine" && r.probs[i].includes("/") ? [Number(r.probs[i].split(" / ")[0])] : []
        ),
      ).toFixed(2),
  ),
  ``,
  `Scores are emergency / crisis.`,
  ``,
  `| Message | Expected | ${models.join(" | ")} |`,
  `|---|---|${models.map(() => "---").join("|")}|`,
  ...cases.map((c, i) =>
    `| ${cell([...(c.history ?? []), c.text].join(" → "))} | ${c.expected} | ${
      results.map((r) => `${r.outcomes[i]}${r.outcomes[i] === c.expected ? "" : " ✗"} (${r.probs[i]})`).join(" | ")
    } |`
  ),
  ``,
];
Deno.writeTextFileSync(`${dir}RESULTS-decider.md`, md.join("\n"));
console.log(md.join("\n"));
