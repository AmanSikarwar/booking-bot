import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/chat/domain/models.dart';

part 'database.g.dart';

enum MessageRole { user, assistant }

enum MessageKind { text, action }

enum MessageStatus { queued, sending, streaming, sent, failed, incomplete }

class CardListConverter extends TypeConverter<List<ChatCard>, String> {
  const CardListConverter();

  @override
  List<ChatCard> fromSql(String fromDb) => [
    for (final c in (jsonDecode(fromDb) as List).cast<Map<String, Object?>>()) ChatCard.fromJson(c),
  ];

  @override
  String toSql(List<ChatCard> value) => jsonEncode([for (final c in value) c.toJson()]);
}

class Conversations extends Table {
  TextColumn get id => text()();
  TextColumn get locale => text()();
  TextColumn get title => text().nullable()();
  BoolColumn get flagged => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text().references(Conversations, #id)();
  TextColumn get role => textEnum<MessageRole>()();
  TextColumn get kind => textEnum<MessageKind>().withDefault(const Constant('text'))();
  TextColumn get locale => text().withDefault(const Constant('en'))();
  TextColumn get body => text().withDefault(const Constant(''))();
  TextColumn get display => text().nullable()();
  TextColumn get cards => text().map(const CardListConverter()).withDefault(const Constant('[]'))();
  TextColumn get status => textEnum<MessageStatus>()();
  TextColumn get replyTo => text().nullable()();
  TextColumn get activeTool => text().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Bookings extends Table {
  TextColumn get bookingRef => text()();
  TextColumn get conversationId => text()();
  TextColumn get packageId => text()();
  TextColumn get packageNameEn => text()();
  TextColumn get packageNameHi => text()();
  TextColumn get slotDate => text()();
  TextColumn get timeWindow => text()();
  TextColumn get addressLabel => text()();
  TextColumn get patientName => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {bookingRef};
}

class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

String replyIdFor(String userMessageId) => 'reply:$userMessageId';

@DriftDatabase(tables: [Conversations, Messages, Bookings, AppMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'saathi',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.addColumn(messages, messages.display);
      if (from < 3) {
        await m.addColumn(conversations, conversations.title);
        await customStatement('''
          UPDATE conversations SET title = (
            SELECT COALESCE(display, body) FROM messages
            WHERE messages.conversation_id = conversations.id AND messages.role = 'user'
            ORDER BY messages.created_at LIMIT 1
          )''');
      }
    },
  );

  Future<String?> meta(String key) async =>
      (await (select(appMeta)..where((m) => m.key.equals(key))).getSingleOrNull())?.value;

  Stream<String?> watchMeta(String key) =>
      (select(appMeta)..where((m) => m.key.equals(key))).watchSingleOrNull().map((m) => m?.value);

  Future<void> setMeta(String key, String value) =>
      into(appMeta).insertOnConflictUpdate(AppMetaCompanion.insert(key: key, value: value));

  Future<void> ensureConversation(String id, String locale, DateTime now) =>
      into(conversations).insert(
        ConversationsCompanion.insert(id: id, locale: locale, createdAt: now, updatedAt: now),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> touchConversation(String id, String firstText, DateTime now) async {
    await (update(
      conversations,
    )..where((c) => c.id.equals(id))).write(ConversationsCompanion(updatedAt: Value(now)));
    await (update(conversations)..where((c) => c.id.equals(id) & c.title.isNull())).write(
      ConversationsCompanion(title: Value(firstText)),
    );
  }

  Stream<List<Conversation>> watchConversations() =>
      (select(conversations)
            ..where((c) => c.title.isNotNull())
            ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
          .watch();

  Stream<Conversation?> watchConversation(String id) =>
      (select(conversations)..where((c) => c.id.equals(id))).watchSingleOrNull();

  Future<void> flagConversation(String id) => (update(
    conversations,
  )..where((c) => c.id.equals(id))).write(const ConversationsCompanion(flagged: Value(true)));

  Stream<List<Message>> watchMessages(String conversationId) =>
      (select(messages)
            ..where((m) => m.conversationId.equals(conversationId))
            ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
          .watch();

  Future<Message?> message(String id) =>
      (select(messages)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<void> upsertMessage(MessagesCompanion m) => into(messages).insertOnConflictUpdate(m);

  Future<void> patchMessage(String id, MessagesCompanion patch) =>
      (update(messages)..where((m) => m.id.equals(id))).write(patch);

  Future<Message?> nextDue(DateTime now) async {
    final pending =
        await (select(messages)
              ..where(
                (m) =>
                    m.role.equalsValue(MessageRole.user) &
                    m.status.isInValues([
                      MessageStatus.queued,
                      MessageStatus.incomplete,
                      MessageStatus.sending,
                      MessageStatus.streaming,
                    ]),
              )
              ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
            .get();
    final waiting = <String>{};
    for (final m in pending) {
      if (!waiting.add(m.conversationId)) continue;
      final due = m.nextAttemptAt == null || !m.nextAttemptAt!.isAfter(now);
      final ready = m.status == MessageStatus.queued || m.status == MessageStatus.incomplete;
      if (ready && due) return m;
    }
    return null;
  }

  Future<DateTime?> earliestPendingAttempt() async {
    final row =
        await (select(messages)
              ..where(
                (m) =>
                    m.role.equalsValue(MessageRole.user) &
                    m.status.isInValues([MessageStatus.queued, MessageStatus.incomplete]) &
                    m.nextAttemptAt.isNotNull(),
              )
              ..orderBy([(m) => OrderingTerm.asc(m.nextAttemptAt)])
              ..limit(1))
            .getSingleOrNull();
    return row?.nextAttemptAt;
  }

  Future<void> resetInFlight() =>
      (update(messages)..where(
            (m) =>
                m.role.equalsValue(MessageRole.user) &
                m.status.isInValues([MessageStatus.sending, MessageStatus.streaming]),
          ))
          .write(const MessagesCompanion(status: Value(MessageStatus.queued)));

  Future<void> saveBooking(String conversationId, BookingInfo b, DateTime now) =>
      into(bookings).insertOnConflictUpdate(
        BookingsCompanion.insert(
          bookingRef: b.bookingRef,
          conversationId: conversationId,
          packageId: b.packageId,
          packageNameEn: b.packageName.en,
          packageNameHi: b.packageName.hi,
          slotDate: b.date,
          timeWindow: b.timeWindow,
          addressLabel: b.addressLabel,
          patientName: b.patientName,
          status: b.status,
          createdAt: now,
        ),
      );

  Stream<List<Booking>> watchBookings() => (select(
    bookings,
  )..orderBy([(b) => OrderingTerm.asc(b.slotDate), (b) => OrderingTerm.asc(b.timeWindow)])).watch();
}
