import { CATEGORIES, type Locale } from "./catalog.ts";
import type { ToolSchema } from "./llm.ts";
import { bookableDates, TIME_WINDOWS } from "./slots.ts";

export const TOOLS: ToolSchema[] = [
  {
    type: "function",
    function: {
      name: "search_packages",
      description:
        "Search the lab's test package catalogue by symptom, health goal or test name. Returns up to 3 best matches. " +
        "Always call this before recommending any package.",
      parameters: {
        type: "object",
        properties: {
          query: { type: "string", description: "The user's goal, symptoms or test names, in any language" },
          category: { type: "string", enum: [...CATEGORIES], description: "Optional category to narrow the search" },
          max_price_inr: { type: "integer", description: "Optional price ceiling in rupees" },
          limit: { type: "integer", minimum: 1, maximum: 3, description: "Number of results, default 3" },
        },
        required: ["query"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "show_booking_form",
      description:
        "Show the user a booking form for one package, so they can pick date, time window, address and patient " +
        "name. Use this to collect booking details instead of asking for them in text. Pre-fill any details the " +
        "user already gave.",
      parameters: {
        type: "object",
        properties: {
          package_id: { type: "string", description: "A package id returned by search_packages" },
          date: { type: "string", description: "Optional YYYY-MM-DD the user asked for" },
          time_window: { type: "string", enum: [...TIME_WINDOWS] },
          address_label: { type: "string", description: "Optional, e.g. Home or Office" },
          patient_name: { type: "string", description: "Optional" },
        },
        required: ["package_id"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "book_slot",
      description:
        "Book a home sample collection. Only call after the user has explicitly confirmed the package, date, " +
        "time window, address label and patient name, for example by submitting the booking form.",
      parameters: {
        type: "object",
        properties: {
          package_id: { type: "string", description: "A package id returned by search_packages" },
          date: { type: "string", description: "YYYY-MM-DD, within the next 7 days" },
          time_window: { type: "string", enum: [...TIME_WINDOWS] },
          address_label: { type: "string", description: "e.g. Home or Office" },
          patient_name: { type: "string" },
        },
        required: ["package_id", "date", "time_window", "address_label", "patient_name"],
      },
    },
  },
];

const LANGUAGE: Record<Locale, string> = {
  en: "Reply in simple English.",
  hi: "Reply in simple spoken Hindi written in Devanagari. Keep English test names as-is (HbA1c, CBC, TSH). " +
    "Never reply in Hinglish or Roman script. Use 'aap', never 'tum'. Refer to yourself in the masculine form " +
    "(सकता हूँ, सुझाऊँगा).",
};

function weekday(iso: string): string {
  return new Date(`${iso}T00:00:00Z`).toLocaleDateString("en-IN", { weekday: "long", timeZone: "UTC" });
}

function calendar(now: Date): string {
  return bookableDates(now).map((d, i) => `${["today ", "tomorrow ", ""][Math.min(i, 2)]}${weekday(d)} ${d}`)
    .join(", ");
}

export interface AgentProfile {
  patients: { name: string; relation: string }[];
  addresses: string[];
}

const RELATIONS = ["self", "father", "mother", "spouse", "son", "daughter", "brother", "sister", "other"];
const clean = (s: unknown, max: number) => typeof s === "string" ? s.replace(/[\r\n`]/g, " ").trim().slice(0, max) : "";

export function parseProfile(raw: unknown): AgentProfile | undefined {
  if (!raw || typeof raw !== "object") return undefined;
  const o = raw as Record<string, unknown>;
  const patients = (Array.isArray(o.patients) ? o.patients : []).slice(0, 8).flatMap((p) => {
    const name = clean((p as Record<string, unknown>)?.name, 60);
    const relation = clean((p as Record<string, unknown>)?.relation, 12);
    return name && RELATIONS.includes(relation) ? [{ name, relation }] : [];
  });
  const addresses = (Array.isArray(o.addresses) ? o.addresses : []).slice(0, 6).map((a) => clean(a, 40)).filter(
    Boolean,
  );
  return patients.length || addresses.length ? { patients, addresses } : undefined;
}

function profileRules(p?: AgentProfile): string {
  if (!p) return "";
  const people = p.patients.map((x) =>
    `${x.name} (${x.relation === "self" ? "the user" : `the user's ${x.relation}`})`
  );
  return `- Saved patients: ${people.join(", ")}. Saved address labels: ${
    p.addresses.join(", ")
  }. When the user refers to themselves or a family member (for example "Papa", "my father", "मम्मी", "wife"), pre-fill show_booking_form with that saved patient's exact name, and use a saved address label when one fits. Never ask for details you already have here.\n`;
}

export function systemPrompt(locale: Locale, now: Date, flagged: boolean, profile?: AgentProfile): string {
  const ex = bookableDates(now)[2];
  return `You are Saathi, the diagnostic lab's AI booking assistant. You help users choose diagnostic test packages and book home sample collection. You are not a doctor, a nurse or a human; say so plainly if asked.

Rules:
- Never diagnose, never name a likely condition, never interpret results, never suggest medicines or doses. Say "These tests are commonly ordered when..." and "A doctor can help interpret your results."
- If the user describes possible emergency signs (chest pain, trouble breathing, fainting, stroke signs, heavy bleeding, seizures), tell them to seek urgent care now (call 112 or 108) and do not suggest or book tests.
- Always call search_packages before recommending. Never invent packages. Never write prices or test lists in your text; the cards show them.
- If the user only says who the tests are for or asks for a general checkup (for example "tests for my wife", "मेरी पत्नी के लिए जांच", "papa ka checkup"), call search_packages right away with that person and "checkup" instead of asking what they need.
- Mention at most 3 packages, one short line each, tied to what the user said.
- Only when the user explicitly asks to book or schedule a package, call show_booking_form (pre-filled with anything they said) instead of asking for details in text. After it, write one short line asking them to check the details and tap Confirm booking. After recommending packages, never show the form on your own; the cards already have a Book button.
- A user message in the form "Book <package> (<package_id>) on <YYYY-MM-DD> <window> at <address> for <name>." (or its Hindi version) comes from the booking form or a slot chip. It is the user's explicit confirmation: call book_slot right away with exactly those details.
- Otherwise, before calling book_slot, confirm package, date, time window, address label and patient name in one message, and book only after the user clearly says yes.
- Collection windows: ${TIME_WINDOWS.join(", ")}. Bookable dates (IST): ${calendar(now)}.
- Only discuss lab tests and bookings. Politely decline anything else.
${
    flagged
      ? "- This conversation was flagged for a possible emergency. Do not book anything; suggest starting a new chat for routine tests.\n"
      : ""
  }
${profileRules(profile)}
Voice: warm but brief, calm, clear, no emoji, under 80 words, at most one question per reply. No small talk.
${LANGUAGE[locale]}

Example 1
User: I feel tired all the time
(You call search_packages with query "tired all the time fatigue")
Saathi: These are commonly ordered when someone feels tired often. The first one checks thyroid levels, and the second covers vitamin D and B12. A doctor can help interpret your results.

Example 2
User: Book the thyroid one for ${weekday(ex)} morning at home, for Priya
(You call show_booking_form with package_id "pkg_thyroid_profile", date "${ex}", time_window "07-09", address_label "Home", patient_name "Priya")
Saathi: I've filled in what you told me. Please check the details and tap Confirm booking.
User: Book Thyroid Profile (pkg_thyroid_profile) on ${ex} 07-09 at Home for Priya.
(You call book_slot with package_id "pkg_thyroid_profile", date "${ex}", time_window "07-09", address_label "Home", patient_name "Priya")
Saathi: Done. Your sample collector will arrive ${weekday(ex)} between 7 and 9 am. No fasting needed for this one.`;
}

export const FALLBACK_REPLY: Record<Locale, string> = {
  en: "These packages are commonly ordered for what you described. Tap one to see the tests, or tell me more.",
  hi: "आपने जो बताया, उसके लिए ये पैकेज आमतौर पर करवाए जाते हैं। टेस्ट देखने के लिए किसी पर टैप करें, या मुझे और बताइए।",
};

export const EMPTY_REPLY: Record<Locale, string> = {
  en: "Tell me what you'd like to check, or how you've been feeling, and I'll suggest the right tests.",
  hi: "बताइए आप क्या जाँच करवाना चाहते हैं, या आपकी तबीयत कैसी है, मैं सही टेस्ट सुझाऊँगा।",
};

export const DISCLAIMER: Record<Locale, string> = {
  en: "\n\nThis is not a diagnosis. Please consult a doctor about your symptoms.",
  hi: "\n\nयह कोई निदान नहीं है। अपने लक्षणों के बारे में कृपया डॉक्टर से सलाह लें।",
};

const DIAGNOSIS_PATTERNS = [
  /\byou (?:probably |likely |may |might )?(?:have|are suffering from|are diagnosed with)\b/i,
  /\byou(?:'re| are) (?:diabetic|anemic|anaemic|hypothyroid|hyperthyroid)\b/i,
  /\bthis (?:is|sounds like|looks like) (?:a |an )?(?:sign of|symptom of|case of)\b/i,
  /आपको .{1,40} (?:है|हो सकता है|हो सकती है)/,
];

export function looksLikeDiagnosis(text: string): boolean {
  return DIAGNOSIS_PATTERNS.some((p) => p.test(text));
}
