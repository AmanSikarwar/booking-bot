import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saathi/core/config.dart';
import 'package:saathi/core/connectivity/connectivity_service.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/data/chat_api.dart';
import 'package:saathi/features/chat/data/outbox.dart';
import 'package:saathi/features/chat/domain/chat_event.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/profile/profile_repository.dart';
import 'package:uuid/uuid.dart';

class MockApi extends Mock implements ChatApi {}

class MockConnectivity extends Mock implements ConnectivityService {}

class FixedClock extends Clock {
  DateTime current = DateTime.utc(2026, 11, 20, 4, 30);

  @override
  DateTime now() => current;

  @override
  double jitter() => 1;
}

const booking = BookingInfo(
  bookingRef: 'LAB-7Q3K9',
  packageId: 'pkg_thyroid_profile',
  packageName: Localized(en: 'Thyroid Profile', hi: 'थायरॉइड प्रोफाइल'),
  date: '2026-11-22',
  timeWindow: '07-09',
  addressLabel: 'Home',
  patientName: 'Priya',
  status: 'confirmed',
);

void main() {
  late AppDatabase db;
  late MockApi api;
  late MockConnectivity connectivity;
  late FixedClock clock;
  late Outbox outbox;
  final requests = <ChatRequest>[];

  setUpAll(
    () => registerFallbackValue(
      ChatRequest(
        conversationId: '',
        clientMessageId: '',
        kind: '',
        locale: '',
        text: '',
        createdAt: DateTime(2026),
      ),
    ),
  );

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = MockApi();
    connectivity = MockConnectivity();
    clock = FixedClock();
    when(() => connectivity.isOnline).thenReturn(true);
    when(() => connectivity.changes).thenAnswer((_) => const Stream.empty());
    when(() => connectivity.recheck()).thenAnswer((_) async {});
    outbox = Outbox(db, api, connectivity, clock, ProfileRepository(db, const Uuid()));
    requests.clear();
    await db.ensureConversation('c1', 'en', clock.now());
  });

  tearDown(() => db.close());

  Future<void> queue(String id, String text, {int secondsAgo = 0, String conversation = 'c1'}) =>
      db.upsertMessage(
        MessagesCompanion.insert(
          id: id,
          conversationId: conversation,
          role: MessageRole.user,
          body: Value(text),
          status: MessageStatus.queued,
          createdAt: clock.now().subtract(Duration(seconds: secondsAgo)),
        ),
      );

  void reply(List<ChatEvent> events, {Object? error}) {
    when(() => api.send(any())).thenAnswer((inv) {
      requests.add(inv.positionalArguments.first as ChatRequest);
      return error != null ? Stream.error(error) : Stream.fromIterable(events);
    });
  }

  Future<Message> msg(String id) async => (await db.message(id))!;

  test('streams text and cards into the reply, saves booking, marks sent', () async {
    await queue('m1', 'yes book it');
    reply([
      const ChatEvent.ack(replay: false),
      const ChatEvent.toolStarted('book_slot'),
      const ChatEvent.card(ChatCard.booking(booking)),
      const ChatEvent.textDelta('Done. '),
      const ChatEvent.textDelta('See you Saturday.'),
      const ChatEvent.done(),
    ]);
    expect(await outbox.drainOnce(), isTrue);
    expect((await msg('m1')).status, MessageStatus.sent);
    final r = await msg(replyIdFor('m1'));
    expect([r.body, r.status, r.activeTool], ['Done. See you Saturday.', MessageStatus.sent, null]);
    expect(r.cards.single, isA<BookingCardData>());
    expect((await db.watchBookings().first).single.bookingRef, 'LAB-7Q3K9');
    expect(requests.single.clientMessageId, 'm1');
  });

  test('tool activity survives its result card until the visible reply starts', () async {
    await queue('m1', 'yes book it');
    final replyId = replyIdFor('m1');
    when(() => api.send(any())).thenAnswer((_) async* {
      yield const ChatEvent.ack(replay: false);
      yield const ChatEvent.toolStarted('book_slot');
      yield const ChatEvent.card(ChatCard.booking(booking));
      expect((await msg(replyId)).activeTool, 'book_slot');
      yield const ChatEvent.textDelta('');
      expect((await msg(replyId)).activeTool, 'book_slot');
      yield const ChatEvent.textDelta('Done.');
      expect((await msg(replyId)).activeTool, isNull);
      yield const ChatEvent.done();
    });
    await outbox.drainOnce();
    expect((await msg('m1')).status, MessageStatus.sent);
  });

  test('sends oldest first, one at a time', () async {
    await queue('late', 'second');
    await queue('early', 'first', secondsAgo: 30);
    reply([const ChatEvent.ack(replay: false), const ChatEvent.done()]);
    await outbox.drainOnce();
    await outbox.drainOnce();
    expect(requests.map((r) => r.clientMessageId), ['early', 'late']);
    expect(await outbox.drainOnce(), isFalse);
  });

  test('a newer message waits while an older one in the same chat backs off', () async {
    await queue('a', 'first', secondsAgo: 30);
    await queue('b', 'second', secondsAgo: 10);
    await queue('other', 'elsewhere', secondsAgo: 5, conversation: 'c2');
    reply(const [], error: const ChatApiException(502, 'server_error', retryable: true));
    await outbox.drainOnce();
    expect((await msg('a')).nextAttemptAt, isNotNull);

    reply([const ChatEvent.ack(replay: false), const ChatEvent.done()]);
    await outbox.drainOnce();
    expect(requests.last.clientMessageId, 'other', reason: 'another chat is not held up');
    expect(await outbox.drainOnce(), isFalse, reason: 'b must not overtake a');

    clock.current = (await msg('a')).nextAttemptAt!;
    await outbox.drainOnce();
    await outbox.drainOnce();
    expect(requests.map((r) => r.clientMessageId), ['a', 'other', 'a', 'b']);
  });

  test('a failed message does not block later ones', () async {
    await queue('a', 'first', secondsAgo: 30);
    await queue('b', 'second');
    await db.patchMessage('a', const MessagesCompanion(status: Value(MessageStatus.failed)));
    reply([const ChatEvent.ack(replay: false), const ChatEvent.done()]);
    await outbox.drainOnce();
    expect(requests.single.clientMessageId, 'b');
  });

  test(
    'dropped stream marks incomplete, resend with same id replays without duplicating text',
    () async {
      await queue('m1', 'thyroid');
      reply([const ChatEvent.ack(replay: false), const ChatEvent.textDelta('These are ')]);
      await outbox.drainOnce();
      final m = await msg('m1');
      expect([m.status, m.attempts], [MessageStatus.incomplete, 1]);
      expect((await msg(replyIdFor('m1'))).status, MessageStatus.incomplete);

      clock.current = clock.current.add(const Duration(seconds: 2));
      reply([
        const ChatEvent.ack(replay: true),
        const ChatEvent.textDelta('These are '),
        const ChatEvent.textDelta('commonly ordered.'),
        const ChatEvent.done(),
      ]);
      await outbox.drainOnce();
      expect((await msg(replyIdFor('m1'))).body, 'These are commonly ordered.');
      expect(requests.map((r) => r.clientMessageId), ['m1', 'm1']);
    },
  );

  test('quota exhausted keeps the message queued without burning a retry', () async {
    await queue('m1', 'sugar');
    reply([
      const ChatEvent.ack(replay: false),
      const ChatEvent.error(code: 'quota_exhausted', retryable: true, retryAfter: 600),
      const ChatEvent.done(),
    ]);
    await outbox.drainOnce();
    final m = await msg('m1');
    expect([m.status, m.attempts, m.error], [MessageStatus.queued, 0, 'quota_exhausted']);
    expect(m.nextAttemptAt, clock.now().add(const Duration(seconds: 600)));
    expect(await db.message(replyIdFor('m1')), isNull);
    expect(await outbox.drainOnce(), isFalse, reason: 'not due yet');
  });

  test('retryable errors back off exponentially, then fail after 5 attempts', () async {
    await queue('m1', 'sugar');
    reply(const [], error: const ChatApiException(502, 'server_error', retryable: true));
    final waits = <int>[];
    for (var i = 0; i < 5; i++) {
      final before = await msg('m1');
      if (before.nextAttemptAt != null) clock.current = before.nextAttemptAt!;
      await outbox.drainOnce();
      final after = await msg('m1');
      if (after.nextAttemptAt != null) {
        waits.add(after.nextAttemptAt!.difference(clock.now()).inSeconds);
      }
    }
    expect(waits, [1, 2, 4, 8]);
    final m = await msg('m1');
    expect([m.status, m.attempts], [MessageStatus.failed, 5]);
  });

  test('a rate limit inside the stream waits retry_after without burning an attempt', () async {
    await queue('m1', 'sugar');
    reply([
      const ChatEvent.ack(replay: false),
      const ChatEvent.error(code: 'rate_limited', retryable: true, retryAfter: 20),
      const ChatEvent.done(),
    ]);
    for (var i = 0; i < 6; i++) {
      final before = await msg('m1');
      if (before.nextAttemptAt != null) clock.current = before.nextAttemptAt!;
      await outbox.drainOnce();
    }
    final m = await msg('m1');
    expect([m.status, m.attempts, m.error], [MessageStatus.queued, 0, 'rate_limited']);
    expect(m.nextAttemptAt!.difference(clock.now()), const Duration(seconds: 20));
  });

  test('HTTP 429 respects Retry-After without burning an attempt', () async {
    await queue('m1', 'sugar');
    reply(
      const [],
      error: const ChatApiException(429, 'rate_limited', retryable: true, retryAfter: 37),
    );
    await outbox.drainOnce();
    final m = await msg('m1');
    expect([m.status, m.attempts, m.error], [MessageStatus.queued, 0, 'rate_limited']);
    expect(m.nextAttemptAt, clock.now().add(const Duration(seconds: 37)));
    expect(await outbox.drainOnce(), isFalse);
  });

  test('backoff caps at 60 seconds', () {
    expect(outbox.backoff(10).inSeconds, 60);
  });

  test('invalid request fails immediately', () async {
    await queue('m1', 'x');
    reply(const [], error: const ChatApiException(400, 'invalid_request'));
    await outbox.drainOnce();
    expect((await msg('m1')).status, MessageStatus.failed);
  });

  test('in progress waits without counting an attempt', () async {
    await queue('m1', 'x');
    reply(const [], error: const ChatApiException(409, 'in_progress', retryable: true));
    await outbox.drainOnce();
    final m = await msg('m1');
    expect([m.status, m.attempts], [MessageStatus.queued, 0]);
  });

  test('network error rechecks connectivity', () async {
    await queue('m1', 'x');
    reply(const [], error: Exception('socket closed'));
    await outbox.drainOnce();
    verify(() => connectivity.recheck()).called(1);
    expect((await msg('m1')).error, 'network');
  });

  test('urgent card flags the conversation', () async {
    await queue('m1', 'my arm is numb');
    reply([
      const ChatEvent.ack(replay: false),
      const ChatEvent.card(ChatCard.urgent('decider')),
      const ChatEvent.done(),
    ]);
    await outbox.drainOnce();
    expect((await db.watchConversation('c1').first)!.flagged, isTrue);
  });

  test('messages stuck in flight after a restart are requeued', () async {
    await queue('m1', 'x');
    await db.patchMessage('m1', const MessagesCompanion(status: Value(MessageStatus.streaming)));
    await db.upsertMessage(
      MessagesCompanion.insert(
        id: replyIdFor('m1'),
        conversationId: 'c1',
        role: MessageRole.assistant,
        replyTo: const Value('m1'),
        body: const Value('These are'),
        status: MessageStatus.streaming,
        activeTool: const Value('search_packages'),
        createdAt: clock.now(),
      ),
    );
    await db.resetInFlight();
    expect((await msg('m1')).status, MessageStatus.queued);
    final reply = await msg(replyIdFor('m1'));
    expect([reply.status, reply.activeTool], [MessageStatus.incomplete, null]);
  });

  test('requests carry only names, relations and address labels from the profile', () async {
    await queue('m1', 'sugar test for papa');
    reply([const ChatEvent.ack(replay: false), const ChatEvent.done()]);
    await outbox.drainOnce();
    final profile = requests.single.toJson()['profile']! as Map<String, Object?>;
    expect(profile.keys, ['patients', 'addresses']);
    expect((profile['patients']! as List).first, {'name': 'Priya Sharma', 'relation': 'self'});
    expect(profile['addresses'], ['Home', 'Office', "Papa's house"]);
    expect(
      requests.single.toJson().toString(),
      isNot(contains('90000')),
      reason: 'no phone number',
    );
  });
}
