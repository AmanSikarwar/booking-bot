import { parseSse } from "./sse.ts";

export interface ToolCall {
  id: string;
  type: "function";
  function: { name: string; arguments: string };
}

export type ChatMessage =
  | { role: "system" | "user"; content: string }
  | { role: "assistant"; content: string | null; tool_calls?: ToolCall[] }
  | { role: "tool"; tool_call_id: string; content: string };

export interface ToolSchema {
  type: "function";
  function: { name: string; description: string; parameters: Record<string, unknown> };
}

export interface ChatRequest {
  messages: ChatMessage[];
  tools?: ToolSchema[];
}

export interface Usage {
  model: string;
  input_tokens: number;
  output_tokens: number;
  cost_usd: number;
  latency_ms: number;
}

export type ChatChunk =
  | { type: "text"; delta: string }
  | { type: "tool_calls"; calls: ToolCall[] }
  | { type: "done"; usage: Usage };

export class LlmError extends Error {
  constructor(
    readonly code: "rate_limited" | "upstream_error",
    message: string,
    readonly retryAfter?: number,
    readonly latencyMs = 0,
  ) {
    super(message);
  }
}

export interface ChatModel {
  readonly model: string;
  stream(req: ChatRequest): AsyncGenerator<ChatChunk>;
}

export class OpenRouterChat implements ChatModel {
  constructor(
    private readonly apiKey: string,
    readonly model: string,
    private readonly fetchFn: typeof fetch = fetch,
  ) {}

  async *stream(req: ChatRequest): AsyncGenerator<ChatChunk> {
    const started = Date.now();
    const res = await this.#post(req, started);
    const calls = new Map<number, ToolCall>();
    let usage: Usage = { model: this.model, input_tokens: 0, output_tokens: 0, cost_usd: 0, latency_ms: 0 };
    for await (const e of parseSse(res.body!)) {
      if (e.data === "[DONE]") break;
      const chunk = JSON.parse(e.data);
      if (chunk.error) {
        throw new LlmError("upstream_error", chunk.error.message ?? "stream error", undefined, Date.now() - started);
      }
      if (chunk.model) usage.model = chunk.model;
      if (chunk.usage) {
        usage = {
          ...usage,
          input_tokens: chunk.usage.prompt_tokens ?? 0,
          output_tokens: chunk.usage.completion_tokens ?? 0,
          cost_usd: chunk.usage.cost ?? 0,
        };
      }
      const delta = chunk.choices?.[0]?.delta;
      if (delta?.content) yield { type: "text", delta: delta.content };
      for (const tc of delta?.tool_calls ?? []) {
        const i = tc.index ?? 0;
        const cur = calls.get(i) ?? { id: "", type: "function", function: { name: "", arguments: "" } };
        if (tc.id) cur.id = tc.id;
        if (tc.function?.name) cur.function.name += tc.function.name;
        if (tc.function?.arguments) cur.function.arguments += tc.function.arguments;
        calls.set(i, cur);
      }
    }
    if (calls.size) {
      yield {
        type: "tool_calls",
        calls: [...calls.entries()].sort(([a], [b]) => a - b).map(([i, c]) => ({ ...c, id: c.id || `call_${i}` })),
      };
    }
    yield { type: "done", usage: { ...usage, latency_ms: Date.now() - started } };
  }

  async #post(req: ChatRequest, started: number): Promise<Response> {
    const body = JSON.stringify({
      model: this.model,
      messages: req.messages,
      ...(req.tools?.length ? { tools: req.tools, tool_choice: "auto" } : {}),
      stream: true,
      temperature: 0.2,
      max_tokens: 400,
      provider: { require_parameters: true },
    });
    for (let attempt = 0; ; attempt++) {
      let res: Response;
      try {
        res = await this.fetchFn("https://openrouter.ai/api/v1/chat/completions", {
          method: "POST",
          headers: { Authorization: `Bearer ${this.apiKey}`, "Content-Type": "application/json" },
          body,
        });
      } catch (e) {
        if (attempt === 0) continue;
        throw new LlmError("upstream_error", String(e), undefined, Date.now() - started);
      }
      if (res.ok && res.body) return res;
      const detail = await res.text().catch(() => "");
      if (res.status === 429) {
        throw new LlmError("rate_limited", detail, Number(res.headers.get("retry-after")) || 20, Date.now() - started);
      }
      if (res.status >= 500 && attempt === 0) continue;
      throw new LlmError("upstream_error", `${res.status} ${detail}`.slice(0, 300), undefined, Date.now() - started);
    }
  }
}
