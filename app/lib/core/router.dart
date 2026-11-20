import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/bookings/bookings_screen.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/history/history.dart';
import 'app_shell.dart';
import 'motion.dart';

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
      _fade(context, state, const ChatScreen());
}

class HistoryRoute extends GoRouteData with $HistoryRoute {
  const HistoryRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fade(context, state, const HistoryScreen());
}

class BookingsRoute extends GoRouteData with $BookingsRoute {
  const BookingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fade(context, state, const BookingsScreen());
}

class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fade(context, state, const CatalogScreen());
}

Page<void> _fade(BuildContext context, GoRouterState state, Widget child) => Motion.on(context)
    ? CustomTransitionPage<void>(
        key: state.pageKey,
        child: child,
        transitionDuration: Motion.fast,
        reverseTransitionDuration: Motion.fast,
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurveTween(curve: Motion.curve).animate(animation),
          child: child,
        ),
      )
    : NoTransitionPage<void>(key: state.pageKey, child: child);

final router = GoRouter(routes: $appRoutes);
