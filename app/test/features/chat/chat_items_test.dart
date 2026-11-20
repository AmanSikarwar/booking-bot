import 'package:drift/drift.dart' show Value;
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
  String? display,
  int at = 0,
}) => Message(
  id: id,
  conversationId: 'c1',
  role: role,
  kind: MessageKind.text,
  locale: 'en',
  body: body,
  display: display,
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

  test('finished reply shows text first, then one item per card', () {
    final reply = row(
      'reply:a',
      role: MessageRole.assistant,
      body: 'These are commonly ordered.',
      cards: const [ChatCard.urgent('x'), ChatCard.crisis('y')],
    );
    expect(ids(toChatItems([reply], online: true)), ['reply:a', 'reply:a#card0', 'reply:a#card1']);
  });

  test('thinking, tool activity and typing share one indicator while cards wait', () {
    const cards = [ChatCard.urgent('x')];
    Message streaming({String body = '', String? tool}) => row(
      'reply:a',
      role: MessageRole.assistant,
      status: MessageStatus.streaming,
      body: body,
      cards: cards,
      tool: tool,
    );
    final thinking = toChatItems([streaming()], online: true).single as fc.CustomMessage;
    final tool =
        toChatItems([streaming(tool: 'search_packages')], online: true).single as fc.CustomMessage;
    final typing = toChatItems([streaming(body: 'These are ')], online: true);
    expect([thinking.id, tool.id], ['reply:a#activity', 'reply:a#activity']);
    expect(thinking.metadata, {'kind': 'activity', 'tool': null, 'hasText': false});
    expect(tool.metadata!['tool'], 'search_packages');
    expect(ids(typing), ['reply:a', 'reply:a#activity']);
    expect((typing.last as fc.CustomMessage).metadata!['hasText'], isTrue);
  });

  test('cards from an interrupted reply are still shown', () {
    final reply = row(
      'reply:a',
      role: MessageRole.assistant,
      status: MessageStatus.incomplete,
      body: 'These',
      cards: const [ChatCard.urgent('x')],
      tool: 'search_packages',
    );
    expect(ids(toChatItems([reply], online: true)), ['reply:a', 'reply:a#card0']);
  });

  test('a completed card-only reply omits stale tool activity', () {
    final reply = row(
      'reply:a',
      role: MessageRole.assistant,
      body: '',
      cards: const [ChatCard.urgent('x')],
      tool: 'book_slot',
    );
    expect(ids(toChatItems([reply], online: true)), ['reply:a#card0']);
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

  test('action bubbles show the friendly display text, not the structured body', () {
    final item =
        toChatItems([
              row(
                'a',
                body: 'Book X (pkg_x) on 2026-11-21 07-09 at Home for Priya.',
                display: 'X · Sat 21 Nov',
              ),
            ], online: true).single
            as fc.TextMessage;
    expect(item.text, 'X · Sat 21 Nov');
  });

  test('activity appears before acknowledgement and keeps its id after acknowledgement', () {
    expect(ids(toChatItems([row('a', status: MessageStatus.sending)], online: true)), [
      'a',
      'reply:a#activity',
    ]);
    final withReply = [
      row('a', status: MessageStatus.streaming),
      row(
        'reply:a',
        role: MessageRole.assistant,
        status: MessageStatus.streaming,
        body: '',
        at: 1,
      ).copyWith(replyTo: const Value('a')),
    ];
    expect(ids(toChatItems(withReply, online: true)), ['a', 'reply:a#activity']);
  });
}
