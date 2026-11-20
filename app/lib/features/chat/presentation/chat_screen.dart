import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as fc;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../core/db/database.dart';
import '../../../core/di.dart';
import '../../../core/layout.dart';
import '../../../core/motion.dart';
import '../../../core/router.dart';
import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
import '../../bookings/bookings_screen.dart';
import '../../catalog/catalog_screen.dart';
import '../../catalog/package.dart';
import '../../history/history.dart';
import '../../profile/profile_cubit.dart';
import '../../profile/profile_screen.dart';
import '../../settings/locale_cubit.dart';
import '../domain/models.dart';
import 'booking_form.dart';
import 'bubbles.dart';
import 'cards.dart';
import 'chat_cubit.dart';
import 'chat_items.dart';
import 'package_card.dart';
import 'suggestions.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = SyncedChatController();
  late final Map<String, LabPackage> _byId = {for (final p in getIt<Catalog>().packages) p.id: p};

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
        appBar: SaathiAppBar(size: size, onNewChat: _newChat),
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
    final messages = context.select((ChatCubit c) => c.state.messages);
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
            ).enterOnce(context, m.id);
          }
          return SaathiBubble(
            child: SaathiText(text: m.text, interrupted: status == MessageStatus.incomplete),
          ).enterOnce(context, m.id);
        },
        customMessageBuilder: (context, m, _, {required isSentByMe, groupStatus}) =>
            (m.metadata?['card'] as Map<String, Object?>?)?['type'] == 'packages'
            ? _custom(context, m, flagged: flagged)
            : _custom(context, m, flagged: flagged).enterOnce(context, m.id),
        emptyChatListBuilder: (context) => const _Welcome(),
        chatAnimatedListBuilder: (context, itemBuilder) =>
            ChatAnimatedListReversed(itemBuilder: itemBuilder),
        composerBuilder: (context) => Composer(
          hintText: t.chat.inputHint,
          sendButtonVisibilityMode: SendButtonVisibilityMode.disabled,
          sendOnEnter: true,
          maxLines: 5,
          backgroundColor: Palette.paper,
          inputFillColor: Palette.surface,
          sendIconColor: Palette.teal,
          emptyFieldSendIconColor: Palette.inkMuted,
          hintColor: Palette.inkMuted,
          textColor: Palette.ink,
          topWidget: _composerTop(
            t,
            online: online,
            flagged: flagged,
            suggestions: suggestionsFor(t, messages, flagged: flagged, lang: _locale),
          ),
        ),
      ),
    );
  }

  void _onSuggestion(Suggestion s) => switch (s) {
    SendSuggestion(:final text) => _send(text),
    BookSuggestion(:final packageId, :final name) => _openForm(packageId, name),
    OpenSuggestion(destination: Destination.bookings) => const BookingsRoute().go(context),
    OpenSuggestion(destination: Destination.catalog) => const CatalogRoute().go(context),
  };

  Widget? _composerTop(
    Translations t, {
    required bool online,
    required bool flagged,
    required List<Suggestion> suggestions,
  }) {
    final strip = !online
        ? _Strip(
            key: const ValueKey('offline'),
            icon: Icons.wifi_off,
            text: t.offline.banner,
          ).enter(context, rise: 12)
        : flagged
        ? _Strip(
            key: const ValueKey('flagged'),
            icon: Icons.pause_circle_outline,
            text: t.chat.flaggedNote,
            action: (label: t.chat.newChat, onTap: _newChat),
          ).enter(context, rise: 12)
        : null;
    final bar = suggestions.isEmpty
        ? null
        : SuggestionBar(
            key: ValueKey(suggestions.map((s) => s.label).join('|')),
            items: suggestions,
            onTap: _onSuggestion,
          );
    if (strip == null) return bar;
    if (bar == null) return strip;
    return Column(mainAxisSize: MainAxisSize.min, children: [strip, bar]);
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
        m.id,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  void _openForm(String packageId, Localized name) {
    final pkg = _byId[packageId];
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

  Widget _card(
    BuildContext context,
    ChatCard card,
    bool flagged,
    Map<String, Object?> meta,
    String itemId,
  ) {
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
            for (final (i, p) in packages.indexed)
              PackageCardView(
                pkg: p,
                details: _byId[p.id],
                topMatch: i == 0 && packages.length > 1,
                onBook: flagged ? null : () => _openForm(p.id, p.name),
              ).enterOnce(context, '$itemId/$i', delay: Motion.stagger * i),
          ],
        ),
      ),
      BookingCardData(:final booking) => SaathiBubble(
        showAvatar: false,
        maxWidth: 420,
        fullBleedOnCompact: true,
        child: BookingCardView(
          booking: booking,
          profile: context.watch<ProfileCubit>().state,
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
          profile: context.watch<ProfileCubit>().state,
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

class SaathiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SaathiAppBar({super.key, required this.size, required this.onNewChat});

  final WindowSize size;
  final VoidCallback onNewChat;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final compact = size == WindowSize.compact;
    final roomy = MediaQuery.sizeOf(context).width >= 1120 && !context.largeText;
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
        if (size == WindowSize.medium)
          for (final (icon, label, go) in [
            (Icons.forum_outlined, t.menu.history, () => const HistoryRoute().go(context)),
            (Icons.event_note_outlined, t.menu.bookings, () => const BookingsRoute().go(context)),
            (Icons.science_outlined, t.menu.packages, () => const CatalogRoute().go(context)),
          ])
            roomy
                ? TextButton.icon(onPressed: go, icon: Icon(icon), label: Text(label))
                : IconButton(tooltip: label, onPressed: go, icon: Icon(icon)),
        if (!compact)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4),
            child: IconButton(
              tooltip: t.profile.title,
              onPressed: () => const ProfileRoute().go(context),
              icon: ProfileAvatar(name: context.watch<ProfileCubit>().state.self.name, size: 32),
            ),
          ),
        if (compact)
          IconButton(
            tooltip: t.menu.newChat,
            onPressed: onNewChat,
            icon: const Icon(Icons.add_comment_outlined),
          )
        else
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 12),
            child: roomy || size == WindowSize.expanded
                ? FilledButton.tonalIcon(
                    onPressed: onNewChat,
                    icon: const Icon(Icons.add_comment_outlined),
                    label: Text(t.menu.newChat),
                  )
                : IconButton.filledTonal(
                    tooltip: t.menu.newChat,
                    onPressed: onNewChat,
                    icon: const Icon(Icons.add_comment_outlined),
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
      border: Border.all(color: Palette.teal),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      context.t.chat.aiBadge,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Palette.teal),
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
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Palette.teal,
              indicatorColor: Palette.teal,
              unselectedLabelColor: Palette.inkMuted,
              tabs: [
                Tab(text: t.menu.history),
                Tab(text: t.menu.bookings),
                Tab(text: t.menu.packages),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  HistoryList(),
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

class SuggestionBar extends StatelessWidget {
  const SuggestionBar({super.key, required this.items, required this.onTap});

  final List<Suggestion> items;
  final void Function(Suggestion) onTap;

  @override
  Widget build(BuildContext context) {
    final chips = staggered(context, [
      for (final s in items)
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
          child: ActionChip(
            avatar: Icon(s.icon, size: 16, color: Palette.teal),
            label: Text(s.label),
            backgroundColor: Palette.surface,
            onPressed: () => onTap(s),
          ),
        ),
    ]);
    const padding = EdgeInsets.fromLTRB(16, 6, 16, 2);
    return Semantics(
      container: true,
      label: context.t.chat.tryAsking,
      child: context.windowSize == WindowSize.compact
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: padding,
              child: Row(
                children: [
                  for (final c in chips)
                    Padding(padding: const EdgeInsetsDirectional.only(end: 8), child: c),
                ],
              ),
            )
          : Padding(
              padding: padding,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Wrap(spacing: 8, runSpacing: 8, children: chips),
              ),
            ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final showBrowse = context.windowSize == WindowSize.medium;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        SaathiBubble(child: SaathiText(text: t.chat.greeting)).enter(context),
        if (showBrowse)
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
  const _Strip({super.key, required this.icon, required this.text, this.action});

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
                  child: const CircleAvatar(radius: 3.5, backgroundColor: Palette.teal),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
