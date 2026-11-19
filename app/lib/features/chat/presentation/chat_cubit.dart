import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/db/database.dart';
import '../data/chat_repository.dart';

part 'chat_cubit.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    String? conversationId,
    @Default([]) List<Message> messages,
    @Default(false) bool flagged,
  }) = _ChatState;
}

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._repo) : super(const ChatState());

  final ChatRepository _repo;
  StreamSubscription<List<Message>>? _messages;
  StreamSubscription<Conversation?>? _conversation;

  Future<void> start(String locale) async => _open(await _repo.currentConversation(locale));

  Future<void> newChat(String locale) async => _open(await _repo.newConversation(locale));

  Future<void> send(String text, String locale, {MessageKind kind = MessageKind.text}) async {
    final id = state.conversationId;
    final trimmed = text.trim();
    if (id == null || trimmed.isEmpty) return;
    await _repo.submit(conversationId: id, text: trimmed, locale: locale, kind: kind);
  }

  Future<void> retry(String messageId) => _repo.retry(messageId);

  Future<void> _open(String id) async {
    await _messages?.cancel();
    await _conversation?.cancel();
    emit(ChatState(conversationId: id));
    _messages = _repo.watchMessages(id).listen((m) => emit(state.copyWith(messages: m)));
    _conversation = _repo
        .watchConversation(id)
        .listen((c) => emit(state.copyWith(flagged: c?.flagged ?? false)));
  }

  @override
  Future<void> close() async {
    await _messages?.cancel();
    await _conversation?.cancel();
    return super.close();
  }
}
