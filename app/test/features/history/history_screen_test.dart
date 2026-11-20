import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/core/di.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/chat/presentation/chat_cubit.dart';
import 'package:saathi/features/history/history.dart';
import 'package:saathi/features/settings/locale_cubit.dart';
import 'package:saathi/i18n/strings.g.dart';

class MockChatCubit extends MockCubit<ChatState> implements ChatCubit {}

class MockLocaleCubit extends MockCubit<AppLocale> implements LocaleCubit {}

class MockHistoryCubit extends MockCubit<List<Conversation>?> implements HistoryCubit {}

void main() {
  late MockChatCubit chat;
  late MockLocaleCubit locale;
  final chats = [
    Conversation(
      id: 'c1',
      locale: 'en',
      title: 'Sugar test for Papa',
      flagged: false,
      createdAt: DateTime.utc(2026, 11, 20),
      updatedAt: DateTime.utc(2026, 11, 20),
    ),
  ];

  setUpAll(() => initializeDateFormatting());

  setUp(() {
    chat = MockChatCubit();
    locale = MockLocaleCubit();
    when(() => chat.state).thenReturn(const ChatState(conversationId: 'c1'));
    when(() => chat.newChat(any())).thenAnswer((_) async {});
    when(() => locale.state).thenReturn(AppLocale.hi);
    final history = MockHistoryCubit();
    when(() => history.state).thenReturn(chats);
    getIt.registerFactory<HistoryCubit>(() => history);
  });

  tearDown(() => getIt.reset());

  testWidgets('New chat FAB starts a fresh conversation and opens the chat', (tester) async {
    LocaleSettings.setLocaleSync(AppLocale.en);
    final router = GoRouter(
      initialLocation: '/history',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('chat page')),
        GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
      ],
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ChatCubit>.value(value: chat),
            BlocProvider<LocaleCubit>.value(value: locale),
          ],
          child: MaterialApp.router(theme: buildTheme(), routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sugar test for Papa'), findsOneWidget);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'New chat'));
    await tester.pumpAndSettle();
    verify(() => chat.newChat('hi')).called(1);
    expect(find.text('chat page'), findsOneWidget);
  });
}
