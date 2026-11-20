import 'package:material_ui/material_ui.dart';

import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
import '../../catalog/package.dart';
import '../domain/models.dart';
import 'cards.dart';

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
    final blood = tubes.where((x) => x != Tube.urine).length;
    final hasUrine = tubes.contains(Tube.urine);
    final summary = blood == 0
        ? t.urineCup
        : hasUrine
        ? t.and(
            tubes: t.count(n: blood),
            extra: t.urineCup,
          )
        : t.count(n: blood);
    return Semantics(
      container: true,
      label: t.label(names: names),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final tube in tubes)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 3),
                child: Container(
                  width: tube == Tube.urine ? 11 : 8,
                  height: 14,
                  decoration: BoxDecoration(
                    color: tube.color,
                    borderRadius: tube == Tube.urine
                        ? BorderRadius.circular(3)
                        : const BorderRadius.vertical(
                            top: Radius.circular(4),
                            bottom: Radius.circular(2),
                          ),
                  ),
                ),
              ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(summary, style: const TextStyle(fontSize: 12, color: Palette.inkMuted)),
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
    this.details,
    this.highlight,
    this.topMatch = false,
    required this.onBook,
  });

  final PackageSummary pkg;
  final LabPackage? details;
  final Localized? highlight;
  final bool topMatch;
  final VoidCallback? onBook;

  @override
  State<PackageCardView> createState() => _PackageCardViewState();
}

class _PackageCardViewState extends State<PackageCardView> {
  static const _preview = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.pkg;
    final d = widget.details;
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final tests = d?.tests ?? p.topTests;
    final shown = _expanded ? tests : tests.take(_preview).toList();
    final off = p.mrpInr > p.priceInr ? ((p.mrpInr - p.priceInr) * 100 / p.mrpInr).round() : 0;
    final category = d?.category;
    return Container(
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.topMatch ? Palette.lavender.withAlpha(110) : Palette.line),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Palette.lavenderSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(categoryIcon(category ?? ''), color: Palette.lavender, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.topMatch)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _Badge(t.package.topMatch),
                      ),
                    Text(
                      p.name.of(lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Palette.ink,
                        height: 1.3,
                      ),
                    ),
                    if (category != null)
                      Text(
                        t.categories[category] ?? category,
                        style: const TextStyle(fontSize: 12, color: Palette.inkMuted),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.highlight != null)
            _Highlight(widget.highlight!.of(lang))
          else if (d != null)
            Text(
              d.description.of(lang),
              style: const TextStyle(fontSize: 13, color: Palette.inkMuted, height: 1.4),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final test in shown) _TestTag(test),
              if (tests.length > _preview)
                Semantics(
                  button: true,
                  expanded: _expanded,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              _expanded ? t.package.showLess : t.package.showAll(n: tests.length),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Palette.lavender,
                              ),
                            ),
                          ),
                          Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more,
                            size: 16,
                            color: Palette.lavender,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _Fact(Icons.science_outlined, t.package.tests(n: p.testCount)),
              _Fact(Icons.schedule, t.package.report(h: p.reportTatHours)),
              _Fact(
                p.fastingHours > 0 ? Icons.no_food_outlined : Icons.restaurant_outlined,
                p.fastingHours > 0 ? t.package.fasting(h: p.fastingHours) : t.package.noFasting,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TubeCaps(tests: tests),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Palette.line),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                formatRupees(p.priceInr),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                  fontFeatures: tabular,
                ),
              ),
              if (off > 0) ...[
                Text(
                  formatRupees(p.mrpInr),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Palette.inkMuted,
                    decoration: TextDecoration.lineThrough,
                    fontFeatures: tabular,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Palette.success.withAlpha(24),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    t.package.off(n: off),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Palette.success,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (widget.onBook != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: widget.onBook,
                icon: const Icon(Icons.home_outlined, size: 18),
                label: Text(t.package.book),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: Palette.lavender, borderRadius: BorderRadius.circular(20)),
    child: Text(
      label,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
    ),
  );
}

class _Highlight extends StatelessWidget {
  const _Highlight(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(color: Palette.lavenderSoft, borderRadius: BorderRadius.circular(10)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.auto_awesome_outlined, size: 15, color: Palette.lavender),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Palette.lavender, height: 1.35),
          ),
        ),
      ],
    ),
  );
}

class _TestTag extends StatelessWidget {
  const _TestTag(this.name);

  final String name;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Palette.paper,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Palette.line),
    ),
    child: Text(name, style: const TextStyle(fontSize: 12, color: Palette.ink)),
  );
}

class _Fact extends StatelessWidget {
  const _Fact(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: Palette.inkMuted),
      const SizedBox(width: 4),
      Flexible(
        child: Text(label, style: const TextStyle(fontSize: 12.5, color: Palette.ink)),
      ),
    ],
  );
}
