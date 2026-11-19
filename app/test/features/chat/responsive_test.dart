import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/core/layout.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/chat/presentation/bubbles.dart';
import 'package:saathi/features/chat/presentation/cards.dart';
import 'package:saathi/i18n/strings.g.dart';

const name = Localized(
  en: 'Comprehensive Full Body Checkup with Vitamins',
  hi: 'कम्प्रीहेन्सिव फुल बॉडी चेकअप और विटामिन जाँच',
);
const pkg = PackageSummary(
  id: 'pkg_full_body',
  name: name,
  priceInr: 12499,
  mrpInr: 24999,
  testCount: 11,
  topTests: ['CBC', 'HbA1c', 'Lipid Profile', 'Liver Function Test'],
  fastingHours: 10,
  reportTatHours: 48,
  matchReason: Localized(
    en: 'Matches: tired, fatigue, hair fall',
    hi: 'इनसे मेल खाता है: थकान, बाल झड़ना',
  ),
);
const allTests = [
  'CBC',
  'HbA1c',
  'Fasting Blood Sugar',
  'Lipid Profile',
  'Vitamin D',
  'Urine Routine',
];
const booking = BookingInfo(
  bookingRef: 'LAB-7Q3K9',
  packageId: 'pkg_full_body',
  packageName: name,
  date: '2026-11-21',
  timeWindow: '11-13',
  addressLabel: 'Office near the main market',
  patientName: 'Ramesh Kumar Sharma',
  status: 'confirmed',
);
const offer = SlotOffer(
  requested: Slot(date: '2026-11-21', timeWindow: '07-09'),
  alternatives: [
    Slot(date: '2026-11-21', timeWindow: '09-11'),
    Slot(date: '2026-11-22', timeWindow: '11-13'),
    Slot(date: '2026-11-23', timeWindow: '16-18'),
  ],
  packageId: 'pkg_full_body',
  packageName: name,
  addressLabel: 'Home',
  patientName: 'Priya',
);

void main() {
  setUpAll(() => initializeDateFormatting());

  const widths = [280.0, 320.0, 360.0, 414.0, 768.0, 1440.0];
  const scales = [1.0, 1.5, 2.0];

  for (final locale in AppLocale.values) {
    for (final width in widths) {
      for (final scale in scales) {
        testWidgets('cards fit at ${width.toInt()}px, ${scale}x text, ${locale.languageCode}', (
          tester,
        ) async {
          tester.view.physicalSize = Size(width, 2400);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          LocaleSettings.setLocaleSync(locale);
          await tester.pumpWidget(
            TranslationProvider(
              child: MaterialApp(
                theme: buildTheme(),
                home: MediaQuery.withClampedTextScaling(
                  minScaleFactor: scale,
                  maxScaleFactor: scale,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SaathiBubble(
                            child: SaathiText(text: 'These are commonly ordered.'),
                          ),
                          const UserBubble(
                            text: 'Papa ke liye sugar test',
                            status: MessageStatus.failed,
                          ),
                          SaathiBubble(
                            showAvatar: false,
                            maxWidth: 700,
                            fullBleedOnCompact: true,
                            child: ResponsiveWrap(
                              maxColumns: 2,
                              children: [
                                for (var i = 0; i < 3; i++)
                                  PackageCardView(pkg: pkg, allTests: allTests, onBook: () {}),
                              ],
                            ),
                          ),
                          BookingCardView(booking: booking, onViewAll: () {}),
                          SlotsCardView(offer: offer, onPick: (_) {}),
                          const UrgentCareCard(),
                          const CrisisSupportCard(),
                          const NoticeBubble(
                            text: 'You are offline. I will send this when you are back.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.byIcon(Icons.expand_more).first);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('package cards go two per row on wide columns and one per row on phones', (
    tester,
  ) async {
    Future<List<double>> lefts(double width) async {
      tester.view.physicalSize = Size(width, 2400);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            theme: buildTheme(),
            home: Scaffold(
              body: SingleChildScrollView(
                child: ResponsiveWrap(
                  maxColumns: 2,
                  children: [
                    for (var i = 0; i < 2; i++)
                      PackageCardView(pkg: pkg, allTests: allTests, onBook: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      return tester
          .widgetList(find.byType(PackageCardView))
          .map((w) => tester.getTopLeft(find.byWidget(w)).dx)
          .toList();
    }

    addTearDown(tester.view.reset);
    final phone = await lefts(390);
    expect(phone[0], phone[1]);
    final wide = await lefts(760);
    expect(wide[1], greaterThan(wide[0]));
  });
}
