import 'package:material_ui/material_ui.dart';

import '../../../core/layout.dart';
import '../../../core/motion.dart';
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

class PackageCardView extends StatelessWidget {
  const PackageCardView({
    super.key,
    required this.pkg,
    this.details,
    this.topMatch = false,
    required this.onBook,
  });

  static const _preview = 3;

  final PackageSummary pkg;
  final LabPackage? details;
  final bool topMatch;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final p = pkg;
    final d = details;
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final tests = d?.tests ?? p.topTests;
    final category = d?.category;
    final more = p.testCount - tests.take(_preview).length;
    return Material(
      color: Palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: topMatch ? Palette.lavender.withAlpha(110) : Palette.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showPackageDetails(context, pkg: p, details: d, onBook: onBook),
        child: Semantics(
          button: true,
          hint: t.details.view,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(pkg: p, category: category, topMatch: topMatch),
                if (d != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    d.description.of(lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Palette.inkMuted, height: 1.4),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final test in tests.take(_preview)) _TestTag(test),
                    if (more > 0) _TestTag(t.details.more(n: more), accent: true),
                  ],
                ),
                const SizedBox(height: 12),
                _Facts(pkg: p),
                const SizedBox(height: 8),
                TubeCaps(tests: tests),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Palette.line),
                ),
                Row(
                  children: [
                    Expanded(child: _Price(pkg: p)),
                    Text(
                      t.details.view,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Palette.lavender,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: Palette.lavender),
                  ],
                ),
                if (onBook != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onBook,
                      icon: const Icon(Icons.home_outlined, size: 18),
                      label: Text(t.package.book),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showPackageDetails(
  BuildContext context, {
  required PackageSummary pkg,
  LabPackage? details,
  VoidCallback? onBook,
}) {
  void book(BuildContext sheet) {
    Navigator.of(sheet).pop();
    onBook?.call();
  }

  if (context.windowSize == WindowSize.compact) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Palette.surface,
      builder: (sheet) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => PackageDetailsView(
          pkg: pkg,
          details: details,
          controller: controller,
          onBook: onBook == null ? null : () => book(sheet),
        ),
      ),
    );
  }
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    builder: (dialog) => Dialog(
      backgroundColor: Palette.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(dialog).height * 0.85,
        ),
        child: PackageDetailsView(
          pkg: pkg,
          details: details,
          showClose: true,
          onBook: onBook == null ? null : () => book(dialog),
        ),
      ),
    ),
  );
}

class PackageDetailsView extends StatelessWidget {
  const PackageDetailsView({
    super.key,
    required this.pkg,
    this.details,
    this.controller,
    this.showClose = false,
    this.onBook,
  });

  final PackageSummary pkg;
  final LabPackage? details;
  final ScrollController? controller;
  final bool showClose;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final p = pkg;
    final d = details;
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final tests = d?.tests ?? p.topTests;
    final samples = [
      for (final s in (d?.sampleType ?? 'blood').split(','))
        switch (s.trim()) {
          'urine' => t.details.urine,
          _ => t.details.blood,
        },
    ].join(', ');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView(
            controller: controller,
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(20, showClose ? 20 : 0, 20, 20),
            children: staggered(context, interval: const Duration(milliseconds: 25), [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Title(pkg: p, category: d?.category, large: true),
                  ),
                  if (showClose)
                    IconButton(
                      tooltip: t.details.close,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              _Price(pkg: p, large: true),
              if (d != null) ...[
                _Section(t.details.about),
                Text(
                  d.description.of(lang),
                  style: const TextStyle(fontSize: 15, color: Palette.ink, height: 1.5),
                ),
              ],
              _Section(t.details.facts),
              _FactRow(Icons.science_outlined, t.package.tests(n: p.testCount)),
              _FactRow(Icons.schedule, t.package.report(h: p.reportTatHours)),
              _FactRow(Icons.water_drop_outlined, '${t.details.sample}: $samples'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TubeCaps(tests: tests),
              ),
              _Section(t.details.included),
              for (final test in tests)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18, color: Palette.success),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(test, style: const TextStyle(fontSize: 15, color: Palette.ink)),
                      ),
                    ],
                  ),
                ),
              _Section(t.details.prep),
              _FactRow(
                p.fastingHours > 0 ? Icons.no_food_outlined : Icons.restaurant_outlined,
                p.fastingHours > 0 ? t.details.fastPrep(h: p.fastingHours) : t.details.noFastPrep,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Palette.paper,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: Palette.inkMuted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.details.doctorNote,
                        style: const TextStyle(fontSize: 13, color: Palette.inkMuted, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        if (onBook != null)
          Container(
            decoration: const BoxDecoration(
              color: Palette.surface,
              border: Border(top: BorderSide(color: Palette.line)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onBook,
                  icon: const Icon(Icons.home_outlined, size: 18),
                  label: Text(t.package.book),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.pkg,
    required this.category,
    this.topMatch = false,
    this.large = false,
  });

  final PackageSummary pkg;
  final String? category;
  final bool topMatch;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Container(
            width: large ? 48 : 40,
            height: large ? 48 : 40,
            decoration: const BoxDecoration(color: Palette.lavenderSoft, shape: BoxShape.circle),
            child: Icon(
              categoryIcon(category ?? ''),
              color: Palette.lavender,
              size: large ? 26 : 22,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (topMatch)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _Badge(t.package.topMatch),
                ),
              Text(
                pkg.name.of(lang),
                style: TextStyle(
                  fontSize: large ? 20 : 16,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                  height: 1.3,
                ),
              ),
              if (category != null)
                Text(
                  t.categories[category!] ?? category!,
                  style: const TextStyle(fontSize: 12, color: Palette.inkMuted),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({required this.pkg, this.large = false});

  final PackageSummary pkg;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final p = pkg;
    final off = p.mrpInr > p.priceInr ? ((p.mrpInr - p.priceInr) * 100 / p.mrpInr).round() : 0;
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          formatRupees(p.priceInr),
          style: TextStyle(
            fontSize: large ? 26 : 22,
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
              context.t.package.off(n: off),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Palette.success,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.pkg});

  final PackageSummary pkg;

  @override
  Widget build(BuildContext context) {
    final t = context.t.package;
    final p = pkg;
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        _Fact(Icons.science_outlined, t.tests(n: p.testCount)),
        _Fact(Icons.schedule, t.report(h: p.reportTatHours)),
        _Fact(
          p.fastingHours > 0 ? Icons.no_food_outlined : Icons.restaurant_outlined,
          p.fastingHours > 0 ? t.fasting(h: p.fastingHours) : t.noFasting,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Palette.inkMuted,
        letterSpacing: 0.3,
      ),
    ),
  );
}

class _FactRow extends StatelessWidget {
  const _FactRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Palette.inkMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 15, color: Palette.ink, height: 1.4)),
        ),
      ],
    ),
  );
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

class _TestTag extends StatelessWidget {
  const _TestTag(this.name, {this.accent = false});

  final String name;
  final bool accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: accent ? Palette.lavenderSoft : Palette.paper,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: accent ? Palette.lavenderSoft : Palette.line),
    ),
    child: Text(
      name,
      style: TextStyle(
        fontSize: 12,
        color: accent ? Palette.lavender : Palette.ink,
        fontWeight: accent ? FontWeight.w600 : FontWeight.w400,
      ),
    ),
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
