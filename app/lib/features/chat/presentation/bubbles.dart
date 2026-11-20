import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/db/database.dart';
import '../../../core/layout.dart';
import '../../../core/motion.dart';
import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';

class SaathiAvatar extends StatelessWidget {
  const SaathiAvatar({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: Palette.tealSoft, shape: BoxShape.circle),
        child: CustomPaint(painter: _DropletPainter()),
      ),
    );
  }
}

class _DropletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * .5, h * .2)
      ..cubicTo(w * .5, h * .2, w * .26, h * .5, w * .26, h * .62)
      ..arcToPoint(Offset(w * .74, h * .62), radius: Radius.circular(w * .24), clockwise: false)
      ..cubicTo(w * .74, h * .5, w * .5, h * .2, w * .5, h * .2)
      ..close();
    canvas.drawPath(path, Paint()..color = Palette.teal);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UserBubble extends StatelessWidget {
  const UserBubble({
    super.key,
    required this.text,
    required this.status,
    this.onRetry,
    this.isAction = false,
  });

  final String text;
  final MessageStatus status;
  final VoidCallback? onRetry;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    final failed = status == MessageStatus.failed;
    final label = switch (status) {
      MessageStatus.queued => context.t.status.queued,
      MessageStatus.sending || MessageStatus.streaming => context.t.status.sending,
      MessageStatus.failed => context.t.status.failed,
      MessageStatus.incomplete => context.t.status.incomplete,
      MessageStatus.sent => null,
    };
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isAction ? Palette.tealSoft : Palette.teal,
                border: isAction ? Border.all(color: Palette.teal.withAlpha(60)) : null,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(18),
                  topEnd: Radius.circular(18),
                  bottomStart: Radius.circular(18),
                  bottomEnd: Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAction)
                    const Padding(
                      padding: EdgeInsetsDirectional.only(end: 6, top: 2),
                      child: Icon(Icons.touch_app_outlined, size: 16, color: Palette.teal),
                    ),
                  Flexible(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isAction ? Palette.teal : Colors.white,
                        fontSize: isAction ? 14 : 15,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (label != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: InkWell(
                  onTap: failed ? onRetry : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          switch (status) {
                            MessageStatus.failed => Icons.refresh,
                            MessageStatus.queued => Icons.schedule,
                            _ => Icons.more_horiz,
                          },
                          size: 14,
                          color: failed ? Palette.urgent : Palette.inkMuted,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              color: failed ? Palette.urgent : Palette.inkMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SaathiBubble extends StatelessWidget {
  const SaathiBubble({
    super.key,
    required this.child,
    this.showAvatar = true,
    this.maxWidth = 560,
    this.fullBleedOnCompact = false,
  });

  final Widget child;
  final bool showAvatar;
  final double maxWidth;
  final bool fullBleedOnCompact;

  @override
  Widget build(BuildContext context) {
    final constrained = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );
    if (fullBleedOnCompact && context.windowSize == WindowSize.compact) {
      return Align(alignment: AlignmentDirectional.centerStart, child: constrained);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 32, child: showAvatar ? const SaathiAvatar() : null),
        const SizedBox(width: 8),
        Flexible(child: constrained),
      ],
    );
  }
}

class SaathiText extends StatelessWidget {
  const SaathiText({super.key, required this.text, this.interrupted = false});

  final String text;
  final bool interrupted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Palette.surface,
        border: Border.all(color: Palette.line),
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(4),
          topEnd: Radius.circular(18),
          bottomStart: Radius.circular(18),
          bottomEnd: Radius.circular(18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: const TextStyle(color: Palette.ink, fontSize: 15, height: 1.4)),
          if (interrupted)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                context.t.status.incomplete,
                style: const TextStyle(fontSize: 12, color: Palette.inkMuted),
              ),
            ),
        ],
      ),
    );
  }
}

class ActivityChip extends StatelessWidget {
  const ActivityChip({super.key, required this.label, this.showTypingDots = false});

  final String label;
  final bool showTypingDots;

  @override
  Widget build(BuildContext context) {
    final animate = Motion.on(context);
    final text = Text(label, style: const TextStyle(fontSize: 13, color: Palette.teal));
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Palette.tealSoft, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTypingDots)
              animate ? const _TypingDots() : const Icon(Icons.more_horiz, size: 18)
            else if (animate)
              const SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: Palette.teal),
              )
            else
              const Icon(Icons.hourglass_top_outlined, size: 14),
            const SizedBox(width: 8),
            Flexible(child: showTypingDots ? text : _shimmer(context, text)),
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
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Opacity(
              opacity: (_anim.value * 3 - i) % 3 < 1 ? 1.0 : 0.3,
              child: const CircleAvatar(radius: 2.5, backgroundColor: Palette.teal),
            ),
          ),
      ],
    ),
  );
}

class NoticeBubble extends StatelessWidget {
  const NoticeBubble({super.key, required this.text, this.icon = Icons.wifi_off});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Palette.paper,
        border: Border.all(color: Palette.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Palette.inkMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Palette.ink, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _shimmer(BuildContext context, Widget child) => Motion.on(context)
    ? child
          .animate(onPlay: (c) => c.repeat())
          .shimmer(duration: 1600.ms, color: Colors.white.withAlpha(200))
    : child;
