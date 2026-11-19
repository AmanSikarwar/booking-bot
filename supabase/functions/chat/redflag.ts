import rawRules from "./_shared/red_flags.json" with { type: "json" };

export type RedFlagOutcome = "urgent" | "crisis";

export interface RedFlagResult {
  outcome: RedFlagOutcome;
  categories: string[];
  matches: string[];
}

interface RawRules {
  variants: Record<string, string>;
  categories: {
    id: string;
    outcome: RedFlagOutcome;
    phrases: string[];
    combos: string[][][];
  }[];
}

interface Category {
  id: string;
  outcome: RedFlagOutcome;
  phrases: string[];
  combos: string[][][];
}

export function normalize(text: string, variants: Record<string, string>): string {
  const cleaned = text
    .normalize("NFC")
    .toLowerCase()
    .replace(/़/g, "")
    .replace(/ँ/g, "ं")
    .replace(/['’`]/g, "")
    .replace(/[\p{P}\p{S}]/gu, " ")
    .replace(/\s+/g, " ")
    .trim();
  if (!cleaned) return "";
  return cleaned.split(" ").map((t) => variants[t] ?? t).join(" ");
}

export class RedFlagDetector {
  readonly #variants: Record<string, string>;
  readonly #categories: Category[];

  constructor(rules: RawRules = rawRules as RawRules) {
    this.#variants = rules.variants;
    const n = (s: string) => normalize(s, rules.variants);
    this.#categories = rules.categories.map((c) => ({
      id: c.id,
      outcome: c.outcome,
      phrases: c.phrases.map(n).filter(Boolean),
      combos: c.combos.map((groups) => groups.map((g) => g.map(n).filter(Boolean))),
    }));
  }

  detect(text: string): RedFlagResult | null {
    const norm = normalize(text, this.#variants);
    if (!norm) return null;
    const padded = ` ${norm}`;
    const tokens = norm.split(" ");
    const categories: string[] = [];
    const matches: string[] = [];
    let outcome: RedFlagOutcome | null = null;
    for (const c of this.#categories) {
      const phrase = c.phrases.find((p) => padded.includes(` ${p}`));
      const combo = phrase
        ? undefined
        : c.combos.find((groups) => groups.every((g) => g.some((w) => tokens.some((t) => t.startsWith(w)))));
      if (!phrase && !combo) continue;
      categories.push(c.id);
      matches.push(phrase ?? combo!.map((g) => g.find((w) => tokens.some((t) => t.startsWith(w)))).join("+"));
      if (c.outcome === "urgent" || outcome === null) outcome = c.outcome;
    }
    return outcome ? { outcome, categories, matches } : null;
  }
}
