import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/domain/models.dart';

void main() {
  test('v1 database upgrades to v4, keeps messages and back-fills chat titles', () async {
    final dir = await Directory.systemTemp.createTemp('saathi_db');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/saathi.sqlite');
    final now = DateTime.utc(2026, 11, 20);

    final v2 = AppDatabase(NativeDatabase(file));
    await v2.ensureConversation('c1', 'en', now);
    await v2.upsertMessage(
      MessagesCompanion.insert(
        id: 'm1',
        conversationId: 'c1',
        role: MessageRole.user,
        body: const Value('sugar test'),
        status: MessageStatus.sent,
        createdAt: now,
      ),
    );
    await v2.customStatement('ALTER TABLE messages DROP COLUMN display');
    await v2.customStatement('ALTER TABLE conversations DROP COLUMN title');
    await v2.customStatement('ALTER TABLE bookings DROP COLUMN address_line');
    await v2.customStatement('PRAGMA user_version = 1');
    await v2.close();

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);
    final m = (await upgraded.message('m1'))!;
    expect([m.body, m.display], ['sugar test', null]);
    await upgraded.patchMessage('m1', const MessagesCompanion(display: Value('Sugar test')));
    expect((await upgraded.message('m1'))!.display, 'Sugar test');
    expect((await upgraded.watchConversations().first).single.title, 'sugar test');
    await upgraded.saveBooking(
      'c1',
      const BookingInfo(
        bookingRef: 'LAB-1',
        packageId: 'p',
        packageName: Localized(en: 'P', hi: 'P'),
        date: '2026-11-21',
        timeWindow: '07-09',
        addressLabel: 'Home',
        patientName: 'Priya',
        status: 'confirmed',
        addressLine: 'Flat 302',
      ),
      now,
    );
    expect((await upgraded.watchBookings().first).single.addressLine, 'Flat 302');
  });
}
