import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database.dart';
import '../../core/di.dart';
import '../../core/router.dart';
import '../../i18n/strings.g.dart';
import '../chat/domain/models.dart';
import '../chat/presentation/cards.dart';
import '../chat/presentation/chat_cubit.dart';
import 'package.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    final all = getIt<Catalog>().packages;
    final categories = {for (final p in all) p.category}.toList();
    final shown = _category == null ? all : all.where((p) => p.category == _category).toList();
    final flagged = context.select((ChatCubit c) => c.state.flagged);
    String label(String c) => t.categories[c] ?? c;
    return Scaffold(
      appBar: AppBar(title: Text(t.catalog.title)),
      body: Column(
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
                      label: Text(c == null ? t.catalog.all : label(c)),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: shown.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final p = shown[i];
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: PackageCardView(
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
                                context.read<ChatCubit>().send(
                                  t.actions.bookPackage(name: p.name.of(lang)),
                                  lang,
                                  kind: MessageKind.action,
                                ),
                              );
                              const ChatRoute().go(context);
                            },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
