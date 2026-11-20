export const TIME_WINDOWS = ["07-09", "09-11", "11-13", "16-18"] as const;
export type TimeWindow = typeof TIME_WINDOWS[number];

const IST_OFFSET_MS = 330 * 60_000;

export function istDate(now: Date, addDays = 0): string {
  return new Date(now.getTime() + IST_OFFSET_MS + addDays * 86_400_000).toISOString().slice(0, 10);
}

function istHour(now: Date): number {
  return new Date(now.getTime() + IST_OFFSET_MS).getUTCHours();
}

export function bookableDates(now: Date): string[] {
  return Array.from({ length: 8 }, (_, i) => istDate(now, i));
}

export function isBookable(date: string, window: TimeWindow, now: Date): boolean {
  if (!bookableDates(now).includes(date)) return false;
  if (date === istDate(now)) return Number(window.slice(0, 2)) > istHour(now) + 1;
  return true;
}

function fnv1a(s: string): number {
  let h = 0x811c9dc5;
  for (let i = 0; i < s.length; i++) {
    h ^= s.charCodeAt(i);
    h = Math.imul(h, 0x01000193) >>> 0;
  }
  return h;
}

// ponytail: deterministic mock inventory, ~1 in 4 slots full; swap for a real slots table later
export function isFull(date: string, window: TimeWindow): boolean {
  return fnv1a(`${date}|${window}`) % 4 === 0;
}

export function alternatives(date: string, window: TimeWindow, now: Date, max = 3) {
  const out: { date: string; time_window: TimeWindow }[] = [];
  const dates = bookableDates(now).filter((d) => d >= date);
  for (const d of dates) {
    for (const w of TIME_WINDOWS) {
      if (d === date && w === window) continue;
      if (isBookable(d, w, now) && !isFull(d, w)) out.push({ date: d, time_window: w });
      if (out.length === max) return out;
    }
  }
  return out;
}

export async function idempotencyKey(parts: {
  userId: string;
  packageId: string;
  date: string;
  window: string;
  patientName: string;
}): Promise<string> {
  const raw = [parts.userId, parts.packageId, parts.date, parts.window, parts.patientName.trim().toLowerCase()]
    .join("|");
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(raw));
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

const REF_ALPHABET = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";

export const REF_VARIANTS = 6;

export function bookingRef(key: string, variant = 0): string {
  let ref = "LAB-";
  for (let i = 0; i < 5; i++) {
    const at = variant * 10 + i * 2;
    ref += REF_ALPHABET[parseInt(key.slice(at, at + 2), 16) % 32];
  }
  return ref;
}
