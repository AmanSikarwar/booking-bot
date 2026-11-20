import { assert, assertEquals, assertNotEquals } from "@std/assert";
import { Catalog } from "./catalog.ts";
import { alternatives, bookingRef, idempotencyKey, isBookable, isFull, istDate, spokenDate } from "./slots.ts";
import { validateBook, validateSearch } from "./validate.ts";
import { encodeEvent, parseSse } from "./sse.ts";

const catalog = new Catalog();
const now = new Date("2026-11-20T04:30:00Z");

Deno.test("search: thyroid goal ranks thyroid profile first", () => {
  assertEquals(catalog.search("I want to check my thyroid")[0].id, "pkg_thyroid_profile");
});

Deno.test("search: Hindi and Hinglish tags", () => {
  assertEquals(catalog.search("मुझे थायरॉइड टेस्ट करवाना है")[0].id, "pkg_thyroid_profile");
  assertEquals(catalog.search("Papa ke liye sugar test")[0].id, "pkg_diabetes_care");
});

Deno.test("search: tiredness and hair fall returns thyroid-related packages", () => {
  const ids = catalog.search("I feel tired and my hair is falling").map((r) => r.id);
  assert(ids.includes("pkg_thyroid_profile"), ids.join());
});

Deno.test("search: filters and limit", () => {
  const r = catalog.search("full body checkup", { max_price_inr: 1000 });
  assert(r.every((p) => p.price_inr <= 1000));
  assertEquals(catalog.search("tired", { limit: 1 }).length, 1);
  assert(catalog.search("tired", { category: "vitamins" }).every((p) => p.id === "pkg_vitamin_d_b12"));
});

Deno.test("search: no match falls back to general packages", () => {
  const r = catalog.search("zzzz");
  assert(r.length > 0 && r.every((p) => catalog.byId(p.id)!.category === "general"));
});

Deno.test("slots: dates are IST and limited to 7 days", () => {
  assertEquals(istDate(new Date("2026-11-20T19:00:00Z")), "2026-11-21");
  assert(isBookable("2026-11-27", "07-09", now));
  assert(!isBookable("2026-11-28", "07-09", now));
  assert(!isBookable("2026-11-19", "07-09", now));
  assert(!isBookable("2026-11-20", "09-11", now), "10:00 IST, 09-11 already started");
  assert(isBookable("2026-11-20", "16-18", now));
});

Deno.test("slots: some slots are full and alternatives skip them", () => {
  const full = ["2026-11-21", "2026-11-22", "2026-11-23", "2026-11-24", "2026-11-25"]
    .flatMap((d) => (["07-09", "09-11", "11-13", "16-18"] as const).map((w) => [d, w] as const))
    .filter(([d, w]) => isFull(d, w));
  assert(full.length > 0, "mock inventory should have at least one full slot");
  const [d, w] = full[0];
  const alts = alternatives(d, w, now);
  assertEquals(alts.length, 3);
  assert(alts.every((a) => !isFull(a.date, a.time_window) && !(a.date === d && a.time_window === w)));
});

Deno.test("slots: idempotency key and ref are stable", async () => {
  const parts = { userId: "u", packageId: "p", date: "2026-11-22", window: "07-09", patientName: "Priya " };
  const k1 = await idempotencyKey(parts);
  const k2 = await idempotencyKey({ ...parts, patientName: "priya" });
  assertEquals(k1, k2);
  assertEquals(bookingRef(k1), bookingRef(k2));
  assert(/^LAB-[2-9A-Z]{5}$/.test(bookingRef(k1)));
  assertNotEquals(k1, await idempotencyKey({ ...parts, window: "09-11" }));
});

Deno.test("validate: search args", () => {
  assert(validateSearch('{"query":"sugar"}').ok);
  assert(!validateSearch("not json").ok);
  assert(!validateSearch('{"query":""}').ok);
  assert(!validateSearch('{"query":"x","category":"bones"}').ok);
  assert(!validateSearch('{"query":"x","limit":5}').ok);
});

Deno.test("validate: book args", () => {
  const ok = validateBook(
    JSON.stringify({
      package_id: "pkg_thyroid_profile",
      date: "2026-11-22",
      time_window: "07–09",
      address_label: "Home",
      patient_name: "Priya",
    }),
    catalog,
    now,
  );
  assert(ok.ok && ok.value.time_window === "07-09");
  const base = {
    package_id: "pkg_thyroid_profile",
    date: "2026-11-22",
    time_window: "07-09",
    address_label: "Home",
    patient_name: "Priya",
  };
  assert(!validateBook(JSON.stringify({ ...base, package_id: "pkg_nope" }), catalog, now).ok);
  assert(!validateBook(JSON.stringify({ ...base, date: "2026-12-30" }), catalog, now).ok);
  assert(!validateBook(JSON.stringify({ ...base, time_window: "13-15" }), catalog, now).ok);
  assert(!validateBook(JSON.stringify({ ...base, patient_name: " " }), catalog, now).ok);
});

Deno.test("sse: parser handles chunk boundaries, comments and multi-line data", async () => {
  const text = encodeEvent({ event: "text_delta", data: { text: "hi" } });
  const raw = new TextDecoder().decode(text) + ": keepalive\n\ndata: line1\ndata: line2\n\n";
  const chunks = raw.match(/.{1,3}/gs)!;
  const stream = new ReadableStream<Uint8Array>({
    start(c) {
      for (const ch of chunks) c.enqueue(new TextEncoder().encode(ch));
      c.close();
    },
  });
  const out = [];
  for await (const e of parseSse(stream)) out.push(e);
  assertEquals(out, [
    { event: "text_delta", data: '{"text":"hi"}' },
    { event: undefined, data: "line1\nline2" },
  ]);
});

Deno.test("search: tags match whole words, so 'fat' does not match 'fatigue'", () => {
  const ids = catalog.search("tired all the time fatigue hair fall").map((r) => r.id);
  assert(!ids.includes("pkg_lipid_profile"), ids.join());
});

Deno.test("search: match reason drops tags contained in longer matched tags", () => {
  const r = catalog.search("full body checkup")[0];
  assertEquals(r.match_reason.en, "Matches: full body checkup");
});

Deno.test("slots: relative day words resolve to IST dates", () => {
  const now = new Date("2026-11-20T09:00:00Z");
  assertEquals(spokenDate("book thyroid one for papa for tommorow", now), "2026-11-21");
  assertEquals(spokenDate("papa ke liye kal subah", now), "2026-11-21");
  assertEquals(spokenDate("day after tomorrow please", now), "2026-11-22");
  assertEquals(spokenDate("aaj shaam", now), "2026-11-20");
  assertEquals(spokenDate("book thyroid on Sunday", now), undefined);
});
