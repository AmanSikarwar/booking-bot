import rawCatalog from "./_shared/packages.json" with { type: "json" };
import { normalize } from "./redflag.ts";

export type Locale = "en" | "hi";

export interface Package {
  id: string;
  name: { en: string; hi: string };
  category: string;
  tests: string[];
  test_count: number;
  price_inr: number;
  mrp_inr: number;
  fasting_hours: number;
  sample_type: string;
  report_tat_hours: number;
  tags: { en: string[]; hi: string[]; hinglish: string[] };
  description: { en: string; hi: string };
}

export const CATEGORIES = [
  "general", "diabetes", "thyroid", "heart", "liver", "kidney",
  "vitamins", "women", "senior", "fever", "fitness",
] as const;

export interface SearchOptions {
  category?: string;
  max_price_inr?: number;
  limit?: number;
}

export interface PackageResult {
  id: string;
  name: { en: string; hi: string };
  price_inr: number;
  mrp_inr: number;
  test_count: number;
  top_tests: string[];
  fasting_hours: number;
  report_tat_hours: number;
  match_reason: { en: string; hi: string };
}

const n = (s: string) => normalize(s, {});
const has = (padded: string, term: string) => term !== "" && padded.includes(` ${term}`);

export class Catalog {
  readonly version: number;
  readonly packages: Package[];

  constructor(raw: { version: number; packages: Package[] } = rawCatalog as never) {
    this.version = raw.version;
    this.packages = raw.packages;
  }

  byId(id: string): Package | undefined {
    return this.packages.find((p) => p.id === id);
  }

  search(query: string, opts: SearchOptions = {}): PackageResult[] {
    const padded = ` ${n(query)}`;
    const limit = Math.min(Math.max(opts.limit ?? 3, 1), 3);
    const pool = this.packages.filter((p) =>
      (!opts.category || p.category === opts.category) &&
      (opts.max_price_inr == null || p.price_inr <= opts.max_price_inr)
    );
    const scored = pool.map((p) => {
      const matched = new Set<string>();
      let score = 0;
      for (const tag of [...p.tags.en, ...p.tags.hi, ...p.tags.hinglish]) {
        const t = n(tag);
        if (has(padded, t)) {
          score += 2 * t.split(" ").length;
          matched.add(tag);
        }
      }
      for (const test of p.tests) {
        if (has(padded, n(test))) {
          score += 3;
          matched.add(test);
        }
      }
      if (has(padded, n(p.name.en)) || has(padded, n(p.name.hi))) score += 5;
      return { p, score, matched: [...matched] };
    }).filter((s) => s.score > 0);

    scored.sort((a, b) => b.score - a.score || a.p.price_inr - b.p.price_inr);
    const picked = scored.length
      ? scored.slice(0, limit)
      : pool.filter((p) => p.category === "general").slice(0, limit).map((p) => ({ p, score: 0, matched: [] }));
    return picked.map(({ p, matched }) => toResult(p, matched));
  }
}

function toResult(p: Package, matched: string[]): PackageResult {
  const terms = matched.slice(0, 3).join(", ");
  return {
    id: p.id,
    name: p.name,
    price_inr: p.price_inr,
    mrp_inr: p.mrp_inr,
    test_count: p.test_count,
    top_tests: p.tests.slice(0, 4),
    fasting_hours: p.fasting_hours,
    report_tat_hours: p.report_tat_hours,
    match_reason: terms
      ? { en: `Matches: ${terms}`, hi: `इनसे मेल खाता है: ${terms}` }
      : { en: "A good general checkup", hi: "एक अच्छी सामान्य जाँच" },
  };
}

export function forModel(results: PackageResult[], locale: Locale) {
  return results.map((r) => ({
    id: r.id,
    name: r.name[locale],
    test_count: r.test_count,
    top_tests: r.top_tests,
    fasting_hours: r.fasting_hours,
    match_reason: r.match_reason.en,
  }));
}
