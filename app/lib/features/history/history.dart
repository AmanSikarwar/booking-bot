import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_shell.dart';

import '../../core/db/database.dart';
import '../../core/di.dart';
import '../../core/router.dart';
import '../../core/theme.dart';
import '../../i18n/strings.g.dart';
import '../chat/data/chat_repository.dart';
import '../chat/presentation/chat_cubit.dart';

@injectable
class HistoryCubit extends Cubit<List<Conversation>?> {
  HistoryCubit(ChatRepository repo) : super(null) {
    _sub = repo.watchConversations().listen(emit);
  }

  late final StreamSubscription<List<Conversation>> _sub;

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: backToChat(context),
        title: Text(context.t.history.title),
      ),
      body: HistoryList(onOpened: () => const ChatRoute().go(context)),
    );
  }
}

class HistoryList extends StatelessWidget {
  const HistoryList({super.key, this.onOpened});

  final VoidCallback? onOpened;

  @override
  Widget build(BuildContext context) {
    final current = context.select((ChatCubit c) => c.state.conversationId);
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>(),
      child: BlocBuilder<HistoryCubit, List<Conversation>?>(
        builder: (context, chats) {
          if (chats == null) return const SizedBox.shrink();
          if (chats.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.forum_outlined, size: 40, color: Palette.line),
                    const SizedBox(height: 12),
                    Text(
                      context.t.history.empty,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Palette.inkMuted, fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: chats.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 72, color: Palette.line),
                itemBuilder: (context, i) => _HistoryTile(
                  chat: chats[i],
                  selected: chats[i].id == current,
                  onTap: () {
                    unawaited(context.read<ChatCubit>().openConversation(chats[i].id));
                    onOpened?.call();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.chat, required this.selected, required this.onTap});

  final Conversation chat;
  final bool selected;
  final VoidCallback onTap;

  String _when(BuildContext context) {
    final t = context.t.history;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final local = chat.updatedAt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    if (day == today) return t.today(time: DateFormat.jm(lang).format(local));
    if (day == today.subtract(const Duration(days: 1))) return t.yesterday;
    return DateFormat('EEE d MMM', lang).format(local);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.history;
    return Material(
      color: selected ? Palette.lavenderSoft : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: chat.flagged
                      ? Palette.urgent.withAlpha(20)
                      : (selected ? Palette.surface : Palette.lavenderSoft),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  chat.flagged ? Icons.pause_circle_outline : Icons.chat_bubble_outline,
                  size: 20,
                  color: chat.flagged ? Palette.urgent : Palette.lavender,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Palette.ink,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          _when(context),
                          style: const TextStyle(fontSize: 12, color: Palette.inkMuted),
                        ),
                        if (selected)
                          Text(
                            t.current,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Palette.lavender,
                            ),
                          ),
                        if (chat.flagged)
                          Text(
                            t.paused,
                            style: const TextStyle(fontSize: 12, color: Palette.urgent),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
