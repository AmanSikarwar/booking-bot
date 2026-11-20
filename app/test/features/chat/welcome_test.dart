import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' show ComposerHeightNotifier;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/core/di.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/bookings/bookings_cubit.dart';
import 'package:saathi/features/catalog/package.dart';
import 'package:saathi/features/chat/presentation/chat_cubit.dart';
import 'package:saathi/features/chat/presentation/welcome.dart';
import 'package:saathi/features/profile/profile.dart';
import 'package:saathi/features/profile/profile_cubit.dart';
import 'package:saathi/i18n/strings.g.dart';

class MockChatCubit extends MockCubit<ChatState> implements ChatCubit {}

class MockProfileCubit extends MockCubit<Profile> implements ProfileCubit {}

class MockBookingsCubit extends MockCubit<List<Booking>?> implements BookingsCubit {}

final now = DateTime.utc(2026, 11, 20, 3);

Booking booking(String date, {String status = 'confirmed'}) => Booking(
  bookingRef: 'LAB-$date',
  conversationId: 'c1',
  packageId: 'pkg_diabetes_care',
  packageNameEn: 'Diabetes Care (FBS, PPBS, HbA1c)',
  packageNameHi: 'डायबिटीज़ केयर',
  slotDate: date,
  timeWindow: '07-09',
  addressLabel: 'Home',
  patientName: 'Ramesh Sharma',
  status: status,
  createdAt: now,
);

void main() {
  late List<String> sent;
  late MockBookingsCubit bookings;

  setUpAll(() => initializeDateFormatting());

  setUp(() {
    sent = [];
    final json = jsonDecode(File('assets/shared/packages.json').readAsStringSync());
    getIt.registerSingleton<Catalog>(Catalog.fromJson(json as Map<String, Object?>));
    bookings = MockBookingsCubit();
    getIt.registerFactory<BookingsCubit>(() => bookings);
  });

  tearDown(() => getIt.reset());

  Future<void> pump(
    WidgetTester tester, {
    double width = 760,
    double scale = 1,
    AppLocale locale = AppLocale.en,
  }) async {
    tester.view.physicalSize = Size(width, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    LocaleSettings.setLocaleSync(locale);
    final chat = MockChatCubit();
    when(() => chat.state).thenReturn(const ChatState());
    final profile = MockProfileCubit();
    when(() => profile.state).thenReturn(sampleProfile);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ChatCubit>.value(value: chat),
            BlocProvider<ProfileCubit>.value(value: profile),
          ],
          child: ChangeNotifierProvider(
            create: (_) => ComposerHeightNotifier(),
            child: MaterialApp(
              theme: buildTheme(),
              home: MediaQuery(
                data: MediaQueryData(size: Size(width, 1400), textScaler: TextScaler.linear(scale)),
                child: Scaffold(
                  body: Welcome(onSend: sent.add, onBook: (_, _) {}, now: now),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('greets by name, books for family, shows popular packages and steps', (tester) async {
    when(() => bookings.state).thenReturn(const []);
    await pump(tester);
    expect(find.text('Good morning, Priya'), findsOneWidget);
    expect(find.textContaining('Next collection'), findsNothing);
    expect(find.text('Full Body Checkup'), findsNothing, reason: 'short names only');
    expect(find.text('Diabetes Care'), findsOneWidget);
    expect(find.text('Sample collected at home'), findsOneWidget);
    await tester.tap(find.text('Ramesh · Father'));
    await tester.tap(find.text('Priya · You'));
    expect(sent, ['Suggest tests for my father, Ramesh Sharma', 'Suggest tests for me']);
  });

  testWidgets('shows the next upcoming confirmed collection only', (tester) async {
    when(() => bookings.state).thenReturn([
      booking('2026-11-19'),
      booking('2026-11-21', status: 'cancelled'),
      booking('2026-11-22'),
    ]);
    await pump(tester);
    expect(find.text('Next collection · LAB-2026-11-22'), findsOneWidget);
    expect(find.text('Diabetes Care (FBS, PPBS, HbA1c) · Ramesh Sharma · Home'), findsOneWidget);
  });

  for (final (width, scale, locale) in [
    (320.0, 1.0, AppLocale.en),
    (320.0, 2.0, AppLocale.hi),
    (760.0, 2.0, AppLocale.en),
  ]) {
    testWidgets('fits at ${width}px, ${scale}x, ${locale.name}', (tester) async {
      when(() => bookings.state).thenReturn([booking('2026-11-22')]);
      await pump(tester, width: width, scale: scale, locale: locale);
      expect(tester.takeException(), isNull);
    });
  }
}
