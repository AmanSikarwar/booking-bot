import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' show ComposerHeightNotifier;
import 'package:material_ui/material_ui.dart';

import '../../../core/db/database.dart';
import '../../../core/di.dart';
import '../../../core/layout.dart';
import '../../../core/motion.dart';
import '../../../core/router.dart';
import '../../../core/theme.dart';
import '../../../i18n/strings.g.dart';
import '../../bookings/bookings_cubit.dart';
import '../../catalog/package.dart';
import '../../profile/profile.dart';
import '../../profile/profile_cubit.dart';
import '../../profile/profile_labels.dart';
import '../../profile/profile_screen.dart';
import '../domain/slots.dart';
import 'bubbles.dart';
import 'cards.dart';
import 'chat_cubit.dart';
import 'package_card.dart';
import 'suggestions.dart';

const _popular = ['pkg_full_body', 'pkg_diabetes_care', 'pkg_thyroid_profile', 'pkg_senior_care'];

class Welcome extends StatelessWidget {
  const Welcome({super.key, required this.onSend, required this.onBook, this.now});

  final void Function(String text) onSend;
  final void Function(String packageId, Localized name) onBook;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final w = t.welcome;
    final now = this.now ?? DateTime.now();
    final profile = context.watch<ProfileCubit>().state;
    final self = profile.self;
    final first = self.name.split(' ').first;
    final hour = now.hour;
    final greeting = hour < 12
        ? w.morning(name: first)
        : hour < 17
        ? w.afternoon(name: first)
        : w.evening(name: first);
    final flagged = context.select((ChatCubit c) => c.state.flagged);
    final byId = {for (final p in getIt<Catalog>().packages) p.id: p};
    final bottom = context.watch<ComposerHeightNotifier>().height;
    return BlocProvider(
      create: (_) => getIt<BookingsCubit>(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(16, 24, 16, bottom + 16),
        children: staggered(context, [
          _Hero(greeting: greeting, intro: w.intro),
          _NextCollection(today: bookableDates(now).first, profile: profile),
          _Section(
            title: w.bookFor,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in profile.people)
                  ActionChip(
                    avatar: ProfileAvatar(name: p.name, size: 24),
                    label: Text(personChip(t, p)),
                    onPressed: () => onSend(
                      p.relation == Relation.self
                          ? w.forSelf
                          : w.forPerson(
                              relation: relationLabel(t, p.relation).toLowerCase(),
                              name: p.name,
                            ),
                    ),
                  ),
              ],
            ),
          ),
          _Section(
            title: w.popular,
            action: TextButton(
              onPressed: () => const CatalogRoute().go(context),
              child: Text(w.seeAll),
            ),
            child: ResponsiveWrap(
              minItemWidth: 200,
              maxColumns: 2,
              spacing: 10,
              children: [
                for (final id in _popular)
                  if (byId[id] case final p?)
                    _PackageTile(
                      package: p,
                      onTap: () => showPackageDetails(
                        context,
                        pkg: summaryOf(p),
                        details: p,
                        onBook: flagged ? null : () => onBook(p.id, p.name),
                      ),
                    ),
              ],
            ),
          ),
          _Section(
            title: w.how,
            child: ResponsiveWrap(
              minItemWidth: 180,
              spacing: 10,
              children: [
                _Step(n: 1, text: w.step1),
                _Step(n: 2, text: w.step2),
                _Step(n: 3, text: w.step3),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.greeting, required this.intro});

  final String greeting;
  final String intro;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SaathiAvatar(size: 48),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(intro, style: const TextStyle(color: Palette.inkMuted, height: 1.45)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _NextCollection extends StatelessWidget {
  const _NextCollection({required this.today, required this.profile});

  final String today;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final next = context
        .watch<BookingsCubit>()
        .state
        ?.where((b) => b.status == 'confirmed' && b.slotDate.compareTo(today) >= 0)
        .firstOrNull;
    if (next == null) return const SizedBox.shrink();
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Material(
        color: Palette.teal,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => const BookingsRoute().go(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.event_available, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: _nextText(context, t, next, lang)),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nextText(BuildContext context, Translations t, Booking b, String lang) {
    const light = TextStyle(color: Color(0xCCFFFFFF), fontSize: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${t.welcome.nextCollection} · ${b.bookingRef}', style: light),
        Text(
          '${dateLabel(context, b.slotDate)} · ${windowLabel(context, b.timeWindow)}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        Text(
          '${lang == 'hi' ? b.packageNameHi : b.packageNameEn} · ${b.patientName} · ${b.addressLabel}',
          style: light,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Palette.inkMuted,
                  ),
                ),
              ),
              ?action,
            ],
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    ),
  );
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({required this.package, required this.onTap});

  final LabPackage package;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final lang = TranslationProvider.of(context).flutterLocale.languageCode;
    return Material(
      color: Palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Palette.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(color: Palette.tealSoft, shape: BoxShape.circle),
                child: Icon(categoryIcon(package.category), size: 20, color: Palette.teal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortName(package.name.of(lang)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.ink),
                    ),
                    Text(
                      '${formatRupees(package.priceInr)} · ${t.package.tests(n: package.testCount)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Palette.inkMuted,
                        fontFeatures: tabular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.text});

  final int n;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Palette.tealSoft.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: Palette.teal,
          child: Text(
            '$n',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13, color: Palette.ink, height: 1.3)),
        ),
      ],
    ),
  );
}
