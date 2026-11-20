import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/app_shell.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/i18n/strings.g.dart';

GoRouter testRouter() => GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(location: state.uri.path, child: child),
      routes: [
        for (final p in ['/', '/history', '/bookings', '/packages', '/profile'])
          GoRoute(
            path: p,
            builder: (_, _) => Scaffold(body: Text('page $p')),
          ),
      ],
    ),
  ],
);

Future<void> pump(WidgetTester tester, {double width = 390, double keyboard = 0}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);
  LocaleSettings.setLocaleSync(AppLocale.en);
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp.router(theme: buildTheme(), routerConfig: testRouter()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phones get a bottom bar with all four destinations', (tester) async {
    await pump(tester);
    for (final label in ['Chat', 'History', 'Bookings', 'Packages', 'Profile']) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('page /history'), findsOneWidget);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);
    await tester.tap(find.text('Packages'));
    await tester.pumpAndSettle();
    expect(find.text('page /packages'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('page /profile'), findsOneWidget);
  });

  testWidgets('bottom bar hides while the keyboard is open', (tester) async {
    await pump(tester, keyboard: 300);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('tablets and desktop use the header instead', (tester) async {
    await pump(tester, width: 800);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('Hindi labels fit at 320px with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    LocaleSettings.setLocaleSync(AppLocale.hi);
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp.router(
          theme: buildTheme(),
          routerConfig: testRouter(),
          builder: (context, child) => MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.5,
            maxScaleFactor: 1.5,
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('इतिहास'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
