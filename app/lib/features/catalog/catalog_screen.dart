import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_shell.dart';

import '../../core/di.dart';
import '../../core/layout.dart';
import '../../core/motion.dart';
import '../../core/router.dart';
import '../../i18n/strings.g.dart';
import '../chat/domain/models.dart';
import '../../core/theme.dart';
import '../chat/presentation/package_card.dart';
import '../chat/presentation/chat_cubit.dart';
import 'package.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: backToChat(context),
        title: Text(context.t.catalog.title),
      ),
      body: CatalogList(maxWidth: 1100, onBooked: () => const ChatRoute().go(context)),
    );
  }
}

class CatalogList extends StatefulWidget {
  const CatalogList({super.key, this.maxWidth = double.infinity, this.onBooked});

  final double maxWidth;
  final VoidCallback? onBooked;

  @override
  State<CatalogList> createState() => _CatalogListState();
}

class _CatalogListState extends State<CatalogList> {
  String? _category;
  String _query = '';

  bool _matches(LabPackage p) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return [
      p.name.en,
      p.name.hi,
      p.description.en,
      p.description.hi,
      ...p.tests,
    ].any((s) => s.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final all = getIt<Catalog>().packages;
    final categories = {for (final p in all) p.category}.toList();
    final shown = all
        .where((p) => (_category == null || p.category == _category) && _matches(p))
        .toList();
    final flagged = context.select((ChatCubit c) => c.state.flagged);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.maxWidth),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: t.catalog.search,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  filled: true,
                  fillColor: Palette.surface,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              for (final c in [null, ...categories])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    avatar: c == null ? null : Icon(categoryIcon(c), size: 16),
                    label: Text(c == null ? t.catalog.all : (t.categories[c] ?? c)),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
                ),
            ],
          ),
        ),
        if (shown.isEmpty)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  t.catalog.noResults(q: _query.trim()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Palette.inkMuted, height: 1.4),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widget.maxWidth),
                  child: ResponsiveWrap(
                    key: ValueKey('$_category|$_query'),
                    minItemWidth: 320,
                    children: [
                      for (final (i, p) in shown.indexed)
                        PackageCardView(
                          details: p,
                          pkg: PackageSummary(
                            id: p.id,
                            name: p.name,
                            priceInr: p.priceInr,
                            mrpInr: p.mrpInr,
                            testCount: p.testCount,
                            topTests: p.tests.take(4).toList(),
                            fastingHours: p.fastingHours,
                            reportTatHours: p.reportTatHours,
                            matchReason: p.description,
                          ),
                          onBook: flagged
                              ? null
                              : () {
                                  unawaited(
                                    context.read<ChatCubit>().openBookingForm(
                                      BookingFormData(
                                        packageId: p.id,
                                        packageName: p.name,
                                        fastingHours: p.fastingHours,
                                      ),
                                      lang,
                                    ),
                                  );
                                  widget.onBooked?.call();
                                },
                        ).enter(context, delay: Motion.stagger * min(i, 8)),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
