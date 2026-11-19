import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/chat/presentation/cards.dart';
import 'package:saathi/i18n/strings.g.dart';

const diabetes = PackageSummary(
  id: 'pkg_diabetes_care',
  name: Localized(en: 'Diabetes Care', hi: 'डायबिटीज़ केयर'),
  priceInr: 1299,
  mrpInr: 1999,
  testCount: 4,
  topTests: ['Fasting Blood Sugar', 'HbA1c'],
  fastingHours: 10,
  reportTatHours: 24,
  matchReason: Localized(en: 'Matches: sugar', hi: 'इनसे मेल खाता है: sugar'),
);
const allTests = [
  'Fasting Blood Sugar',
  'Post-Prandial Blood Sugar',
  'HbA1c',
  'Urine Microalbumin',
];
const booking = BookingInfo(
  bookingRef: 'LAB-7Q3K9',
  packageId: 'pkg_thyroid_profile',
  packageName: Localized(en: 'Thyroid Profile', hi: 'थायरॉइड प्रोफाइल'),
  date: '2026-11-21',
  timeWindow: '07-09',
  addressLabel: 'Home',
  patientName: 'Priya',
  status: 'confirmed',
);

Future<void> pump(WidgetTester tester, Widget child, {AppLocale locale = AppLocale.en}) async {
  LocaleSettings.setLocaleSync(locale);
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        theme: buildTheme(),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
}

void main() {
  setUpAll(() => initializeDateFormatting());

  testWidgets('package card shows price, facts and the tubes it needs', (tester) async {
    final semantics = tester.ensureSemantics();
    var booked = false;
    await pump(
      tester,
      PackageCardView(pkg: diabetes, allTests: allTests, onBook: () => booked = true),
    );
    expect(find.text('Diabetes Care'), findsOneWidget);
    expect(find.text('₹1,299'), findsOneWidget);
    expect(find.text('₹1,999'), findsOneWidget);
    expect(find.text('4 tests · Fasting 10 hrs · Report in 24 hrs'), findsOneWidget);
    expect(find.bySemanticsLabel('Sample tubes: lavender, grey, urine cup'), findsOneWidget);
    await tester.tap(find.text('Book home collection'));
    expect(booked, isTrue);
    await tester.tap(find.bySemanticsLabel(RegExp('^View tests')));
    await tester.pumpAndSettle();
    expect(find.text('Urine Microalbumin'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('package card hides booking when the chat is flagged', (tester) async {
    await pump(tester, const PackageCardView(pkg: diabetes, allTests: allTests, onBook: null));
    expect(find.text('Book home collection'), findsNothing);
  });

  testWidgets('package card renders Hindi names and copy', (tester) async {
    await pump(
      tester,
      PackageCardView(pkg: diabetes, allTests: allTests, onBook: () {}),
      locale: AppLocale.hi,
    );
    expect(find.text('डायबिटीज़ केयर'), findsOneWidget);
    expect(find.text('घर पर सैंपल बुक करें'), findsOneWidget);
  });

  testWidgets('booking card shows the reference, slot and saved-offline badge', (tester) async {
    await pump(tester, BookingCardView(booking: booking, onViewAll: () {}));
    expect(find.text('LAB-7Q3K9'), findsOneWidget);
    expect(find.text('Sat 21 Nov · 7–9 am'), findsOneWidget);
    expect(find.text('Home · for Priya'), findsOneWidget);
    expect(find.text('Saved offline'), findsOneWidget);
  });

  testWidgets('slot chips send the picked slot', (tester) async {
    Slot? picked;
    await pump(
      tester,
      SlotsCardView(
        offer: const SlotOffer(
          requested: Slot(date: '2026-11-21', timeWindow: '07-09'),
          alternatives: [Slot(date: '2026-11-21', timeWindow: '09-11')],
          packageId: 'pkg_thyroid_profile',
          packageName: Localized(en: 'Thyroid Profile', hi: 'थायरॉइड प्रोफाइल'),
          addressLabel: 'Home',
          patientName: 'Priya',
        ),
        onPick: (s) => picked = s,
      ),
    );
    await tester.tap(find.text('Sat 21 Nov · 9–11 am'));
    expect(picked, const Slot(date: '2026-11-21', timeWindow: '09-11'));
  });

  testWidgets('urgent care card uses the fixed copy in both languages', (tester) async {
    await pump(tester, const UrgentCareCard());
    expect(find.textContaining('Call 112 or 108 now'), findsOneWidget);
    expect(find.text('Call 112'), findsOneWidget);
    expect(find.text('Call 108'), findsOneWidget);
    await pump(tester, const UrgentCareCard(), locale: AppLocale.hi);
    expect(find.textContaining('अभी 112 या 108 पर कॉल करें'), findsOneWidget);
    expect(find.text('112 पर कॉल करें'), findsOneWidget);
  });

  testWidgets('crisis card offers Tele-MANAS', (tester) async {
    await pump(tester, const CrisisSupportCard());
    expect(find.textContaining('14416'), findsWidgets);
    expect(find.text('Call 14416'), findsOneWidget);
  });
}
