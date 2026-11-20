import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/domain/models.dart';
import 'package:saathi/features/chat/presentation/booking_form.dart';
import 'package:saathi/features/profile/profile.dart';
import 'package:saathi/i18n/strings.g.dart';

final now = DateTime.utc(2026, 11, 20, 4, 30);
const thyroid = Localized(en: 'Thyroid Profile', hi: 'थायरॉइड प्रोफाइल');

Future<void> pump(
  WidgetTester tester,
  BookingFormData form, {
  void Function(SlotRequest)? onSubmit,
  AppLocale locale = AppLocale.en,
  double windowWidth = 420,
}) async {
  tester.view.physicalSize = Size(windowWidth, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  LocaleSettings.setLocaleSync(locale);
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: BookingFormView(
              form: form,
              profile: sampleProfile,
              onSubmit: onSubmit,
              now: now,
            ),
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

  testWidgets('phone spacing tightens without shrinking booking controls', (tester) async {
    const form = BookingFormData(packageId: 'pkg_thyroid_profile', packageName: thyroid);
    final lastWindow = find.widgetWithText(ChoiceChip, '4–6 pm');
    double gap() =>
        tester.getTopLeft(find.text('Patient name')).dy - tester.getBottomLeft(lastWindow).dy;

    await pump(tester, form);
    final phoneGap = gap();
    final phoneChipHeight = tester.getSize(lastWindow).height;

    await pump(tester, form, windowWidth: 720);
    expect(phoneGap, lessThan(gap()));
    expect(phoneChipHeight, tester.getSize(lastWindow).height);
  });

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
        patientName: 'Priya Sharma',
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
    await tester.tap(find.text('Tomorrow'));
    await tester.pump();
    expect(find.text('Pick a time window'), findsOneWidget);
  });

  testWidgets('patient and address come from the profile; family names pre-select', (tester) async {
    SlotRequest? sent;
    await pump(
      tester,
      const BookingFormData(
        packageId: 'pkg_thyroid_profile',
        packageName: thyroid,
        prefill: FormPrefill(
          date: '2026-11-21',
          timeWindow: '09-11',
          patientName: 'Ramesh Sharma',
          addressLabel: "papa's house",
        ),
      ),
      onSubmit: (r) => sent = r,
    );
    expect(chip(tester, 'Ramesh · Father').selected, isTrue);
    expect(chip(tester, "Papa's house").selected, isTrue);
    expect(find.text('House 21, Block C, Sector 9, Gurugram 122001'), findsOneWidget);
    for (final label in [
      'Priya · You',
      'Sunita · Mother',
      'Arjun · Spouse',
      'Someone else',
      'Home',
      'Office',
      'Other',
    ]) {
      expect(find.widgetWithText(ChoiceChip, label), findsOneWidget, reason: label);
    }
    await tester.tap(find.text('Confirm booking'));
    expect(
      sent,
      const SlotRequest(
        date: '2026-11-21',
        timeWindow: '09-11',
        addressLabel: "Papa's house",
        patientName: 'Ramesh Sharma',
      ),
    );
  });

  testWidgets(
    'defaults to you at the first saved address; someone else and other take typed values',
    (tester) async {
      SlotRequest? sent;
      await pump(
        tester,
        const BookingFormData(
          packageId: 'pkg_thyroid_profile',
          packageName: thyroid,
          prefill: FormPrefill(date: '2026-11-21', timeWindow: '09-11'),
        ),
        onSubmit: (r) => sent = r,
        locale: AppLocale.hi,
      );
      expect(chip(tester, 'Priya · आप').selected, isTrue);
      expect(chip(tester, 'Home').selected, isTrue);
      await tester.tap(find.text('बुकिंग पक्की करें'));
      expect([sent?.patientName, sent?.addressLabel], ['Priya Sharma', 'Home']);
      await tester.tap(find.text('कोई और'));
      await tester.pump();
      await tester.tap(find.text('बुकिंग पक्की करें'));
      await tester.pump();
      expect(find.text('ज़रूरी है'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'कमला देवी');
      await tester.tap(find.text('दूसरा'));
      await tester.pump();
      await tester.enterText(find.byType(TextField).last, 'मौसी का घर');
      await tester.tap(find.text('बुकिंग पक्की करें'));
      expect([sent?.patientName, sent?.addressLabel], ['कमला देवी', 'मौसी का घर']);
    },
  );

  testWidgets('a name not in the profile pre-fills someone else', (tester) async {
    await pump(
      tester,
      const BookingFormData(
        packageId: 'pkg_thyroid_profile',
        packageName: thyroid,
        prefill: FormPrefill(patientName: 'Kamla Devi'),
      ),
      onSubmit: (_) {},
    );
    expect(chip(tester, 'Someone else').selected, isTrue);
    expect(find.text('Kamla Devi'), findsOneWidget);
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
