import {
  assistantHistoryText,
  type BookingRow,
  type Conversation,
  type HistoryTurn,
  type SafetyCheck,
  type Store,
  type UsageRow,
} from "./store.ts";
import type { StreamEvent } from "./sse.ts";

interface Row {
  id: string;
  conversation_id: string;
  user_id: string;
  client_message_id?: string;
  reply_to?: string;
  role: "user" | "assistant";
  kind: "text" | "action";
  text: string;
  events?: StreamEvent[];
  status: "processing" | "completed" | "failed";
  created_at: string;
  updated_at: string;
}

export class MemoryStore implements Store {
  conversations = new Map<string, Conversation>();
  messages: Row[] = [];
  bookings: BookingRow[] = [];
  safety: SafetyCheck[] = [];
  usage: (UsageRow & { created_at: string })[] = [];
  #seq = 0;

  constructor(private readonly clock: () => Date = () => new Date()) {}

  #ts() {
    return new Date(this.clock().getTime() + this.#seq++).toISOString();
  }

  getConversation(id: string) {
    const c = this.conversations.get(id);
    return Promise.resolve(c ? { ...c } : null);
  }
  createConversation(c: Conversation) {
    if (!this.conversations.has(c.id)) this.conversations.set(c.id, { ...c });
    return Promise.resolve();
  }
  flagConversation(id: string) {
    this.conversations.get(id)!.flagged = true;
    return Promise.resolve();
  }
  findUserMessage(conversationId: string, clientMessageId: string) {
    const m = this.messages.find((r) =>
      r.conversation_id === conversationId && r.client_message_id === clientMessageId
    );
    return Promise.resolve(m ? { id: m.id, status: m.status, updated_at: m.updated_at } : null);
  }
  insertUserMessage(m: Parameters<Store["insertUserMessage"]>[0]) {
    if (
      this.messages.some((r) => r.conversation_id === m.conversation_id && r.client_message_id === m.client_message_id)
    ) {
      return Promise.resolve("conflict" as const);
    }
    const ts = this.#ts();
    this.messages.push({ ...m, role: "user", status: "processing", created_at: ts, updated_at: ts });
    return Promise.resolve("inserted" as const);
  }
  setUserMessageStatus(id: string, status: Row["status"]) {
    const m = this.messages.find((r) => r.id === id)!;
    m.status = status;
    m.updated_at = this.#ts();
    return Promise.resolve();
  }
  claimStale(id: string, staleBefore: string) {
    const m = this.messages.find((r) => r.id === id)!;
    if (m.status === "failed" || (m.status === "processing" && m.updated_at < staleBefore)) {
      m.status = "processing";
      m.updated_at = this.#ts();
      return Promise.resolve(true);
    }
    return Promise.resolve(false);
  }
  saveAssistantReply(r: Parameters<Store["saveAssistantReply"]>[0]) {
    this.messages = this.messages.filter((m) => m.reply_to !== r.reply_to);
    const ts = this.#ts();
    this.messages.push({ ...r, role: "assistant", kind: "text", status: "completed", created_at: ts, updated_at: ts });
    return Promise.resolve();
  }
  replyEvents(userMessageId: string) {
    return Promise.resolve(this.messages.find((m) => m.reply_to === userMessageId)?.events ?? null);
  }
  history(conversationId: string, excludeId: string, turns: number): Promise<HistoryTurn[]> {
    const rows = this.messages.filter((m) => m.conversation_id === conversationId && m.id !== excludeId).slice(
      -turns * 2,
    );
    return Promise.resolve(
      rows.filter((r) => r.role === "assistant" || r.status === "completed")
        .map((r) => ({
          role: r.role,
          text: r.role === "assistant" ? assistantHistoryText({ text: r.text, events: r.events }) : r.text,
        })),
    );
  }
  recentUserTexts(conversationId: string, n: number) {
    return Promise.resolve(
      this.messages.filter((m) => m.conversation_id === conversationId && m.role === "user" && m.kind === "text")
        .slice(-n).map((m) => m.text),
    );
  }
  bookingSafetyMessages(conversationId: string, n: number) {
    return Promise.resolve(
      this.messages.filter((m) => m.conversation_id === conversationId && m.role === "user" && m.kind === "text")
        .slice(-n).map((m) => ({ text: m.text, checks: this.safety.filter((check) => check.message_id === m.id) })),
    );
  }
  findBooking(key: string) {
    return Promise.resolve(this.bookings.find((b) => b.idempotency_key === key) ?? null);
  }
  insertBooking(b: BookingRow) {
    const existing = this.bookings.find((x) => x.idempotency_key === b.idempotency_key);
    if (existing) return Promise.resolve(existing);
    this.bookings.push(b);
    return Promise.resolve(b);
  }
  logSafety(s: SafetyCheck) {
    this.safety.push(s);
    return Promise.resolve();
  }
  logUsage(u: UsageRow) {
    this.usage.push({ ...u, created_at: this.#ts() });
    return Promise.resolve();
  }
  usageCountSince(since: string) {
    return Promise.resolve(this.usage.filter((u) => u.created_at >= since).length);
  }
  userTurnsSince(userId: string, since: string) {
    return Promise.resolve(
      this.messages.filter((m) => m.user_id === userId && m.role === "user" && m.created_at >= since).length,
    );
  }
}
