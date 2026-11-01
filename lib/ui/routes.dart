import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/log_screen.dart';
import 'screens/model_screen.dart';
import 'screens/provider_screen.dart';
import 'screens/record_screen.dart';
import 'screens/template_screen.dart';
import 'screens/workspace_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<WorkspaceRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ModelRoute>(path: 'models'),
    TypedGoRoute<ProviderRoute>(path: 'provider'),
    TypedGoRoute<TemplateRoute>(path: 'templates'),
    TypedGoRoute<LogRoute>(path: 'diagnostics'),
    TypedGoRoute<RecordRoute>(path: 'record'),
  ],
)
class WorkspaceRoute extends GoRouteData with $WorkspaceRoute {
  const WorkspaceRoute({this.tab = 0});
  final int tab;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      WorkspaceScreen(tab: tab.clamp(0, 1));
}

class ModelRoute extends GoRouteData with $ModelRoute {
  const ModelRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ModelScreen();
}

class ProviderRoute extends GoRouteData with $ProviderRoute {
  const ProviderRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProviderScreen();
}

class TemplateRoute extends GoRouteData with $TemplateRoute {
  const TemplateRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TemplateScreen();
}

class LogRoute extends GoRouteData with $LogRoute {
  const LogRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const LogScreen();
}

class RecordRoute extends GoRouteData with $RecordRoute {
  const RecordRoute({this.id});
  final String? id;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RecordScreen(id: id);
}

GoRouter createRouter() => GoRouter(routes: $appRoutes);
