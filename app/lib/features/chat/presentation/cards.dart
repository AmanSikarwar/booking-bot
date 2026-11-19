import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
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

class TubeCaps extends StatelessWidget {
  const TubeCaps({super.key, required this.tests});

  final List<String> tests;

  @override
  Widget build(BuildContext context) {
    final tubes = tubesFor(tests);
    final t = context.t.tubes;
    final names = tubes
        .map(
          (tube) => switch (tube) {
            Tube.lavender => t.lavender,
            Tube.grey => t.grey,
            Tube.gold => t.gold,
            Tube.urine => t.urine,
          },
        )
        .join(', ');
    return Semantics(
      label: t.label(names: names),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final tube in tubes)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 3),
                child: Container(
                  width: tube == Tube.urine ? 12 : 10,
                  height: 16,
                  decoration: BoxDecoration(
                    color: tube.color,
                    borderRadius: tube == Tube.urine
                        ? BorderRadius.circular(3)
                        : const BorderRadius.vertical(
                            top: Radius.circular(5),
                            bottom: Radius.circular(2),
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

class PackageCardView extends StatefulWidget {
  const PackageCardView({
    super.key,
    required this.pkg,
    required this.allTests,
    required this.onBook,
  });

  final PackageSummary pkg;
  final List<String> allTests;
  final VoidCallback? onBook;

  @override
  State<PackageCardView> createState() => _PackageCardViewState();
}

class _PackageCardViewState extends State<PackageCardView> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.pkg;
    final t = context.t.package;
    final lang = _lang(context);
    final tests = widget.allTests.isEmpty ? p.topTests : widget.allTests;
    final strip = tubesFor(tests).firstOrNull?.color ?? Palette.lavender;
    final facts = [
      t.tests(n: p.testCount),
      p.fastingHours > 0 ? t.fasting(h: p.fastingHours) : t.noFasting,
      t.report(h: p.reportTatHours),
    ].join(' · ');
    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: strip),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            p.name.of(lang),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Palette.ink,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: TubeCaps(tests: tests),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.matchReason.of(lang),
                      style: const TextStyle(fontSize: 13, color: Palette.lavender),
                    ),
                    const SizedBox(height: 6),
                    Text(facts, style: const TextStyle(fontSize: 13, color: Palette.inkMuted)),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formatRupees(p.priceInr),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Palette.ink,
                            fontFeatures: tabular,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (p.mrpInr > p.priceInr)
                          Text(
                            formatRupees(p.mrpInr),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.inkMuted,
                              decoration: TextDecoration.lineThrough,
                              fontFeatures: tabular,
                            ),
                          ),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 180),
                      alignment: Alignment.topCenter,
                      child: _expanded
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final test in tests)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Palette.paper,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(test, style: const TextStyle(fontSize: 12)),
                                    ),
                                ],
                              ),
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (widget.onBook != null)
                          FilledButton(onPressed: widget.onBook, child: Text(t.book)),
                        OutlinedButton(
                          onPressed: () => setState(() => _expanded = !_expanded),
                          child: Text(_expanded ? t.hideTests : t.viewTests),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingCardView extends StatelessWidget {
  const BookingCardView({super.key, required this.booking, required this.onViewAll});

  final BookingInfo booking;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final t = context.t.booking;
    final b = booking;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Palette.success, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    t.confirmed,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.success),
                  ),
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
                      Text(
                        t.savedOffline,
                        style: const TextStyle(fontSize: 11, color: Palette.inkMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(
              b.bookingRef,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                fontFeatures: tabular,
                color: Palette.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              b.packageName.of(_lang(context)),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              '${dateLabel(context, b.date)} · ${windowLabel(context, b.timeWindow)}',
              style: const TextStyle(color: Palette.ink),
            ),
            Text(
              '${b.addressLabel} · ${t.forPatient(name: b.patientName)}',
              style: const TextStyle(color: Palette.inkMuted),
            ),
            if (onViewAll != null) ...[
              const SizedBox(height: 10),
              OutlinedButton(onPressed: onViewAll, child: Text(t.viewAll)),
            ],
          ],
        ),
      ),
    );
  }
}

class SlotsCardView extends StatelessWidget {
  const SlotsCardView({super.key, required this.offer, required this.onPick});

  final SlotOffer offer;
  final void Function(Slot slot)? onPick;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.t.slots.full, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in offer.alternatives)
                  ActionChip(
                    label: Text(
                      '${dateLabel(context, s.date)} · ${windowLabel(context, s.timeWindow)}',
                    ),
                    onPressed: onPick == null ? null : () => onPick!(s),
                  ),
              ],
            ),
          ],
        ),
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
