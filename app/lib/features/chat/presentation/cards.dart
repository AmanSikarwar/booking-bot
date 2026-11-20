import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/motion.dart';
import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
import '../../profile/profile.dart';
import '../../profile/profile_labels.dart';
import '../domain/models.dart';

final _rupees = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

String formatRupees(int amount) => _rupees.format(amount);

String windowLabel(BuildContext context, String window) => switch (window) {
  '07-09' => context.t.windows.w0709,
  '09-11' => context.t.windows.w0911,
  '11-13' => context.t.windows.w1113,
  '16-18' => context.t.windows.w1618,
  _ => window,
};

String dateLabel(BuildContext context, String isoDate) {
  final locale = TranslationProvider.of(context).flutterLocale.languageCode;
  return DateFormat('EEE d MMM', locale).format(DateTime.parse(isoDate));
}

String _lang(BuildContext context) => TranslationProvider.of(context).flutterLocale.languageCode;

class BookingCardView extends StatelessWidget {
  const BookingCardView({super.key, required this.booking, required this.onViewAll, this.profile});

  final Profile? profile;

  final BookingInfo booking;
  final VoidCallback? onViewAll;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: booking.bookingRef));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.t.booking.copied), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final b = booking;
    return Container(
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Palette.success,
                          size: 20,
                        ).pop(context),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            t.booking.confirmed,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Palette.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Palette.paper,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.offline_pin_outlined, size: 13, color: Palette.inkMuted),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              t.booking.savedOffline,
                              style: const TextStyle(fontSize: 11, color: Palette.inkMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: SelectableText(
                        b.bookingRef,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontFeatures: tabular,
                          color: Palette.ink,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: t.booking.copy,
                      onPressed: () => _copy(context),
                      icon: const Icon(Icons.copy_rounded, size: 18, color: Palette.inkMuted),
                    ),
                  ],
                ),
                Text(
                  b.packageName.of(_lang(context)),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.ink),
                ),
              ],
            ),
          ),
          const _Perforation(),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  Icons.event_outlined,
                  '${dateLabel(context, b.date)} · ${windowLabel(context, b.timeWindow)}',
                  caption: t.booking.collector,
                ),
                _InfoRow(
                  Icons.place_outlined,
                  b.addressLabel,
                  detail:
                      b.addressLine ??
                      switch (profile?.addressLabelled(b.addressLabel)) {
                        final a? => fullAddress(a),
                        null => null,
                      },
                ),
                _InfoRow(
                  Icons.person_outline,
                  b.patientName,
                  detail: switch (profile?.personNamed(b.patientName)) {
                    final p? => personLine(t, p),
                    null => null,
                  },
                ),
                if (b.fastingHours > 0)
                  _InfoRow(
                    Icons.no_food_outlined,
                    t.form.fasting(h: b.fastingHours),
                    emphasis: true,
                  ),
                if (onViewAll != null) ...[
                  const SizedBox(height: 6),
                  OutlinedButton(onPressed: onViewAll, child: Text(t.booking.viewAll)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text, {this.caption, this.detail, this.emphasis = false});

  final IconData icon;
  final String text;
  final String? caption;
  final String? detail;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final color = emphasis ? const Color(0xFF8A5A00) : Palette.ink;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: emphasis ? color : Palette.inkMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption != null)
                  Text(caption!, style: const TextStyle(fontSize: 11, color: Palette.inkMuted)),
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: emphasis ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (detail != null)
                  Text(
                    detail!,
                    style: const TextStyle(fontSize: 12, color: Palette.inkMuted, height: 1.35),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Perforation extends StatelessWidget {
  const _Perforation();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 12,
    width: double.infinity,
    child: CustomPaint(painter: _PerforationPainter()),
  );
}

class _PerforationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final dash = Paint()
      ..color = Palette.line
      ..strokeWidth = 1;
    for (var x = 14.0; x < size.width - 14; x += 8) {
      canvas.drawLine(Offset(x, y), Offset(x + 4, y), dash);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SlotsCardView extends StatelessWidget {
  const SlotsCardView({super.key, required this.offer, required this.onPick});

  final SlotOffer offer;
  final void Function(Slot slot)? onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Palette.line),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.event_busy_outlined, size: 20, color: Palette.inkMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.t.slots.full, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      '${dateLabel(context, offer.requested.date)} · ${windowLabel(context, offer.requested.timeWindow)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Palette.inkMuted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in offer.alternatives)
                ActionChip(
                  avatar: const Icon(Icons.schedule, size: 16, color: Palette.teal),
                  label: Text(
                    '${dateLabel(context, s.date)} · ${windowLabel(context, s.timeWindow)}',
                  ),
                  onPressed: onPick == null ? null : () => onPick!(s),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _call(String number) => launchUrl(Uri(scheme: 'tel', path: number));

class UrgentCareCard extends StatelessWidget {
  const UrgentCareCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return _SafetyCard(
      color: Palette.urgent,
      icon: Icons.emergency_outlined,
      text: t.fixed.urgentCare,
      actions: [(label: t.urgent.call112, number: '112'), (label: t.urgent.call108, number: '108')],
    );
  }
}

class CrisisSupportCard extends StatelessWidget {
  const CrisisSupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return _SafetyCard(
      color: Palette.crisis,
      icon: Icons.favorite_outline,
      text: t.fixed.crisisSupport,
      actions: [(label: t.urgent.call14416, number: '14416')],
    );
  }
}

class _SafetyCard extends StatefulWidget {
  const _SafetyCard({
    required this.color,
    required this.icon,
    required this.text,
    required this.actions,
  });

  final Color color;
  final IconData icon;
  final String text;
  final List<({String label, String number})> actions;

  @override
  State<_SafetyCard> createState() => _SafetyCardState();
}

class _SafetyCardState extends State<_SafetyCard> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in widget.actions)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: widget.color,
                      textStyle: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    onPressed: () => _call(a.number),
                    icon: const Icon(Icons.call),
                    label: Text(a.label),
                  ),
                if (!_acknowledged && widget.actions.length > 1)
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () => setState(() => _acknowledged = true),
                    child: Text(context.t.urgent.understood),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
