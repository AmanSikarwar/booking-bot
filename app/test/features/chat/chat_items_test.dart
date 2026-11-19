import 'package:flutter_chat_core/flutter_chat_core.dart' as fc;
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/chat/presentation/chat_items.dart';

final t0 = DateTime.utc(2026, 11, 20, 10);

Message row(
  String id, {
  MessageRole role = MessageRole.user,
  MessageStatus status = MessageStatus.sent,
  String body = 'hi',
  List<ChatCard> cards = const [],
  String? tool,
  String? error,
  int at = 0,
}) => Message(
  id: id,
  conversationId: 'c1',
  role: role,
  kind: MessageKind.text,
  locale: 'en',
  body: body,
  cards: cards,
  status: status,
  activeTool: tool,
  attempts: 0,
  error: error,
  createdAt: t0.add(Duration(seconds: at)),
);

List<String> ids(List<fc.Message> items) => [for (final m in items) m.id];

void main() {
  test('offline notice follows only the last queued message, and only when offline', () {
    final rows = [
      row('a', status: MessageStatus.queued),
      row('b', status: MessageStatus.queued, at: 1),
    ];
    expect(ids(toChatItems(rows, online: false)), ['a', 'b', 'b#notice']);
    expect(ids(toChatItems(rows, online: true)), ['a', 'b']);
  });

  test('quota notice shows even when online', () {
    final items = toChatItems([
      row('a', status: MessageStatus.queued, error: 'quota_exhausted'),
    ], online: true);
    expect((items.last as fc.CustomMessage).metadata!['code'], 'quota_exhausted');
  });

  test('assistant reply becomes text, then one item per card, then the tool chip', () {
    final reply = row(
      'reply:a',
      role: MessageRole.assistant,
      status: MessageStatus.streaming,
      body: 'These are commonly ordered.',
      cards: const [ChatCard.urgent('x'), ChatCard.crisis('y')],
      tool: 'search_packages',
    );
    expect(ids(toChatItems([reply], online: true)), [
      'reply:a',
      'reply:a#card0',
      'reply:a#card1',
      'reply:a#tool',
    ]);
  });

  test('empty streaming reply shows typing dots', () {
    final reply = row(
      'reply:a',
      role: MessageRole.assistant,
      status: MessageStatus.streaming,
      body: '',
    );
    expect(ids(toChatItems([reply], online: true)), ['reply:a#typing']);
  });

  test('synced controller applies inserts, updates and removals in order', () async {
    final c = SyncedChatController();
    final a = fc.Message.text(id: 'a', authorId: meId, text: 'one');
    final b = fc.Message.text(id: 'b', authorId: saathiId, text: 'tw');
    c.sync([a]);
    c.sync([a, b]);
    final b2 = fc.Message.text(id: 'b', authorId: saathiId, text: 'two');
    c.sync([a, b2]);
    c.sync([b2]);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(ids(c.messages), ['b']);
    expect((c.messages.single as fc.TextMessage).text, 'two');
    c.dispose();
  });
}
