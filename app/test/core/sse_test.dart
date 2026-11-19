import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/net/sse.dart';
import 'package:saathi/features/chat/domain/chat_event.dart';
import 'package:saathi/features/chat/domain/models.dart';

Stream<List<int>> chunked(String raw, int size) async* {
  final bytes = utf8.encode(raw);
  for (var i = 0; i < bytes.length; i += size) {
    yield bytes.sublist(i, i + size > bytes.length ? bytes.length : i + size);
  }
}

String sse(String event, Map<String, Object?> data) =>
    'event: $event\ndata: ${jsonEncode(data)}\n\n';

void main() {
  final pkg = {
    'id': 'pkg_thyroid_profile',
    'name': {'en': 'Thyroid Profile', 'hi': 'थायरॉइड प्रोफाइल'},
    'price_inr': 499,
    'mrp_inr': 799,
    'test_count': 3,
    'top_tests': ['T3', 'T4', 'TSH'],
    'fasting_hours': 0,
    'report_tat_hours': 24,
    'match_reason': {'en': 'Matches: thyroid', 'hi': 'इनसे मेल खाता है: thyroid'},
  };
  final raw = [
    sse('ack', {'client_message_id': 'm1', 'replay': false}),
    ': keepalive\n\n',
    sse('package_cards', {
      'query': 'thyroid',
      'packages': [pkg],
    }),
    sse('text_delta', {'text': 'जाँच '}),
    sse('booking_confirmed', {
      'booking_ref': 'LAB-7Q3K9',
      'package_id': 'pkg_thyroid_profile',
      'package_name': pkg['name'],
      'date': '2026-11-22',
      'time_window': '07-09',
      'address_label': 'Home',
      'patient_name': 'Priya',
      'status': 'confirmed',
      'fasting_hours': 0,
    }),
    sse('slot_unavailable', {
      'requested': {'date': '2026-11-22', 'time_window': '07-09'},
      'alternatives': [
        {'date': '2026-11-22', 'time_window': '09-11'},
      ],
      'package_id': 'pkg_thyroid_profile',
      'package_name': pkg['name'],
      'address_label': 'Home',
      'patient_name': 'Priya',
    }),
    sse('booking_form', {
      'package_id': 'pkg_thyroid_profile',
      'package_name': pkg['name'],
      'fasting_hours': 0,
      'prefill': {
        'date': '2026-11-22',
        'time_window': '07-09',
        'address_label': null,
        'patient_name': 'Priya',
      },
      'availability': {
        '2026-11-22': ['07-09', '09-11'],
      },
    }),
    sse('urgent_care', {
      'category': 'cardiac',
      'helplines': ['112', '108'],
    }),
    sse('error', {
      'code': 'quota_exhausted',
      'message': 'x',
      'retryable': true,
      'retry_after': 600,
    }),
    sse('done', {'assistant_message_id': 'a1', 'usage': {}}),
    'data: line1\r\ndata: line2\r\n\r\n',
  ].join();

  test('parses every server event across 5-byte chunks, including Devanagari splits', () async {
    final events = await parseSse(chunked(raw, 5))
        .map((m) => ChatEvent.parse(m.event, m.data))
        .toList();
    expect(events[0], const ChatEvent.ack(replay: false));
    final cards = (events[1] as CardEvent).card as PackagesCard;
    expect(
      [cards.packages.single.priceInr, cards.packages.single.topTests],
      [
        499,
        ['T3', 'T4', 'TSH'],
      ],
    );
    expect(events[2], const ChatEvent.textDelta('जाँच '));
    expect(((events[3] as CardEvent).card as BookingCardData).booking.bookingRef, 'LAB-7Q3K9');
    expect(
      ((events[4] as CardEvent).card as SlotsCard).offer.alternatives.single.timeWindow,
      '09-11',
    );
    expect((events[6] as CardEvent).card, const ChatCard.urgent('cardiac'));
    expect(
      events[7],
      const ChatEvent.error(code: 'quota_exhausted', retryable: true, retryAfter: 600),
    );
    final form = ((events[5] as CardEvent).card as BookingFormCard).form;
    expect(
      [form.prefill.patientName, form.prefill.timeWindow, form.prefill.addressLabel],
      ['Priya', '07-09', null],
    );
    expect(form.availability!['2026-11-22'], ['07-09', '09-11']);
    expect(events[8], const ChatEvent.done());
    expect(events.length, 9, reason: 'non-JSON multi-line data is ignored');
  });

  test('multi-line data joins with newlines', () async {
    final out = await parseSse(chunked('data: {"a":\ndata: 1}\n\n', 3)).toList();
    expect(out.single.data, {'a': 1});
    expect(out.single.event, 'message');
  });

  test('cards round-trip through JSON for storage', () {
    final card = ChatEvent.parse('package_cards', {
      'packages': [pkg],
    }) as CardEvent;
    expect(
      ChatCard.fromJson(jsonDecode(jsonEncode(card.card.toJson())) as Map<String, Object?>),
      card.card,
    );
  });
}
