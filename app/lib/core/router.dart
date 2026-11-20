import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/bookings/bookings_screen.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/history/history.dart';
import 'app_shell.dart';

part 'router.g.dart';

@TypedShellRoute<AppShellRoute>(
  routes: [
    TypedGoRoute<ChatRoute>(path: '/'),
    TypedGoRoute<HistoryRoute>(path: '/history'),
    TypedGoRoute<BookingsRoute>(path: '/bookings'),
    TypedGoRoute<CatalogRoute>(path: '/packages'),
  ],
)
class AppShellRoute extends ShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) =>
      AppShell(location: state.uri.path, child: navigator);
}

class ChatRoute extends GoRouteData with $ChatRoute {
  const ChatRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: ChatScreen());
}

class HistoryRoute extends GoRouteData with $HistoryRoute {
  const HistoryRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: HistoryScreen());
}

class BookingsRoute extends GoRouteData with $BookingsRoute {
  const BookingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: BookingsScreen());
}

class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: CatalogScreen());
}

final router = GoRouter(routes: $appRoutes);
