// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$workspaceRoute];

RouteBase get $workspaceRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $WorkspaceRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'models',
      hasOverriddenOnExit: false,
      factory: $ModelRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'provider',
      hasOverriddenOnExit: false,
      factory: $ProviderRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'templates',
      hasOverriddenOnExit: false,
      factory: $TemplateRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'diagnostics',
      hasOverriddenOnExit: false,
      factory: $LogRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'record',
      hasOverriddenOnExit: false,
      factory: $RecordRoute._fromState,
    ),
  ],
);

mixin $WorkspaceRoute on GoRouteData {
  static WorkspaceRoute _fromState(GoRouterState state) => WorkspaceRoute(
    tab: _$convertMapValue('tab', state.uri.queryParameters, int.parse) ?? 0,
  );

  WorkspaceRoute get _self => this as WorkspaceRoute;

  @override
  String get location => GoRouteData.$location(
    '/',
    queryParams: {if (_self.tab != 0) 'tab': _self.tab.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ModelRoute on GoRouteData {
  static ModelRoute _fromState(GoRouterState state) => const ModelRoute();

  @override
  String get location => GoRouteData.$location('/models');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProviderRoute on GoRouteData {
  static ProviderRoute _fromState(GoRouterState state) => const ProviderRoute();

  @override
  String get location => GoRouteData.$location('/provider');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TemplateRoute on GoRouteData {
  static TemplateRoute _fromState(GoRouterState state) => const TemplateRoute();

  @override
  String get location => GoRouteData.$location('/templates');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LogRoute on GoRouteData {
  static LogRoute _fromState(GoRouterState state) => const LogRoute();

  @override
  String get location => GoRouteData.$location('/diagnostics');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RecordRoute on GoRouteData {
  static RecordRoute _fromState(GoRouterState state) =>
      RecordRoute(id: state.uri.queryParameters['id']);

  RecordRoute get _self => this as RecordRoute;

  @override
  String get location => GoRouteData.$location(
    '/record',
    queryParams: {if (_self.id != null) 'id': _self.id},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}
