import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/bookings/bookings_screen.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/chat/presentation/chat_screen.dart';

part 'router.g.dart';

@TypedGoRoute<ChatRoute>(
  path: '/',
  routes: [
    TypedGoRoute<BookingsRoute>(path: 'bookings'),
    TypedGoRoute<CatalogRoute>(path: 'packages'),
  ],
)
class ChatRoute extends GoRouteData with $ChatRoute {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ChatScreen();
}

class BookingsRoute extends GoRouteData with $BookingsRoute {
  const BookingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BookingsScreen();
}

class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const CatalogScreen();
}

final router = GoRouter(routes: $appRoutes);
