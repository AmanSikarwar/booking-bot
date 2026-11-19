import { CATEGORIES, type Catalog, type SearchOptions } from "./catalog.ts";
import { isBookable, TIME_WINDOWS, type TimeWindow } from "./slots.ts";

export type Validated<T> = { ok: true; value: T } | { ok: false; error: string };

export interface SearchArgs extends SearchOptions {
  query: string;
}

export interface BookArgs {
  package_id: string;
  date: string;
  time_window: TimeWindow;
  address_label: string;
  patient_name: string;
}

function parse(raw: string): Record<string, unknown> | null {
  try {
    const v = JSON.parse(raw || "{}");
    return v && typeof v === "object" && !Array.isArray(v) ? v : null;
  } catch {
    return null;
  }
}

const text = (v: unknown, max = 200) => typeof v === "string" && v.trim() !== "" && v.length <= max;

export function validateSearch(raw: string): Validated<SearchArgs> {
  const a = parse(raw);
  if (!a) return { ok: false, error: "arguments must be a JSON object" };
  if (!text(a.query, 500)) return { ok: false, error: "query is required" };
  if (a.category != null && !CATEGORIES.includes(a.category as never)) {
    return { ok: false, error: `category must be one of ${CATEGORIES.join(", ")}` };
  }
  if (a.max_price_inr != null && !(Number.isInteger(a.max_price_inr) && (a.max_price_inr as number) > 0)) {
    return { ok: false, error: "max_price_inr must be a positive whole number" };
  }
  if (a.limit != null && !(Number.isInteger(a.limit) && (a.limit as number) >= 1 && (a.limit as number) <= 3)) {
    return { ok: false, error: "limit must be 1, 2 or 3" };
  }
  return {
    ok: true,
    value: {
      query: (a.query as string).trim(),
      category: a.category as string | undefined,
      max_price_inr: a.max_price_inr as number | undefined,
      limit: a.limit as number | undefined,
    },
  };
}

export function validateBook(raw: string, catalog: Catalog, now: Date): Validated<BookArgs> {
  const a = parse(raw);
  if (!a) return { ok: false, error: "arguments must be a JSON object" };
  if (typeof a.package_id !== "string" || !catalog.byId(a.package_id)) {
    return { ok: false, error: "package_id must be an id returned by search_packages" };
  }
  const window = typeof a.time_window === "string" ? a.time_window.replace(/[–—]/g, "-") : "";
  if (!TIME_WINDOWS.includes(window as TimeWindow)) {
    return { ok: false, error: `time_window must be one of ${TIME_WINDOWS.join(", ")}` };
  }
  if (typeof a.date !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(a.date)) {
    return { ok: false, error: "date must be YYYY-MM-DD" };
  }
  if (!isBookable(a.date, window as TimeWindow, now)) {
    return { ok: false, error: "date and time_window must be within the next 7 days and not already past (IST)" };
  }
  if (!text(a.address_label, 60)) return { ok: false, error: "address_label is required" };
  if (!text(a.patient_name, 80)) return { ok: false, error: "patient_name is required" };
  return {
    ok: true,
    value: {
      package_id: a.package_id,
      date: a.date,
      time_window: window as TimeWindow,
      address_label: (a.address_label as string).trim(),
      patient_name: (a.patient_name as string).trim(),
    },
  };
}
