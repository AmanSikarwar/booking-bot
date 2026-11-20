import 'package:material_ui/material_ui.dart';

import '../i18n/strings.g.dart';
import 'layout.dart';
import 'router.dart';
import 'theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static const _paths = ['/', '/history', '/bookings', '/packages', '/profile'];

  @override
  Widget build(BuildContext context) {
    final t = context.t.nav;
    final showNav =
        context.windowSize == WindowSize.compact && MediaQuery.viewInsetsOf(context).bottom == 0;
    final index = _paths.indexOf(location).clamp(0, _paths.length - 1);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: child,
      bottomNavigationBar: showNav
          ? NavigationBar(
              selectedIndex: index,
              backgroundColor: Palette.surface,
              indicatorColor: Palette.tealSoft,
              height: 64,
              onDestinationSelected: (i) => switch (i) {
                0 => const ChatRoute().go(context),
                1 => const HistoryRoute().go(context),
                2 => const BookingsRoute().go(context),
                3 => const CatalogRoute().go(context),
                _ => const ProfileRoute().go(context),
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.chat_bubble_outline),
                  selectedIcon: const Icon(Icons.chat_bubble, color: Palette.teal),
                  label: t.chat,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history),
                  selectedIcon: const Icon(Icons.history, color: Palette.teal),
                  label: t.history,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.event_note_outlined),
                  selectedIcon: const Icon(Icons.event_note, color: Palette.teal),
                  label: t.bookings,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.science_outlined),
                  selectedIcon: const Icon(Icons.science, color: Palette.teal),
                  label: t.packages,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person, color: Palette.teal),
                  label: t.profile,
                ),
              ],
            )
          : null,
    );
  }
}

Widget? backToChat(BuildContext context) => context.windowSize == WindowSize.compact
    ? null
    : IconButton(
        tooltip: context.t.nav.back,
        onPressed: () => const ChatRoute().go(context),
        icon: const Icon(Icons.arrow_back),
      );
