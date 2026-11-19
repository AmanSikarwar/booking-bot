import { createClient } from "@supabase/supabase-js";
import { beginTurn, type Deps, runTurn, type TurnInput } from "./agent.ts";
import { Catalog } from "./catalog.ts";
import { OpenRouterDecider } from "./decider.ts";
import { OpenRouterChat } from "./llm.ts";
import { MockChat, MockDecider } from "./mocks.ts";
import { RedFlagDetector } from "./redflag.ts";
import { encodeEvent, type StreamEvent } from "./sse.ts";
import { SupabaseStore } from "./store.ts";

declare const EdgeRuntime: { waitUntil(p: Promise<unknown>): void } | undefined;

const env = (k: string) => Deno.env.get(k) ?? "";
const secretKey = env("SUPABASE_SECRET_KEYS")
  ? JSON.parse(env("SUPABASE_SECRET_KEYS")).default
  : env("SUPABASE_SERVICE_ROLE_KEY");
const admin = createClient(env("SUPABASE_URL"), secretKey, { auth: { persistSession: false } });
const mock = env("LLM_MODE") === "mock";

const deps: Deps = {
  store: new SupabaseStore(admin),
  chat: mock ? new MockChat() : new OpenRouterChat(
    env("OPENROUTER_API_KEY"),
    env("LLM_MODEL") || "google/gemma-4-26b-a4b-it:free",
    fetch,
    (env("LLM_FALLBACK_MODELS") || "google/gemma-4-31b-it:free,nvidia/nemotron-3.5-super-vl:free")
      .split(",").map((m) => m.trim()).filter(Boolean),
  ),
  decider: mock ? new MockDecider() : new OpenRouterDecider(
    env("OPENROUTER_API_KEY"),
    env("DECIDER_MODEL") || "perplexity/pplx-decider-flash-v1.3:free",
  ),
  detector: new RedFlagDetector(),
  catalog: new Catalog(),
  now: () => new Date(),
  newId: () => crypto.randomUUID(),
  limits: {
    userTurnsPerDay: Number(env("USER_TURNS_PER_DAY")) || 25,
    globalRequestsPerDay: Number(env("GLOBAL_REQUESTS_PER_DAY")) || 900,
    staleMs: 90_000,
  },
};

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, HEAD, OPTIONS",
};
const SSE_HEADERS = {
  ...CORS,
  "Content-Type": "text/event-stream",
  "Cache-Control": "no-cache",
  "X-Accel-Buffering": "no",
};

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function error(status: number, code: string, message: string, retryable = false) {
  return Response.json({ code, message, retryable }, { status, headers: CORS });
}

function parseBody(b: unknown, userId: string): TurnInput | null {
  if (!b || typeof b !== "object") return null;
  const o = b as Record<string, unknown>;
  const ok = typeof o.conversation_id === "string" && UUID.test(o.conversation_id) &&
    typeof o.client_message_id === "string" && UUID.test(o.client_message_id) &&
    (o.kind === undefined || o.kind === "text" || o.kind === "action") &&
    (o.locale === "en" || o.locale === "hi") &&
    typeof o.text === "string" && o.text.trim().length > 0 && o.text.length <= 2000;
  if (!ok) return null;
  return {
    userId,
    conversationId: (o.conversation_id as string).toLowerCase(),
    clientMessageId: (o.client_message_id as string).toLowerCase(),
    kind: (o.kind as "text" | "action") ?? "text",
    locale: o.locale as "en" | "hi",
    text: (o.text as string).trim(),
  };
}

function replayStream(clientMessageId: string, events: StreamEvent[]) {
  const all = [{ event: "ack", data: { client_message_id: clientMessageId, replay: true } }, ...events];
  return new ReadableStream<Uint8Array>({
    start(c) {
      for (const e of all) c.enqueue(encodeEvent(e));
      c.close();
    },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: CORS });
  if (req.method === "HEAD") return new Response(null, { status: 204, headers: CORS });
  if (req.method !== "POST") return error(405, "method_not_allowed", "use POST");

  const token = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "") ?? "";
  const { data: claims, error: authError } = token ? await admin.auth.getClaims(token) : { data: null, error: true };
  const userId = claims?.claims?.sub;
  if (authError || typeof userId !== "string") {
    return error(401, "unauthorized", "a valid session token is required", true);
  }

  let input: TurnInput | null;
  try {
    input = parseBody(await req.json(), userId);
  } catch {
    input = null;
  }
  if (!input) return error(400, "invalid_request", "invalid request body");

  try {
    const begin = await beginTurn(deps, input);
    if (begin.kind === "error") return error(begin.status, begin.code, begin.message, begin.status === 409);
    if (begin.kind === "replay") {
      return new Response(replayStream(input.clientMessageId, begin.events), { headers: SSE_HEADERS });
    }

    const { readable, writable } = new TransformStream<Uint8Array>();
    const writer = writable.getWriter();
    let open = true;
    const emit = (e: StreamEvent) => {
      if (open) writer.write(encodeEvent(e)).catch(() => (open = false));
    };
    const work = runTurn(deps, input, begin, emit).finally(() => {
      if (open) writer.close().catch(() => {});
    });
    if (typeof EdgeRuntime !== "undefined") EdgeRuntime.waitUntil(work);
    return new Response(readable, { headers: SSE_HEADERS });
  } catch (e) {
    console.error(e);
    return error(500, "server_error", "something went wrong", true);
  }
});
