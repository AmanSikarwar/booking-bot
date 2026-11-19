import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as fc;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../core/db/database.dart';
import '../../../core/di.dart';
import '../../../core/router.dart';
import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
import '../../catalog/package.dart';
import '../../settings/locale_cubit.dart';
import '../domain/models.dart';
import 'bubbles.dart';
import 'cards.dart';
import 'chat_cubit.dart';
import 'chat_items.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = SyncedChatController();
  late final Map<String, List<String>> _testsById = {
    for (final p in getIt<Catalog>().packages) p.id: p.tests,
  };

  String get _locale => context.read<LocaleCubit>().state.languageCode;

  void _sync() => _controller.sync(
    toChatItems(
      context.read<ChatCubit>().state.messages,
      online: context.read<ConnectivityCubit>().state,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send(String text, {MessageKind kind = MessageKind.text}) =>
      unawaited(context.read<ChatCubit>().send(text, _locale, kind: kind));

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final flagged = context.select((ChatCubit c) => c.state.flagged);
    final online = context.watch<ConnectivityCubit>().state;
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatCubit, ChatState>(
          listenWhen: (a, b) => a.messages != b.messages,
          listener: (_, _) => _sync(),
        ),
        BlocListener<ConnectivityCubit, bool>(listener: (_, _) => _sync()),
      ],
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 12,
          title: Row(
            children: [
              const SaathiAvatar(size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.chat.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            t.chat.subtitle,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Palette.inkMuted),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            border: Border.all(color: Palette.lavender),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t.chat.aiBadge,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Palette.lavender,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => unawaited(context.read<LocaleCubit>().toggle()),
              child: Text(t.settings.switchTo),
            ),
            IconButton(
              tooltip: t.menu.bookings,
              onPressed: () => const BookingsRoute().go(context),
              icon: const Icon(Icons.event_note_outlined),
            ),
            PopupMenuButton<String>(
              onSelected: (v) => switch (v) {
                'new' => unawaited(context.read<ChatCubit>().newChat(_locale)),
                _ => const CatalogRoute().go(context),
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'new', child: Text(t.menu.newChat)),
                PopupMenuItem(value: 'catalog', child: Text(t.menu.packages)),
              ],
            ),
          ],
        ),
        body: Chat(
          currentUserId: meId,
          chatController: _controller,
          backgroundColor: Palette.paper,
          resolveUser: (id) async => fc.User(id: id, name: id == saathiId ? t.chat.name : null),
          onMessageSend: _send,
          builders: fc.Builders(
            textMessageBuilder: (context, m, _, {required isSentByMe, groupStatus}) {
              final status = MessageStatus.values.byName(
                m.metadata?['status'] as String? ?? 'sent',
              );
              if (isSentByMe) {
                return UserBubble(
                  text: m.text,
                  status: status,
                  onRetry: () => unawaited(context.read<ChatCubit>().retry(m.id)),
                );
              }
              return SaathiBubble(
                child: SaathiText(text: m.text, interrupted: status == MessageStatus.incomplete),
              );
            },
            customMessageBuilder: (context, m, _, {required isSentByMe, groupStatus}) =>
                _custom(context, m, flagged: flagged),
            emptyChatListBuilder: (context) => _Welcome(onPick: _send),
            chatAnimatedListBuilder: (context, itemBuilder) =>
                ChatAnimatedListReversed(itemBuilder: itemBuilder),
            composerBuilder: (context) => Composer(
              hintText: t.chat.inputHint,
              sendButtonVisibilityMode: SendButtonVisibilityMode.disabled,
              sendOnEnter: true,
              topWidget: !online
                  ? _Strip(icon: Icons.wifi_off, text: t.offline.banner)
                  : flagged
                  ? _Strip(
                      icon: Icons.pause_circle_outline,
                      text: t.chat.flaggedNote,
                      action: (
                        label: t.chat.newChat,
                        onTap: () => unawaited(context.read<ChatCubit>().newChat(_locale)),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _custom(BuildContext context, fc.CustomMessage m, {required bool flagged}) {
    final t = context.t;
    final meta = m.metadata ?? const {};
    return switch (meta['kind']) {
      'tool' => SaathiBubble(
        showAvatar: false,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: ActivityChip(
            label: meta['tool'] == 'book_slot' ? t.chat.bookingSlot : t.chat.findingPackages,
          ),
        ),
      ),
      'typing' => const SaathiBubble(
        child: Align(alignment: AlignmentDirectional.centerStart, child: _TypingDots()),
      ),
      'notice' => SaathiBubble(
        showAvatar: false,
        child: NoticeBubble(
          icon: meta['code'] == 'queued_offline' ? Icons.wifi_off : Icons.bedtime_outlined,
          text: switch (meta['code']) {
            'quota_exhausted' => t.fixed.quotaExhausted,
            'user_daily_limit' => t.fixed.userLimit,
            _ => t.fixed.queuedOffline,
          },
        ),
      ),
      'card' => _card(context, ChatCard.fromJson(meta['card'] as Map<String, Object?>), flagged),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _card(BuildContext context, ChatCard card, bool flagged) {
    final t = context.t;
    return switch (card) {
      PackagesCard(:final packages) => SaathiBubble(
        showAvatar: false,
        child: Column(
          children: [
            for (final p in packages)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PackageCardView(
                  pkg: p,
                  allTests: _testsById[p.id] ?? const [],
                  onBook: flagged
                      ? null
                      : () => _send(
                          t.actions.bookPackage(name: p.name.of(_locale)),
                          kind: MessageKind.action,
                        ),
                ),
              ),
          ],
        ),
      ),
      BookingCardData(:final booking) => SaathiBubble(
        showAvatar: false,
        child: BookingCardView(
          booking: booking,
          onViewAll: () => const BookingsRoute().go(context),
        ),
      ),
      SlotsCard(:final offer) => SaathiBubble(
        showAvatar: false,
        child: SlotsCardView(
          offer: offer,
          onPick: flagged
              ? null
              : (s) => _send(
                  t.actions.bookSlot(
                    name: offer.packageName.of(_locale),
                    id: offer.packageId,
                    date: s.date,
                    window: s.timeWindow,
                    address: offer.addressLabel,
                    patient: offer.patientName,
                  ),
                  kind: MessageKind.action,
                ),
        ),
      ),
      UrgentCard() => const UrgentCareCard(),
      CrisisCard() => const CrisisSupportCard(),
    };
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onPick});

  final void Function(String) onPick;

  @override
  Widget build(BuildContext context) {
    final t = context.t.chat;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        SaathiBubble(child: SaathiText(text: t.greeting)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 40),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in t.suggestions) ActionChip(label: Text(s), onPressed: () => onPick(s)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Strip extends StatelessWidget {
  const _Strip({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final ({String label, VoidCallback onTap})? action;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Palette.ink,
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
            if (action != null)
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: action!.onTap,
                child: Text(action!.label),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat();

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Palette.surface,
        border: Border.all(color: Palette.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Opacity(
                  opacity: reduce ? 0.6 : 0.3 + 0.7 * ((_anim.value * 3 - i) % 3 < 1 ? 1 : 0),
                  child: const CircleAvatar(radius: 3.5, backgroundColor: Palette.lavender),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
