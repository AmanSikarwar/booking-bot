import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as fc;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../core/db/database.dart';
import '../../../core/di.dart';
import '../../../core/layout.dart';
import '../../../core/router.dart';
import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
import '../../bookings/bookings_screen.dart';
import '../../catalog/catalog_screen.dart';
import '../../catalog/package.dart';
import '../../settings/locale_cubit.dart';
import '../domain/models.dart';
import 'booking_form.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync();
    });
  }

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

  void _send(String text, {MessageKind kind = MessageKind.text, String? display}) =>
      unawaited(context.read<ChatCubit>().send(text, _locale, kind: kind, display: display));

  String _slotSummary(Localized name, Slot slot, String address, String patient) => [
    name.of(_locale),
    dateLabel(context, slot.date),
    windowLabel(context, slot.timeWindow),
    address,
    context.t.booking.forPatient(name: patient),
  ].join(' · ');

  void _newChat() => unawaited(context.read<ChatCubit>().newChat(_locale));

  @override
  Widget build(BuildContext context) {
    final size = context.windowSize;
    final chat = _chat(context);
    final column = size == WindowSize.compact
        ? chat
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: chatColumnWidth),
              child: chat,
            ),
          );
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatCubit, ChatState>(
          listenWhen: (a, b) => a.messages != b.messages,
          listener: (_, _) => _sync(),
        ),
        BlocListener<ConnectivityCubit, bool>(listener: (_, _) => _sync()),
      ],
      child: Scaffold(
        appBar: _SaathiAppBar(size: size, onNewChat: _newChat),
        body: size == WindowSize.expanded
            ? Row(
                children: [
                  Expanded(child: column),
                  const VerticalDivider(width: 1, color: Palette.line),
                  SizedBox(width: sidePanelWidth, child: _SidePanel()),
                ],
              )
            : column,
      ),
    );
  }

  Widget _chat(BuildContext context) {
    final t = context.t;
    final flagged = context.select((ChatCubit c) => c.state.flagged);
    final online = context.watch<ConnectivityCubit>().state;
    return Chat(
      currentUserId: meId,
      chatController: _controller,
      backgroundColor: Palette.paper,
      resolveUser: (id) async => fc.User(id: id, name: id == saathiId ? t.chat.name : null),
      onMessageSend: _send,
      builders: fc.Builders(
        textMessageBuilder: (context, m, _, {required isSentByMe, groupStatus}) {
          final status = MessageStatus.values.byName(m.metadata?['status'] as String? ?? 'sent');
          if (isSentByMe) {
            return UserBubble(
              text: m.text,
              status: status,
              isAction: m.metadata?['kind'] == 'action',
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
          maxLines: 5,
          backgroundColor: Palette.paper,
          inputFillColor: Palette.surface,
          sendIconColor: Palette.lavender,
          emptyFieldSendIconColor: Palette.inkMuted,
          hintColor: Palette.inkMuted,
          textColor: Palette.ink,
          topWidget: !online
              ? _Strip(icon: Icons.wifi_off, text: t.offline.banner)
              : flagged
              ? _Strip(
                  icon: Icons.pause_circle_outline,
                  text: t.chat.flaggedNote,
                  action: (label: t.chat.newChat, onTap: _newChat),
                )
              : null,
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
      'card' => _card(
        context,
        ChatCard.fromJson(meta['card'] as Map<String, Object?>),
        flagged,
        meta,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  void _openForm(String packageId, Localized name) {
    final pkg = getIt<Catalog>().packages.where((p) => p.id == packageId).firstOrNull;
    unawaited(
      context.read<ChatCubit>().openBookingForm(
        BookingFormData(
          packageId: packageId,
          packageName: name,
          fastingHours: pkg?.fastingHours ?? 0,
        ),
        _locale,
      ),
    );
  }

  Widget _card(BuildContext context, ChatCard card, bool flagged, Map<String, Object?> meta) {
    final t = context.t;
    return switch (card) {
      PackagesCard(:final packages) => SaathiBubble(
        showAvatar: false,
        maxWidth: 700,
        fullBleedOnCompact: true,
        child: ResponsiveWrap(
          minItemWidth: 300,
          maxColumns: 2,
          children: [
            for (final p in packages)
              PackageCardView(
                pkg: p,
                allTests: _testsById[p.id] ?? const [],
                onBook: flagged ? null : () => _openForm(p.id, p.name),
              ),
          ],
        ),
      ),
      BookingCardData(:final booking) => SaathiBubble(
        showAvatar: false,
        maxWidth: 420,
        fullBleedOnCompact: true,
        child: BookingCardView(
          booking: booking,
          onViewAll: context.windowSize == WindowSize.expanded
              ? null
              : () => const BookingsRoute().go(context),
        ),
      ),
      SlotsCard(:final offer) => SaathiBubble(
        showAvatar: false,
        fullBleedOnCompact: true,
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
                  display: _slotSummary(
                    offer.packageName,
                    s,
                    offer.addressLabel,
                    offer.patientName,
                  ),
                ),
        ),
      ),
      BookingFormCard(:final form) => SaathiBubble(
        showAvatar: false,
        maxWidth: 480,
        fullBleedOnCompact: true,
        child: BookingFormView(
          form: form,
          onSubmit: flagged
              ? null
              : (r) => unawaited(
                  context.read<ChatCubit>().submitBookingForm(
                    rowId: meta['rowId']! as String,
                    cardIndex: meta['index']! as int,
                    request: r,
                    locale: _locale,
                    display: _slotSummary(
                      form.packageName,
                      Slot(date: r.date, timeWindow: r.timeWindow),
                      r.addressLabel,
                      r.patientName,
                    ),
                    text: t.actions.bookSlot(
                      name: form.packageName.of(_locale),
                      id: form.packageId,
                      date: r.date,
                      window: r.timeWindow,
                      address: r.addressLabel,
                      patient: r.patientName,
                    ),
                  ),
                ),
        ),
      ),
      UrgentCard() => const _SafetyWidth(child: UrgentCareCard()),
      CrisisCard() => const _SafetyWidth(child: CrisisSupportCard()),
    };
  }
}

class _SafetyWidth extends StatelessWidget {
  const _SafetyWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 640), child: child),
  );
}

class _SaathiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SaathiAppBar({required this.size, required this.onNewChat});

  final WindowSize size;
  final VoidCallback onNewChat;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final compact = size == WindowSize.compact;
    return AppBar(
      titleSpacing: compact ? 12 : 20,
      title: Row(
        children: [
          const SaathiAvatar(size: 36),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.chat.name,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                if (!context.largeText)
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          t.chat.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Palette.inkMuted),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const _AiBadge(),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _LanguageButton(showIcon: !compact),
        if (size == WindowSize.medium) ...[
          TextButton.icon(
            onPressed: () => const BookingsRoute().go(context),
            icon: const Icon(Icons.event_note_outlined),
            label: Text(t.menu.bookings),
          ),
          TextButton.icon(
            onPressed: () => const CatalogRoute().go(context),
            icon: const Icon(Icons.science_outlined),
            label: Text(t.menu.packages),
          ),
        ],
        if (compact)
          IconButton(
            tooltip: t.menu.bookings,
            onPressed: () => const BookingsRoute().go(context),
            icon: const Icon(Icons.event_note_outlined),
          ),
        if (compact)
          PopupMenuButton<String>(
            onSelected: (v) => v == 'new' ? onNewChat() : const CatalogRoute().go(context),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'new', child: Text(t.menu.newChat)),
              PopupMenuItem(value: 'catalog', child: Text(t.menu.packages)),
            ],
          )
        else
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 12),
            child: FilledButton.tonalIcon(
              onPressed: onNewChat,
              icon: const Icon(Icons.add_comment_outlined),
              label: Text(t.menu.newChat),
            ),
          ),
      ],
    );
  }
}

