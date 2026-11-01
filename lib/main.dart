import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers.dart';
import 'application/runtime.dart';
import 'l10n/localization.dart';
import 'ui/routes.dart';
import 'ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VoxBootstrap());
}

class VoxBootstrap extends StatefulWidget {
  const VoxBootstrap({super.key});
  @override
  State<VoxBootstrap> createState() => _VoxBootstrapState();
}

class _VoxBootstrapState extends State<VoxBootstrap> {
  late Future<AppRuntime> _future = AppRuntime.create();
  AppRuntime? _runtime;
  @override
  void dispose() {
    if (_runtime != null) unawaited(_runtime!.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<AppRuntime>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _runtime = snapshot.data;
        return ProviderScope(
          overrides: [runtimeProvider.overrideWithValue(snapshot.requireData)],
          child: const VoxApp(),
        );
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: VoxTheme.make(Brightness.light),
        darkTheme: VoxTheme.make(Brightness.dark),
        home: Builder(
          builder: (context) => Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: snapshot.hasError
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(context.l10n.message('storageUnavailable')),
                            SizedBox(height: 20),
                            FilledButton(
                              onPressed: () =>
                                  setState(() => _future = AppRuntime.create()),
                              child: Text(context.l10n.reopen),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.spa_outlined, size: 42),
                            SizedBox(height: 20),
                            Text('Vox Local'),
                            SizedBox(height: 24),
                            CircularProgressIndicator(),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class VoxApp extends ConsumerStatefulWidget {
  const VoxApp({super.key});
  @override
  ConsumerState<VoxApp> createState() => _VoxAppState();
}

class _VoxAppState extends ConsumerState<VoxApp> {
  final router = createRouter();
  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(settingsProvider.select((s) => s.uiLocale));
    return MaterialApp.router(
      locale: language == 'system' ? null : Locale(language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Vox Local',
      debugShowCheckedModeBanner: false,
      theme: VoxTheme.make(Brightness.light),
      darkTheme: VoxTheme.make(Brightness.dark),
      routerConfig: router,
    );
  }
}
