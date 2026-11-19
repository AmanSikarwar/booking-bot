import type { Decider, Triage } from "./decider.ts";
import type { ChatChunk, ChatModel, ChatRequest, ToolCall } from "./llm.ts";

const BOOK_ACTION = /(pkg_\w+)\D+(\d{4}-\d{2}-\d{2})\D+(\d{2}-\d{2}) at (.+?) for (.+?)\.?$/i;

export class MockChat implements ChatModel {
  readonly model = "mock/chat";

  async *stream(req: ChatRequest): AsyncGenerator<ChatChunk> {
    const last = req.messages[req.messages.length - 1];
    const usage = { model: this.model, input_tokens: 0, output_tokens: 0, cost_usd: 0, latency_ms: 0 };
    if (last.role === "tool") {
      yield* words(toolReply(last.content));
      yield { type: "done", usage };
      return;
    }
    const text = last.role === "user" ? last.content : "";
    const book = text.match(BOOK_ACTION);
    if (req.tools?.length) {
      const call: ToolCall = book
        ? {
          id: "mock_book",
          type: "function",
          function: {
            name: "book_slot",
            arguments: JSON.stringify({
              package_id: book[1],
              date: book[2],
              time_window: book[3],
              address_label: book[4],
              patient_name: book[5],
            }),
          },
        }
        : {
          id: "mock_search",
          type: "function",
          function: { name: "search_packages", arguments: JSON.stringify({ query: text }) },
        };
      yield { type: "tool_calls", calls: [call] };
    } else {
      yield* words("I can help you choose lab tests and book home collection.");
    }
    yield { type: "done", usage };
  }
}

function toolReply(content: string): string {
  const r = JSON.parse(content);
  if (r.status === "confirmed") return "Done. Your sample collector will arrive in the chosen window.";
  if (r.status === "unavailable") return "That slot's full. Here are the closest ones that are open.";
  if (r.error) return "I couldn't do that just now.";
  return "These are commonly ordered for what you described. A doctor can help interpret your results.";
}

async function* words(text: string): AsyncGenerator<ChatChunk> {
  for (const w of text.split(/(?<= )/)) yield { type: "text", delta: w };
}

export class MockDecider implements Decider {
  readonly model = "mock/decider";
  constructor(private readonly fn: (msgs: string[]) => Triage | Promise<Triage> = routine) {}
  triage(msgs: string[]): Promise<Triage> {
    return Promise.resolve(this.fn(msgs));
  }
}

function routine(): Triage {
  return {
    ok: true,
    probs: { emergency: 0.02, mental_health_crisis: 0.01, routine: 0.97 },
    model: "mock/decider",
    latencyMs: 0,
    inputTokens: 0,
    outputTokens: 0,
    costUsd: 0,
  };
}
