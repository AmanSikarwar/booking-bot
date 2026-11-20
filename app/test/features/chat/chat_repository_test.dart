import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saathi/core/config.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/features/chat/data/chat_repository.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/data/outbox.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/safety/red_flag_detector.dart';
import 'package:uuid/uuid.dart';

class MockOutbox extends Mock implements Outbox {}

void main() {
  late AppDatabase db;
  late MockOutbox outbox;
  late ChatRepository repo;
  final detector = RedFlagDetector(
    jsonDecode(File('assets/shared/red_flags.json').readAsStringSync()) as Map<String, Object?>,
  );

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    outbox = MockOutbox();
    repo = ChatRepository(db, outbox, detector, Clock(), const Uuid());
  });

  tearDown(() => db.close());

  test(
    'red flag typed offline shows the urgent card at once and still queues the message',
    () async {
      final c = await repo.newConversation('hi');
      await repo.submit(conversationId: c, text: 'सीने में दर्द हो रहा है', locale: 'hi');
      final rows = await repo.watchMessages(c).first;
      expect(rows.map((r) => r.role), [MessageRole.user, MessageRole.assistant]);
      expect(rows.first.status, MessageStatus.queued);
      expect(rows.last.cards.single, const ChatCard.urgent('cardiac'));
      expect(rows.last.id, replyIdFor(rows.first.id));
      expect((await repo.watchConversation(c).first)!.flagged, isTrue);
      verify(() => outbox.kick()).called(1);
    },
  );

  test('self-harm shows the crisis card', () async {
    final c = await repo.newConversation('en');
    await repo.submit(conversationId: c, text: 'I want to kill myself', locale: 'en');
    expect((await repo.watchMessages(c).first).last.cards.single, isA<CrisisCard>());
  });

  test('routine message is only queued', () async {
    final c = await repo.newConversation('en');
    await repo.submit(conversationId: c, text: 'sugar test for papa', locale: 'en');
    final rows = await repo.watchMessages(c).first;
    expect(rows.single.status, MessageStatus.queued);
    expect((await repo.watchConversation(c).first)!.flagged, isFalse);
  });

  test('soft keyword match is queued for the server to triage, with no local card', () async {
    final c = await repo.newConversation('en');
    await repo.submit(
      conversationId: c,
      text: 'My father had a heart attack two years ago, which tests should he do?',
      locale: 'en',
    );
    final rows = await repo.watchMessages(c).first;
    expect(rows.single.status, MessageStatus.queued);
    expect((await repo.watchConversation(c).first)!.flagged, isFalse);
  });

  test('card actions skip the local check', () async {
    final c = await repo.newConversation('en');
    await repo.submit(
      conversationId: c,
      text: 'I want to book Heart Risk Screening for chest pain history',
      locale: 'en',
      kind: MessageKind.action,
    );
    expect((await repo.watchMessages(c).first).length, 1);
  });

  test('current conversation persists, new chat replaces it', () async {
    final first = await repo.currentConversation('en');
    expect(await repo.currentConversation('en'), first);
    final second = await repo.newConversation('en');
    expect(await repo.currentConversation('en'), second);
  });

  test('retry requeues a failed message with a fresh attempt count', () async {
    final c = await repo.newConversation('en');
    await repo.submit(conversationId: c, text: 'x', locale: 'en');
    final id = (await repo.watchMessages(c).first).single.id;
    await db.patchMessage(
      id,
      const MessagesCompanion(status: Value(MessageStatus.failed), attempts: Value(5)),
    );
    await repo.retry(id);
    final m = (await db.message(id))!;
    expect([m.status, m.attempts], [MessageStatus.queued, 0]);
  });

  test('booking form opens locally, submits once, and queues the structured action', () async {
    final c = await repo.newConversation('en');
    await repo.openBookingForm(
      conversationId: c,
      form: const BookingFormData(
        packageId: 'pkg_thyroid_profile',
        packageName: Localized(en: 'Thyroid Profile', hi: 'थायरॉइड प्रोफाइल'),
      ),
      locale: 'en',
    );
    final formRow = (await repo.watchMessages(c).first).single;
    expect(formRow.role, MessageRole.assistant);
    const request = SlotRequest(
      date: '2026-11-22',
      timeWindow: '07-09',
      addressLabel: 'Home',
      patientName: 'Priya',
    );
    for (var i = 0; i < 2; i++) {
      await repo.submitBookingForm(
        rowId: formRow.id,
        cardIndex: 0,
        request: request,
        text: 'Book Thyroid Profile (pkg_thyroid_profile) on 2026-11-22 07-09 at Home for Priya.',
        locale: 'en',
      );
    }
    final rows = await repo.watchMessages(c).first;
    expect((rows.first.cards.single as BookingFormCard).form.submitted, request);
    final sent = rows.where((r) => r.role == MessageRole.user).toList();
    expect(sent.single.kind, MessageKind.action);
    expect(sent.single.status, MessageStatus.queued);
    verify(() => outbox.kick()).called(1);
  });

  test('chat history: titled by the first message, newest first, empty chats hidden', () async {
    final clock = _StepClock();
    final r = ChatRepository(db, outbox, detector, clock, const Uuid());
    final a = await r.newConversation('en');
    await r.submit(conversationId: a, text: 'sugar test for papa', locale: 'en');
    final b = await r.newConversation('en');
    await r.submit(conversationId: b, text: 'thyroid', locale: 'en');
    await r.submit(conversationId: b, text: 'book it', locale: 'en');
    await r.newConversation('en');
    var chats = await r.watchConversations().first;
    expect([for (final c in chats) c.title], ['thyroid', 'sugar test for papa']);
    await r.submit(conversationId: a, text: 'any cheaper?', locale: 'en');
    chats = await r.watchConversations().first;
    expect([for (final c in chats) c.title], ['sugar test for papa', 'thyroid']);
    await r.switchTo(b);
    expect(await r.currentConversation('en'), b);
  });
}

class _StepClock extends Clock {
  var _t = DateTime.utc(2026, 11, 20);

  @override
  DateTime now() => _t = _t.add(const Duration(seconds: 1));
}
