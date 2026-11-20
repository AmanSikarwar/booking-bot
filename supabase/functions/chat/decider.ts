import thresholds from "./_shared/thresholds.json" with { type: "json" };
import type { Locale } from "./catalog.ts";

export type Probs = Record<"emergency" | "mental_health_crisis" | "routine", number>;

export type Triage =
  | {
    ok: true;
    probs: Probs;
    model: string;
    latencyMs: number;
    inputTokens: number;
    outputTokens: number;
    costUsd: number;
  }
  | { ok: false; reason: "timeout" | "rate_limited" | "upstream_error" | "malformed" | "refusal"; latencyMs: number };

export interface Decider {
  readonly model: string;
  triage(recentUserMessages: string[], locale: Locale): Promise<Triage>;
}

export const THRESHOLDS = thresholds;

export function escalation(probs: Probs, t = THRESHOLDS): "urgent" | "crisis" | null {
  if (probs.emergency >= t.emergency) return "urgent";
  if (probs.mental_health_crisis >= t.mental_health_crisis) return "crisis";
  return null;
}

const QUESTION = {
  type: "choice",
  instructions:
    "Classify how urgent the user's situation is, based on their recent messages to a diagnostic lab's booking assistant. " +
    "Messages may be in English, Hindi (Devanagari) or Hinglish. When unsure between emergency and routine, prefer emergency.",
  criteria: {
    emergency:
      "Symptoms that may need emergency care now: chest pain or pressure, difficulty breathing, fainting, stroke signs, " +
      "severe bleeding, seizures, coughing or vomiting blood, severe allergic swelling. Any language, including Hindi and Hinglish.",
    mental_health_crisis: "Mentions of self-harm, suicide, or wanting to die. Any language.",
    routine: "Routine health goals, mild or chronic symptoms, or questions about tests and bookings.",
  },
};

export class OpenRouterDecider implements Decider {
  constructor(
    private readonly apiKey: string,
    readonly model: string,
    private readonly fetchFn: typeof fetch = fetch,
    private readonly timeoutMs = THRESHOLDS.decider_timeout_ms,
  ) {}

  async triage(recentUserMessages: string[], locale: Locale): Promise<Triage> {
    const started = Date.now();
    const elapsed = () => Date.now() - started;
    let res: Response;
    try {
      res = await this.fetchFn("https://openrouter.ai/api/alpha/decisions", {
        method: "POST",
        headers: { Authorization: `Bearer ${this.apiKey}`, "Content-Type": "application/json" },
        body: JSON.stringify({
          model: this.model,
          state: { locale, recent_user_messages: recentUserMessages },
          questions: { urgency: QUESTION },
        }),
        signal: AbortSignal.timeout(this.timeoutMs),
      });
    } catch (e) {
      const timeout = e instanceof DOMException && (e.name === "TimeoutError" || e.name === "AbortError");
      return { ok: false, reason: timeout ? "timeout" : "upstream_error", latencyMs: elapsed() };
    }
    if (res.status === 429) return { ok: false, reason: "rate_limited", latencyMs: elapsed() };
    if (!res.ok) return { ok: false, reason: "upstream_error", latencyMs: elapsed() };
    try {
      const body = await res.json();
      const answer = body?.answers?.urgency;
      if (answer?.type === "refusal") return { ok: false, reason: "refusal", latencyMs: elapsed() };
      const p = answer?.probabilities ?? {};
      const probs = { emergency: p.emergency, mental_health_crisis: p.mental_health_crisis, routine: p.routine };
      if (!Object.values(probs).every((v) => typeof v === "number" && v >= 0 && v <= 1)) {
        return { ok: false, reason: "malformed", latencyMs: elapsed() };
      }
      return {
        ok: true,
        probs: probs as Probs,
        model: body.model ?? this.model,
        latencyMs: elapsed(),
        inputTokens: body.usage?.input_tokens ?? 0,
        outputTokens: body.usage?.output_tokens ?? 0,
        costUsd: body.usage?.cost ?? 0,
      };
    } catch {
      return { ok: false, reason: "malformed", latencyMs: elapsed() };
    }
  }
}
