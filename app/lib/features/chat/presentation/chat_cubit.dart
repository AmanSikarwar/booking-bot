import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/db/database.dart';
import '../data/chat_repository.dart';
import '../domain/models.dart';

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

  Future<void> openConversation(String id) async {
    if (id == state.conversationId) return;
    await _repo.switchTo(id);
    await _open(id);
  }

  Future<void> send(
    String text,
    String locale, {
    MessageKind kind = MessageKind.text,
    String? display,
  }) async {
    final id = state.conversationId;
    final trimmed = text.trim();
    if (id == null || trimmed.isEmpty) return;
    await _repo.submit(
      conversationId: id,
      text: trimmed,
      locale: locale,
      kind: kind,
      display: display,
    );
  }

  Future<void> retry(String messageId) => _repo.retry(messageId);

  Future<void> openBookingForm(BookingFormData form, String locale) async {
    final id = state.conversationId;
    if (id == null) return;
    await _repo.openBookingForm(conversationId: id, form: form, locale: locale);
  }

  Future<void> submitBookingForm({
    required String rowId,
    required int cardIndex,
    required SlotRequest request,
    required String text,
    required String locale,
    String? display,
  }) => _repo.submitBookingForm(
    rowId: rowId,
    cardIndex: cardIndex,
    request: request,
    text: text,
    locale: locale,
    display: display,
  );

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
