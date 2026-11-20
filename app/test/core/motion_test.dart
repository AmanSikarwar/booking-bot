import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/motion.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/chat/presentation/bubbles.dart';
import 'package:saathi/i18n/strings.g.dart';

Future<void> pump(
  WidgetTester tester,
  Widget Function(BuildContext) build, {
  bool reduce = false,
}) async {
  LocaleSettings.setLocaleSync(AppLocale.en);
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        theme: buildTheme(),
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduce),
          child: Scaffold(body: Builder(builder: build)),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() => Motion.enabled = true);
  tearDown(() => Motion.enabled = false);

  testWidgets('enter, stagger and pop animations settle without leaks', (tester) async {
    await pump(
      tester,
      (context) => Column(
        children: [
          const Text('a').enter(context, delay: 50.ms),
          ...staggered(context, [const Text('b'), const Text('c'), const Text('d')]),
          const Icon(Icons.check).pop(context),
        ],
      ),
    );
    expect(find.byType(Animate), findsNWidgets(5));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('enterOnce animates an item only the first time it is built', (tester) async {
    await pump(tester, (context) => const Text('first').enterOnce(context, 'motion-test/1'));
    expect(find.byType(Animate), findsOneWidget);
    await tester.pumpAndSettle();
    await pump(tester, (context) => const Text('first').enterOnce(context, 'motion-test/1'));
    expect(find.byType(Animate), findsNothing);
  });

  testWidgets('looping shimmer on the activity chip keeps running and can be torn down', (
    tester,
  ) async {
    await pump(tester, (_) => const ActivityChip(label: 'Finding packages…'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Finding packages…'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('thinking and typing keep their labels with reduced motion', (tester) async {
    for (final label in ['Thinking…', 'Typing…']) {
      await pump(tester, (_) => ActivityChip(label: label, showTypingDots: true), reduce: true);
      await tester.pumpAndSettle();
      expect(find.text(label), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    }
  });

  testWidgets('reduced motion skips every effect', (tester) async {
    await pump(
      tester,
      (context) => Column(
        children: [
          const Text('a').enter(context),
          ...staggered(context, [const Text('b')]),
          const Icon(Icons.check).pop(context),
        ],
      ),
      reduce: true,
    );
    expect(find.byType(Animate), findsNothing);
  });
}
