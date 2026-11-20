import 'package:flutter_chat_core/flutter_chat_core.dart' as fc;

import '../../../core/db/database.dart';
import '../domain/models.dart';

const meId = 'me';
const saathiId = 'saathi';

const _noticeCodes = {'quota_exhausted', 'user_daily_limit'};

List<fc.Message> toChatItems(List<Message> rows, {required bool online}) {
  final items = <fc.Message>[];
  final lastQueued = rows.lastWhereOrNull(
    (r) => r.role == MessageRole.user && r.status == MessageStatus.queued,
  );
  final answered = {for (final r in rows) ?r.replyTo};
  for (final r in rows) {
    final at = r.createdAt;
    DateTime tick(int n) => at.add(Duration(microseconds: n));
    if (r.role == MessageRole.user) {
      items.add(
        fc.Message.text(
          id: r.id,
          authorId: meId,
          text: r.display ?? r.body,
          createdAt: at,
          metadata: {'status': r.status.name, 'error': r.error, 'kind': r.kind.name},
        ),
      );
      if ((r.status == MessageStatus.sending || r.status == MessageStatus.streaming) &&
          !answered.contains(r.id)) {
        items.add(_activity(replyIdFor(r.id), tick(2)));
      }
      final notice = _noticeCodes.contains(r.error)
          ? r.error
          : (!online && r.id == lastQueued?.id ? 'queued_offline' : null);
      if (notice != null) {
        items.add(
          fc.Message.custom(
            id: '${r.id}#notice',
            authorId: saathiId,
            createdAt: tick(1),
            metadata: {'kind': 'notice', 'code': notice},
          ),
        );
      }
      continue;
    }
    if (r.body.isNotEmpty) {
      items.add(
        fc.Message.text(
          id: r.id,
          authorId: saathiId,
          text: r.body,
          createdAt: at,
          metadata: {'status': r.status.name},
        ),
      );
    }
    final streaming = r.status == MessageStatus.streaming;
    for (final (i, card) in streaming ? const <(int, ChatCard)>[] : r.cards.indexed) {
      items.add(
        fc.Message.custom(
          id: '${r.id}#card$i',
          authorId: saathiId,
          createdAt: tick(i + 2),
          metadata: {'kind': 'card', 'card': card.toJson(), 'rowId': r.id, 'index': i},
        ),
      );
    }
    if (streaming) {
      items.add(_activity(r.id, tick(100), tool: r.activeTool, hasText: r.body.isNotEmpty));
    }
  }
  return items;
}

fc.Message _activity(String replyId, DateTime at, {String? tool, bool hasText = false}) =>
    fc.Message.custom(
      id: '$replyId#activity',
      authorId: saathiId,
      createdAt: at,
      metadata: {'kind': 'activity', 'tool': tool, 'hasText': hasText},
    );

class SyncedChatController extends fc.InMemoryChatController {
  Future<void> _pending = Future.value();

  void sync(List<fc.Message> next) {
    _pending = _pending.then((_) => _apply(next));
  }

  Future<void> _apply(List<fc.Message> next) async {
    if (messages.isEmpty || next.isEmpty) {
      await setMessages(next, animated: false);
      return;
    }
    final nextIds = {for (final m in next) m.id};
    for (final gone in messages.where((m) => !nextIds.contains(m.id)).toList()) {
      await removeMessage(gone);
    }
    for (final (i, m) in next.indexed) {
      final at = messages.indexWhere((c) => c.id == m.id);
      if (at == -1) {
        await insertMessage(m, index: i);
      } else if (messages[at] != m) {
        await updateMessage(messages[at], m);
      }
    }
  }
}

extension<T> on List<T> {
  T? lastWhereOrNull(bool Function(T) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }
}
