import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config.dart';
import '../../../core/db/database.dart';
import '../../safety/red_flag_detector.dart';
import '../domain/models.dart';
import 'outbox.dart';

@lazySingleton
class ChatRepository {
  ChatRepository(this._db, this._outbox, this._detector, this._clock, this._uuid);

  static const _currentKey = 'current_conversation';

  final AppDatabase _db;
  final Outbox _outbox;
  final RedFlagDetector _detector;
  final Clock _clock;
  final Uuid _uuid;

  Future<String> currentConversation(String locale) async {
    final id = await _db.meta(_currentKey);
    if (id != null) return id;
    return newConversation(locale);
  }

  Future<String> newConversation(String locale) async {
    final id = _uuid.v4();
    await _db.ensureConversation(id, locale, _clock.now());
    await _db.setMeta(_currentKey, id);
    return id;
  }

  Stream<List<Message>> watchMessages(String conversationId) => _db.watchMessages(conversationId);

  Stream<Conversation?> watchConversation(String conversationId) =>
      _db.watchConversation(conversationId);

  Future<void> submit({
    required String conversationId,
    required String text,
    required String locale,
    MessageKind kind = MessageKind.text,
    String? display,
  }) async {
    final id = _uuid.v4();
    final now = _clock.now();
    await _db.ensureConversation(conversationId, locale, now);
    await _db.upsertMessage(
      MessagesCompanion.insert(
        id: id,
        conversationId: conversationId,
        role: MessageRole.user,
        kind: Value(kind),
        locale: Value(locale),
        body: Value(text),
        display: Value(display),
        status: MessageStatus.queued,
        createdAt: now,
      ),
    );
    final hit = kind == MessageKind.text ? _detector.detect(text) : null;
    if (hit != null) {
      final category = hit.categories.first;
      await _db.upsertMessage(
        MessagesCompanion.insert(
          id: replyIdFor(id),
          conversationId: conversationId,
          role: MessageRole.assistant,
          locale: Value(locale),
          replyTo: Value(id),
          cards: Value([
            hit.outcome == RedFlagOutcome.urgent
                ? ChatCard.urgent(category)
                : ChatCard.crisis(category),
          ]),
          status: MessageStatus.sent,
          createdAt: now.add(const Duration(milliseconds: 1)),
        ),
      );
      await _db.flagConversation(conversationId);
    }
    _outbox.kick();
  }

  Future<void> openBookingForm({
    required String conversationId,
    required BookingFormData form,
    required String locale,
  }) async {
    final now = _clock.now();
    await _db.ensureConversation(conversationId, locale, now);
    await _db.upsertMessage(
      MessagesCompanion.insert(
        id: 'form:${_uuid.v4()}',
        conversationId: conversationId,
        role: MessageRole.assistant,
        locale: Value(locale),
        cards: Value([ChatCard.bookingForm(form)]),
        status: MessageStatus.sent,
        createdAt: now,
      ),
    );
  }

  Future<void> submitBookingForm({
    required String rowId,
    required int cardIndex,
    required SlotRequest request,
    required String text,
    required String locale,
    String? display,
  }) async {
    final row = await _db.message(rowId);
    if (row == null) return;
    final cards = [...row.cards];
    final card = cards[cardIndex];
    if (card is! BookingFormCard || card.form.submitted != null) return;
    cards[cardIndex] = ChatCard.bookingForm(card.form.copyWith(submitted: request));
    await _db.patchMessage(rowId, MessagesCompanion(cards: Value(cards)));
    await submit(
      conversationId: row.conversationId,
      text: text,
      locale: locale,
      kind: MessageKind.action,
      display: display,
    );
  }

  Future<void> retry(String messageId) async {
    await _db.patchMessage(
      messageId,
      const MessagesCompanion(
        status: Value(MessageStatus.queued),
        attempts: Value(0),
        nextAttemptAt: Value(null),
        error: Value(null),
      ),
    );
    _outbox.kick();
  }
}
