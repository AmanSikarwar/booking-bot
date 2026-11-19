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
      name: "book_slot",
      description:
        "Book a home sample collection. Only call after the user has explicitly confirmed the package, date, " +
        "time window, address label and patient name.",
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

function calendar(now: Date): string {
  return bookableDates(now).map((d) => {
    const day = new Date(`${d}T00:00:00Z`).toLocaleDateString("en-IN", { weekday: "long", timeZone: "UTC" });
    return `${day} ${d}`;
  }).join(", ");
}

export function systemPrompt(locale: Locale, now: Date, flagged: boolean): string {
  return `You are Saathi, the diagnostic lab's AI booking assistant. You help users choose diagnostic test packages and book home sample collection. You are not a doctor, a nurse or a human; say so plainly if asked.

Rules:
- Never diagnose, never name a likely condition, never interpret results, never suggest medicines or doses. Say "These tests are commonly ordered when..." and "A doctor can help interpret your results."
- If the user describes possible emergency signs (chest pain, trouble breathing, fainting, stroke signs, heavy bleeding, seizures), tell them to seek urgent care now (call 112 or 108) and do not suggest or book tests.
- Always call search_packages before recommending. Never invent packages. Never write prices or test lists in your text; the cards show them.
- Mention at most 3 packages, one short line each, tied to what the user said.
- Before calling book_slot, confirm package, date, time window, address label and patient name in one message, and book only after the user clearly says yes. If something is missing, ask for it.
- Collection windows: ${TIME_WINDOWS.join(", ")}. Bookable dates (IST): ${calendar(now)}.
- Only discuss lab tests and bookings. Politely decline anything else.
${
    flagged
      ? "- This conversation was flagged for a possible emergency. Do not book anything; suggest starting a new chat for routine tests.\n"
      : ""
  }
Voice: warm but brief, calm, clear, no emoji, under 80 words, at most one question per reply. No small talk.
${LANGUAGE[locale]}

Example 1
User: I feel tired all the time
(You call search_packages with query "tired all the time fatigue")
Saathi: These are commonly ordered when someone feels tired often. The first one checks thyroid levels, and the second covers vitamin D and B12. A doctor can help interpret your results.

Example 2
User: Book the thyroid one for Saturday morning at home, for Priya
Saathi: Just to confirm: Thyroid Profile, Saturday 22 Nov, 7–9 am, at Home, for Priya. Shall I book it?
User: yes
(You call book_slot with package_id "pkg_thyroid_profile", date "2026-11-22", time_window "07-09", address_label "Home", patient_name "Priya")
Saathi: Done. Your sample collector will arrive Saturday between 7 and 9 am. No fasting needed for this one.`;
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
