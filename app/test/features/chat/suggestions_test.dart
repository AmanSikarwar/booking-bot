import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/chat/presentation/suggestions.dart';
import 'package:saathi/i18n/strings.g.dart';

final t0 = DateTime.utc(2026, 11, 20, 10);
const thyroid = Localized(
  en: 'Thyroid Profile (T3, T4, TSH)',
  hi: 'थायरॉइड प्रोफाइल (T3, T4, TSH)',
);
const pkg = PackageSummary(
  id: 'pkg_thyroid_profile',
  name: thyroid,
  priceInr: 499,
  mrpInr: 799,
  testCount: 3,
  topTests: ['T3'],
  fastingHours: 0,
  reportTatHours: 24,
  matchReason: Localized(en: 'm', hi: 'm'),
);

Message user(String id, {MessageStatus status = MessageStatus.sent, int at = 0}) => Message(
  id: id,
  conversationId: 'c1',
  role: MessageRole.user,
  kind: MessageKind.text,
  locale: 'en',
  body: 'hi',
  cards: const [],
  status: status,
  attempts: 0,
  createdAt: t0.add(Duration(seconds: at)),
);

Message reply(List<ChatCard> cards, {MessageStatus status = MessageStatus.sent, int at = 1}) =>
    Message(
      id: 'reply:$at',
      conversationId: 'c1',
      role: MessageRole.assistant,
      kind: MessageKind.text,
      locale: 'en',
      body: 'ok',
      cards: cards,
      status: status,
      attempts: 0,
      createdAt: t0.add(Duration(seconds: at)),
    );

List<String> labels(List<Suggestion> s) => [for (final x in s) x.label];

void main() {
  final t = AppLocale.en.buildSync();
  List<Suggestion> f(List<Message> rows, {bool flagged = false}) =>
      suggestionsFor(t, rows, flagged: flagged, lang: 'en');

  test('empty chat shows the starters', () {
    expect(labels(f([])), t.chat.suggestions);
  });

  test('nothing while a reply is pending or streaming', () {
    expect(f([user('a', status: MessageStatus.queued)]), isEmpty);
    expect(f([user('a')]), isEmpty);
    expect(f([user('a'), reply(const [], status: MessageStatus.streaming)]), isEmpty);
  });

  test('after package cards: book the top one, cheaper, no fasting', () {
    final s = f([
      user('a'),
      reply(const [
        ChatCard.packages([pkg]),
      ]),
    ]);
    expect(labels(s), ['Book Thyroid Profile', 'Something cheaper', 'No fasting needed']);
    final book = s.first as BookSuggestion;
    expect([book.packageId, book.name], ['pkg_thyroid_profile', thyroid]);
    expect((s[1] as SendSuggestion).text, 'Show me something cheaper');
  });

  test('Hindi uses the Hindi package name', () {
    final s = suggestionsFor(
      AppLocale.hi.buildSync(),
      [
        user('a'),
        reply(const [
          ChatCard.packages([pkg]),
        ]),
      ],
      flagged: false,
      lang: 'hi',
    );
    expect(s.first.label, 'थायरॉइड प्रोफाइल बुक करें');
  });

  test('after a booking: another test, my bookings, preparation', () {
    const booking = BookingInfo(
      bookingRef: 'LAB-1',
      packageId: 'p',
      packageName: thyroid,
      date: '2026-11-21',
      timeWindow: '07-09',
      addressLabel: 'Home',
      patientName: 'Priya',
      status: 'confirmed',
    );
    final s = f([
      user('a'),
      reply(const [ChatCard.booking(booking)]),
    ]);
    expect(labels(s), ['Book another test', 'My bookings', 'How do I prepare?']);
    expect((s[1] as OpenSuggestion).destination, Destination.bookings);
  });

  test('after full-slot alternatives: try another day', () {
    const offer = SlotOffer(
      requested: Slot(date: '2026-11-21', timeWindow: '07-09'),
      alternatives: [],
      packageId: 'p',
      packageName: thyroid,
      addressLabel: 'Home',
      patientName: 'Priya',
    );
    final s = f([
      user('a'),
      reply(const [ChatCard.slots(offer)]),
    ]);
    expect(labels(s), ['Try another day']);
    expect((s.single as BookSuggestion).packageId, 'p', reason: 'reopens the booking form');
  });

  test('an open booking form, safety cards and flagged chats show nothing', () {
    const form = ChatCard.bookingForm(BookingFormData(packageId: 'p', packageName: thyroid));
    expect(
      f([
        user('a'),
        reply(const [form]),
      ]),
      isEmpty,
    );
    expect(
      f([
        user('a'),
        reply(const [ChatCard.urgent('cardiac')]),
      ]),
      isEmpty,
    );
    expect(f([user('a'), reply(const [])], flagged: true), isEmpty);
  });

  test('plain text reply offers general next steps', () {
    final s = f([user('a'), reply(const [])]);
    expect(labels(s), ['Suggest tests for me', 'Full body checkup', 'Browse all packages']);
    expect((s.last as OpenSuggestion).destination, Destination.catalog);
  });
}
