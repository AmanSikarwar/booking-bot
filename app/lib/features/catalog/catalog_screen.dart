import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/di.dart';
import '../../core/layout.dart';
import '../../core/router.dart';
import '../../i18n/strings.g.dart';
import '../chat/domain/models.dart';
import '../chat/presentation/cards.dart';
import '../chat/presentation/chat_cubit.dart';
import 'package.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.catalog.title)),
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

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final all = getIt<Catalog>().packages;
    final categories = {for (final p in all) p.category}.toList();
    final shown = _category == null ? all : all.where((p) => p.category == _category).toList();
    final flagged = context.select((ChatCubit c) => c.state.flagged);
    return Column(
      children: [
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
                    label: Text(c == null ? t.catalog.all : (t.categories[c] ?? c)),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.maxWidth),
                child: ResponsiveWrap(
                  minItemWidth: 320,
                  children: [
                    for (final p in shown)
                      PackageCardView(
                        allTests: p.tests,
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
                      ),
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
