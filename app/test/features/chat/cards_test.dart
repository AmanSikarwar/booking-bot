import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:flutter/services.dart';
import 'package:saathi/features/chat/presentation/cards.dart';
import 'package:saathi/features/chat/presentation/package_card.dart';
import 'package:saathi/features/profile/profile.dart';
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
const details = LabPackage(
  id: 'pkg_diabetes_care',
  name: Localized(en: 'Diabetes Care', hi: 'डायबिटीज़ केयर'),
  category: 'diabetes',
  tests: allTests,
  testCount: 4,
  priceInr: 1299,
  mrpInr: 1999,
  fastingHours: 10,
  sampleType: 'blood, urine',
  reportTatHours: 24,
  description: Localized(en: 'Commonly ordered to check blood sugar.', hi: 'शुगर देखने के लिए।'),
);
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

  testWidgets('package card shows description, preview tests, facts, tubes and discount', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var booked = false;
    await pump(
      tester,
      PackageCardView(pkg: diabetes, details: details, onBook: () => booked = true),
    );
    expect(find.text('Diabetes Care'), findsOneWidget);
    expect(find.text('Diabetes'), findsOneWidget, reason: 'category label');
    expect(find.text(details.description.en), findsOneWidget);
    expect(find.textContaining('Matches'), findsNothing);
    expect(find.text('₹1,299'), findsOneWidget);
    expect(find.text('35% off'), findsOneWidget);
    expect(find.text('4 tests'), findsOneWidget);
    expect(find.text('Report in 24 hrs'), findsOneWidget);
    expect(find.text('Fasting 10 hrs'), findsOneWidget);
    expect(find.text('2 tubes + urine cup'), findsOneWidget);
    expect(find.bySemanticsLabel('Sample tubes: lavender, grey, urine cup'), findsOneWidget);
    expect(find.text('Urine Microalbumin'), findsNothing, reason: 'only 3 tests preview');
    expect(find.text('+1 more'), findsOneWidget);
    await tester.tap(find.text('Book home collection'));
    expect(booked, isTrue);
    semantics.dispose();
  });

  testWidgets(
    'tapping a card on a phone opens a bottom sheet with every detail and a booking CTA',
    (tester) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var booked = 0;
      await pump(tester, PackageCardView(pkg: diabetes, details: details, onBook: () => booked++));
      await tester.tap(find.text('Diabetes Care'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
      for (final text in [
        'About this package',
        'What\'s included',
        'Urine Microalbumin',
        'How to prepare',
        'Fast for 10 hours before collection. Plain water is fine.',
        'Sample: Blood, Urine',
      ]) {
        await tester.scrollUntilVisible(
          find.text(text),
          100,
          scrollable: find.byType(Scrollable).last,
        );
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.text('Book home collection'), findsNWidgets(2));
      await tester.tap(find.text('Book home collection').last);
      await tester.pumpAndSettle();
      expect(booked, 1);
      expect(find.byType(BottomSheet), findsNothing);
    },
  );

  testWidgets('tablets and desktop get a dialog with a close button', (tester) async {
    tester.view.physicalSize = const Size(1024, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pump(tester, PackageCardView(pkg: diabetes, details: details, onBook: () {}));
    await tester.tap(find.text('Diabetes Care'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('details without booking hide the CTA (flagged chat)', (tester) async {
    await pump(tester, PackageCardView(pkg: diabetes, details: details, onBook: null));
    expect(find.text('Book home collection'), findsNothing);
    await tester.tap(find.text('Diabetes Care'));
    await tester.pumpAndSettle();
    expect(find.text('Book home collection'), findsNothing);
  });

  testWidgets('first search result is marked as the top match', (tester) async {
    await pump(
      tester,
      PackageCardView(pkg: diabetes, details: details, topMatch: true, onBook: () {}),
    );
    expect(find.text('Top match'), findsOneWidget);
  });

  testWidgets('package card renders Hindi names and copy', (tester) async {
    await pump(
      tester,
      PackageCardView(pkg: diabetes, details: details, onBook: () {}),
      locale: AppLocale.hi,
    );
    expect(find.text('डायबिटीज़ केयर'), findsOneWidget);
    expect(find.text('घर पर सैंपल बुक करें'), findsOneWidget);
    expect(find.text('35% छूट'), findsOneWidget);
    expect(find.text('2 ट्यूब + यूरिन कप'), findsOneWidget);
    expect(find.text('+1 और'), findsOneWidget);
  });

  testWidgets('booking card shows reference, when, where, who and the fasting reminder', (
    tester,
  ) async {
    await pump(
      tester,
      BookingCardView(booking: booking.copyWith(fastingHours: 10), onViewAll: () {}),
    );
    expect(find.text('LAB-7Q3K9'), findsOneWidget);
    expect(find.text('Sat 21 Nov · 7–9 am'), findsOneWidget);
    expect(find.text('Collector arrives'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Priya'), findsOneWidget);
    expect(find.text('Saved offline'), findsOneWidget);
    expect(find.text('Fast for 10 hours before collection'), findsOneWidget);
  });

  testWidgets('booking reference can be copied', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (
      call,
    ) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String;
      return null;
    });
    await pump(tester, BookingCardView(booking: booking, onViewAll: null));
    await tester.tap(find.byTooltip('Copy reference'));
    await tester.pump();
    expect(copied, 'LAB-7Q3K9');
    expect(find.text('Booking reference copied'), findsOneWidget);
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

  testWidgets('booking card describes family patients and saved addresses from the profile', (
    tester,
  ) async {
    await pump(
      tester,
      BookingCardView(
        booking: booking.copyWith(patientName: 'Ramesh Sharma', addressLabel: "Papa's house"),
        onViewAll: null,
        profile: sampleProfile,
      ),
    );
    expect(find.text('Ramesh Sharma'), findsOneWidget);
    expect(find.text('Father, 64 yrs'), findsOneWidget);
    expect(find.text('House 21, Block C, Sector 9, Gurugram 122001'), findsOneWidget);
  });
}
