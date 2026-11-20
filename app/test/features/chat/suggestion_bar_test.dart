import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/chat/presentation/chat_screen.dart';
import 'package:saathi/i18n/strings.g.dart';

Future<void> pump(
  WidgetTester tester,
  void Function(String) onPick, {
  AppLocale locale = AppLocale.en,
  double scale = 1,
  double width = 390,
}) async {
  tester.view.physicalSize = Size(width, 800);
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
            body: Align(
              alignment: Alignment.bottomCenter,
              child: SuggestionBar(onPick: onPick),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('tapping a suggestion sends it', (tester) async {
    final picked = <String>[];
    await pump(tester, picked.add);
    await tester.tap(find.text('Check my thyroid'));
    expect(picked, ['Check my thyroid']);
  });

  testWidgets('Hindi suggestions render', (tester) async {
    final picked = <String>[];
    await pump(tester, picked.add, locale: AppLocale.hi);
    await tester.tap(find.text('थायरॉइड की जाँच'));
    expect(picked, ['थायरॉइड की जाँच']);
  });

  testWidgets('scrolls sideways instead of overflowing on small screens with large text', (
    tester,
  ) async {
    await pump(tester, (_) {}, scale: 2, width: 280);
    expect(tester.takeException(), isNull);
    final chipHeight = tester.getSize(find.byType(ActionChip).first).height;
    expect(tester.getSize(find.byType(SuggestionBar)).height, greaterThanOrEqualTo(chipHeight));
    await tester.dragUntilVisible(
      find.text('I feel tired all the time'),
      find.byType(SingleChildScrollView),
      const Offset(-200, 0),
    );
    expect(find.text('I feel tired all the time').hitTestable(), findsOneWidget);
  });

  testWidgets('wide screens wrap all suggestions without scrolling', (tester) async {
    await pump(tester, (_) {}, width: 900);
    expect(find.byType(SingleChildScrollView), findsNothing);
    for (final s in [
      'Check my thyroid',
      'Full body checkup',
      'Sugar test for Papa',
      'I feel tired all the time',
    ]) {
      expect(find.text(s).hitTestable(), findsOneWidget);
    }
  });
}
