import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';

import '../../../core/config.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/db/database.dart';
import '../domain/chat_event.dart';
import '../domain/models.dart';
import '../../profile/profile.dart';
import '../../profile/profile_repository.dart';
import 'chat_api.dart';

@lazySingleton
class Outbox {
  Outbox(this._db, this._api, this._connectivity, this._clock, this._profile);

  static const maxAttempts = 5;
  static const _quotaCodes = {'quota_exhausted', 'user_daily_limit'};

  final AppDatabase _db;
  final ChatApi _api;
  final ConnectivityService _connectivity;
  final Clock _clock;
  final ProfileRepository _profile;
  StreamSubscription<bool>? _sub;
  Timer? _timer;
  bool _running = false;
  bool _again = false;

  Future<void> start() async {
    await _db.resetInFlight();
    _sub = _connectivity.changes.listen((online) {
      if (online) kick();
    });
    kick();
  }

  void kick() {
    if (_running) {
      _again = true;
      return;
    }
    unawaited(_run());
  }

  Future<void> _run() async {
    _running = true;
    try {
      do {
        _again = false;
        while (_connectivity.isOnline && await drainOnce()) {}
      } while (_again);
    } finally {
      _running = false;
    }
    await _schedule();
  }

  Future<void> _schedule() async {
    _timer?.cancel();
    final next = await _db.earliestPendingAttempt();
    if (next == null) return;
    final wait = next.difference(_clock.now());
    _timer = Timer(wait.isNegative ? Duration.zero : wait, kick);
  }

  Future<bool> drainOnce() async {
    final m = await _db.nextDue(_clock.now());
    if (m == null) return false;
    await send(m);
    return true;
  }

  Duration backoff(int attempts) {
    final seconds = min(60, 1 << (attempts - 1).clamp(0, 6));
    return Duration(milliseconds: (seconds * 1000 * _clock.jitter()).round());
  }

  Future<void> send(Message m) async {
    final replyId = replyIdFor(m.id);
    await _db.patchMessage(m.id, const MessagesCompanion(status: Value(MessageStatus.sending)));
    var body = '';
    var cards = <ChatCard>[];
    var done = false;
    ErrorEvent? error;
    try {
      final profile = (await _profile.current()).forAgent();
      final events = _api.send(
        ChatRequest(
          profile: profile,
          conversationId: m.conversationId,
          clientMessageId: m.id,
          kind: m.kind.name,
          locale: m.locale,
          text: m.body,
          createdAt: m.createdAt,
        ),
      );
      await for (final e in events) {
        switch (e) {
          case AckEvent():
            body = '';
            cards = [];
            await _db.patchMessage(
              m.id,
              const MessagesCompanion(status: Value(MessageStatus.streaming), error: Value(null)),
            );
            await _db.upsertMessage(
              MessagesCompanion.insert(
                id: replyId,
                conversationId: m.conversationId,
                role: MessageRole.assistant,
                locale: Value(m.locale),
                replyTo: Value(m.id),
                status: MessageStatus.streaming,
                activeTool: const Value(null),
                createdAt: m.createdAt.add(const Duration(milliseconds: 1)),
              ),
            );
          case TextDeltaEvent(:final text):
            if (text.isEmpty) continue;
            body += text;
            await _db.patchMessage(
              replyId,
              MessagesCompanion(body: Value(body), activeTool: const Value(null)),
            );
          case ToolStartedEvent(:final tool):
            await _db.patchMessage(replyId, MessagesCompanion(activeTool: Value(tool)));
          case CardEvent(card: final received):
            final card = await _withAddressLine(received);
            cards = [...cards, card];
            // A tool result may arrive in the same frame as its activity event.
            await _db.patchMessage(replyId, MessagesCompanion(cards: Value(cards)));
            switch (card) {
              case BookingCardData(:final booking):
                await _db.saveBooking(m.conversationId, booking, _clock.now());
              case UrgentCard() || CrisisCard():
                await _db.flagConversation(m.conversationId);
              default:
            }
          case ErrorEvent():
            error = e;
          case DoneEvent():
            done = true;
          case UnknownEvent():
        }
      }
    } on ChatApiException catch (e) {
      return _onHttpError(m, e);
    } on Object {
      await _markIncomplete(replyId);
      await _retryLater(m, 'network');
      return _connectivity.recheck();
    }

    if (error != null) {
      await _db.patchMessage(
        replyId,
        const MessagesCompanion(status: Value(MessageStatus.sent), activeTool: Value(null)),
      );
      if (body.isEmpty && cards.isEmpty) await _deleteReply(replyId);
      if (_quotaCodes.contains(error.code)) {
        return _waitWithoutAttempt(m, error.code, Duration(seconds: error.retryAfter ?? 3600));
      }
      final retryAfter = error.retryAfter;
      if (error.retryable && retryAfter != null && retryAfter > 0) {
        return _waitWithoutAttempt(m, error.code, Duration(seconds: retryAfter));
      }
      return error.retryable ? _retryLater(m, error.code) : _fail(m, error.code);
    }
    if (!done) {
      await _markIncomplete(replyId);
      return _retryLater(m, 'incomplete', status: MessageStatus.incomplete);
    }
    await _db.patchMessage(
      replyId,
      const MessagesCompanion(status: Value(MessageStatus.sent), activeTool: Value(null)),
    );
    await _db.patchMessage(
      m.id,
      const MessagesCompanion(
        status: Value(MessageStatus.sent),
        attempts: Value(0),
        nextAttemptAt: Value(null),
        error: Value(null),
      ),
    );
  }

