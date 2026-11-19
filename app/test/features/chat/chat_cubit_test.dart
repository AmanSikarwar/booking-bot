import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saathi/core/db/database.dart';
import 'package:saathi/features/chat/data/chat_repository.dart';
import 'package:saathi/features/chat/presentation/chat_cubit.dart';

class MockRepo extends Mock implements ChatRepository {}

void main() {
  late MockRepo repo;
  final msg = Message(
    id: 'm1',
    conversationId: 'c1',
    role: MessageRole.user,
    kind: MessageKind.text,
    locale: 'en',
    body: 'sugar',
    cards: const [],
    status: MessageStatus.queued,
    attempts: 0,
    createdAt: DateTime.utc(2026, 11, 20),
  );
  final conv = Conversation(
    id: 'c1',
    locale: 'en',
    flagged: true,
    createdAt: DateTime.utc(2026, 11, 20),
    updatedAt: DateTime.utc(2026, 11, 20),
  );

  setUp(() {
    repo = MockRepo();
    when(() => repo.currentConversation(any())).thenAnswer((_) async => 'c1');
    when(() => repo.watchMessages('c1')).thenAnswer((_) => Stream.value([msg]));
    when(() => repo.watchConversation('c1')).thenAnswer((_) => Stream.value(conv));
    when(
      () => repo.submit(
        conversationId: any(named: 'conversationId'),
        text: any(named: 'text'),
        locale: any(named: 'locale'),
        kind: any(named: 'kind'),
      ),
    ).thenAnswer((_) async {});
  });

  setUpAll(() => registerFallbackValue(MessageKind.text));

  blocTest<ChatCubit, ChatState>(
    'start opens the current conversation and mirrors its messages and flag',
    build: () => ChatCubit(repo),
    act: (c) => c.start('en'),
    expect: () => [
      const ChatState(conversationId: 'c1'),
      ChatState(conversationId: 'c1', messages: [msg]),
      ChatState(conversationId: 'c1', messages: [msg], flagged: true),
    ],
  );

  blocTest<ChatCubit, ChatState>(
    'send trims text and ignores empty input',
    build: () => ChatCubit(repo),
    seed: () => const ChatState(conversationId: 'c1'),
    act: (c) async {
      await c.send('   ', 'en');
      await c.send('  sugar test  ', 'hi', kind: MessageKind.action);
    },
    verify: (_) => verify(
      () => repo.submit(
        conversationId: 'c1',
        text: 'sugar test',
        locale: 'hi',
        kind: MessageKind.action,
      ),
    ).called(1),
  );
}