class _AiBadge extends StatelessWidget {
  const _AiBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      border: Border.all(color: Palette.lavender),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      context.t.chat.aiBadge,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Palette.lavender),
    ),
  );
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.showIcon});

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final label = Text(context.t.settings.switchTo);
    void toggle() => unawaited(context.read<LocaleCubit>().toggle());
    return Tooltip(
      message: context.t.settings.language,
      child: showIcon
          ? TextButton.icon(onPressed: toggle, icon: const Icon(Icons.translate), label: label)
          : TextButton(onPressed: toggle, child: label),
    );
  }
}

class _SidePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return ColoredBox(
      color: Palette.surface,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Palette.lavender,
              indicatorColor: Palette.lavender,
              unselectedLabelColor: Palette.inkMuted,
              tabs: [
                Tab(text: t.menu.bookings),
                Tab(text: t.menu.packages),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  BookingsList(padding: EdgeInsets.all(16)),
                  CatalogList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onPick});

  final void Function(String) onPick;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final expanded = context.windowSize == WindowSize.expanded;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        SaathiBubble(child: SaathiText(text: t.chat.greeting)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 40),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in t.chat.suggestions)
                ActionChip(label: Text(s), onPressed: () => onPick(s)),
            ],
          ),
        ),
        if (!expanded)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 32, top: 12),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => const CatalogRoute().go(context),
                icon: const Icon(Icons.science_outlined, size: 18),
                label: Text(t.catalog.browse),
              ),
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
