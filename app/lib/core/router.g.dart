// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$chatRoute];

RouteBase get $chatRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $ChatRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'bookings',
      hasOverriddenOnExit: false,
      factory: $BookingsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'packages',
      hasOverriddenOnExit: false,
      factory: $CatalogRoute._fromState,
    ),
  ],
);

mixin $ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) => const ChatRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BookingsRoute on GoRouteData {
  static BookingsRoute _fromState(GoRouterState state) => const BookingsRoute();

  @override
  String get location => GoRouteData.$location('/bookings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CatalogRoute on GoRouteData {
  static CatalogRoute _fromState(GoRouterState state) => const CatalogRoute();

  @override
  String get location => GoRouteData.$location('/packages');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