  Future<void> _onHttpError(Message m, ChatApiException e) {
    if (e.status == 409) {
      return _waitWithoutAttempt(m, e.code, const Duration(seconds: 3));
    }
    final retryAfter = e.retryAfter;
    if (e.status == 429 && retryAfter != null) {
      return _waitWithoutAttempt(m, e.code, Duration(seconds: retryAfter));
    }
    return e.retryable ? _retryLater(m, e.code) : _fail(m, e.code);
  }

  Future<void> _retryLater(Message m, String code, {MessageStatus status = MessageStatus.queued}) {
    final attempts = m.attempts + 1;
    if (attempts >= maxAttempts) return _fail(m, code, attempts: attempts);
    return _db.patchMessage(
      m.id,
      MessagesCompanion(
        status: Value(status),
        attempts: Value(attempts),
        nextAttemptAt: Value(_clock.now().add(backoff(attempts))),
        error: Value(code),
      ),
    );
  }

  Future<void> _waitWithoutAttempt(Message m, String code, Duration wait) => _db.patchMessage(
    m.id,
    MessagesCompanion(
      status: const Value(MessageStatus.queued),
      nextAttemptAt: Value(_clock.now().add(wait)),
      error: Value(code),
    ),
  );

  Future<void> _fail(Message m, String code, {int? attempts}) => _db.patchMessage(
    m.id,
    MessagesCompanion(
      status: const Value(MessageStatus.failed),
      attempts: Value(attempts ?? m.attempts),
      nextAttemptAt: const Value(null),
      error: Value(code),
    ),
  );

  Future<ChatCard> _withAddressLine(ChatCard card) async {
    if (card is! BookingCardData || card.booking.addressLine != null) return card;
    final saved = (await _profile.current()).addressLabelled(card.booking.addressLabel);
    if (saved == null) return card;
    return ChatCard.booking(card.booking.copyWith(addressLine: fullAddress(saved)));
  }

  Future<void> _markIncomplete(String replyId) async {
    final reply = await _db.message(replyId);
    if (reply != null) {
      await _db.patchMessage(
        replyId,
        const MessagesCompanion(status: Value(MessageStatus.incomplete), activeTool: Value(null)),
      );
    }
  }

  Future<void> _deleteReply(String replyId) =>
      (_db.delete(_db.messages)..where((r) => r.id.equals(replyId))).go();

  @disposeMethod
  Future<void> dispose() async {
    _timer?.cancel();
    await _sub?.cancel();
  }
}
