import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/chat/presentation/booking_form.dart';
import 'package:saathi/i18n/strings.g.dart';

final now = DateTime.utc(2026, 11, 20, 4, 30);
const thyroid = Localized(en: 'Thyroid Profile', hi: 'थायरॉइड प्रोफाइल');

Future<void> pump(
  WidgetTester tester,
  BookingFormData form, {
  void Function(SlotRequest)? onSubmit,
  AppLocale locale = AppLocale.en,
}) async {
  tester.view.physicalSize = const Size(420, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  LocaleSettings.setLocaleSync(locale);
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: BookingFormView(form: form, onSubmit: onSubmit, now: now),
          ),
        ),
      ),
    ),
  );
}

ChoiceChip chip(WidgetTester tester, String label) =>
    tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, label));

void main() {
  setUpAll(() => initializeDateFormatting());

  testWidgets('pre-filled form submits exactly what was shown', (tester) async {
    SlotRequest? sent;
    await pump(
      tester,
      const BookingFormData(
        packageId: 'pkg_thyroid_profile',
        packageName: thyroid,
        prefill: FormPrefill(
          date: '2026-11-22',
          timeWindow: '07-09',
          addressLabel: 'Home',
          patientName: 'Priya',
        ),
      ),
      onSubmit: (r) => sent = r,
    );
    expect(chip(tester, 'Sun 22 Nov').selected, isTrue);
    expect(chip(tester, '7–9 am').selected, isTrue);
    expect(chip(tester, 'Home').selected, isTrue);
    await tester.tap(find.text('Confirm booking'));
    expect(
      sent,
      const SlotRequest(
        date: '2026-11-22',
        timeWindow: '07-09',
        addressLabel: 'Home',
        patientName: 'Priya',
      ),
    );
  });

  testWidgets('today hides windows that already started, server availability marks full slots', (
    tester,
  ) async {
    await pump(
      tester,
      const BookingFormData(
        packageId: 'pkg_thyroid_profile',
        packageName: thyroid,
        availability: {
          '2026-11-20': ['16-18'],
          '2026-11-21': ['09-11', '11-13'],
        },
      ),
      onSubmit: (_) {},
    );
    await tester.tap(find.text('Today'));
    await tester.pump();
    expect(chip(tester, '7–9 am').onSelected, isNull);
    expect(chip(tester, '4–6 pm').onSelected, isNotNull);
    await tester.tap(find.text('Tomorrow'));
    await tester.pump();
    expect(chip(tester, '7–9 am · Full').onSelected, isNull);
    expect(chip(tester, '9–11 am').onSelected, isNotNull);
    expect(chip(tester, 'Sun 22 Nov').onSelected, isNull, reason: 'no open windows that day');
  });

  testWidgets('missing details show errors instead of submitting', (tester) async {
    var calls = 0;
    await pump(
      tester,
      const BookingFormData(packageId: 'pkg_thyroid_profile', packageName: thyroid),
      onSubmit: (_) => calls++,
    );
    await tester.tap(find.text('Confirm booking'));
    await tester.pump();
    expect(calls, 0);
    expect(find.text('Pick a date'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
    await tester.tap(find.text('Tomorrow'));
    await tester.pump();
    expect(find.text('Pick a time window'), findsOneWidget);
  });

  testWidgets('other address uses the typed label; Hindi chips send Hindi labels', (tester) async {
    SlotRequest? sent;
    await pump(
      tester,
      const BookingFormData(
        packageId: 'pkg_thyroid_profile',
        packageName: thyroid,
        fastingHours: 10,
        prefill: FormPrefill(date: '2026-11-21', timeWindow: '09-11', patientName: 'रमेश'),
      ),
      onSubmit: (r) => sent = r,
      locale: AppLocale.hi,
    );
    expect(find.text('सैंपल से पहले 10 घंटे खाली पेट रहें'), findsOneWidget);
    await tester.tap(find.text('बुकिंग पक्की करें'));
    expect(sent?.addressLabel, 'घर');
    await tester.tap(find.text('दूसरा'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).first, 'पापा का घर');
    await tester.tap(find.text('बुकिंग पक्की करें'));
    expect(sent?.addressLabel, 'पापा का घर');
  });

  testWidgets('submitted form shows a read-only summary', (tester) async {
    await pump(
      tester,
      const BookingFormData(
        packageId: 'pkg_thyroid_profile',
        packageName: thyroid,
        submitted: SlotRequest(
          date: '2026-11-21',
          timeWindow: '07-09',
          addressLabel: 'Home',
          patientName: 'Priya',
        ),
      ),
      onSubmit: (_) {},
    );
    expect(find.text('Confirm booking'), findsNothing);
    expect(find.text('Sat 21 Nov · 7–9 am'), findsOneWidget);
    expect(find.text('Details sent'), findsOneWidget);
  });

  testWidgets('flagged chat disables the form', (tester) async {
    await pump(
      tester,
      const BookingFormData(packageId: 'pkg_thyroid_profile', packageName: thyroid),
    );
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });
}
