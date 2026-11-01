import 'dart:async';

import 'package:path_provider/path_provider.dart';

import '../domain/analysis.dart';
import '../domain/ports.dart';
import '../domain/speech.dart';
import '../infrastructure/chat_provider.dart';
import '../infrastructure/credentials.dart';
import '../infrastructure/local_store.dart';
import '../infrastructure/native_speech.dart';
import 'analysis_service.dart';
import 'model_service.dart';
import 'network_service.dart';
import 'recording_library.dart';
import 'session_service.dart';
import 'settings_service.dart';

class AppRuntime {
  AppRuntime({
    required this.store,
    required this.credentials,
    required this.engine,
    required this.clock,
    required this.settings,
    required this.models,
    required this.session,
    required this.analysis,
    this.network,
  });
  final LocalStore store;
  final CredentialStore credentials;
  final SpeechEngine engine;
  final Clock clock;
  final SettingsService settings;
  final ModelService models;
  final SessionService session;
  final AnalysisService analysis;
  final NetworkService? network;
  RecordingLibrary? _library;
  RecordingLibrary get library => _library ??= RecordingLibrary(store);
  static Future<AppRuntime> create() async {
    final directory = await getApplicationSupportDirectory();
    final store = await SqliteLocalStore.open('${directory.path}/vox.sqlite');
    const credentials = SecureCredentials();
    final engine = NativeSpeechEngine();
    final network = NetworkService(engine);
    final clock = SystemClock();
    final random = SystemRandom();
    final settings = SettingsService(store, credentials);
    final session = SessionService(engine, store, clock, random);
    final models = ModelService(engine, store, clock);
    final analysis = AnalysisService(
      store: store,
      settings: settings,
      session: session,
      planner: AnalysisPlanner(store, clock),
      worker: AnalysisWorker(
        store: store,
        credentials: credentials,
        provider: ChatCompletionProvider(
          diagnostics: store.appendLog,
          clock: clock,
        ),
        clock: clock,
        random: random,
        connectivity: network,
      ),
      clock: clock,
      connectivityChanges: network.changes,
    );
    try {
      await settings.restore();
      await session.restore();
      await models.refresh();
      await analysis.initialize();
    } catch (_) {
      await analysis.close();
      await session.close();
      await models.close();
      await engine.dispose();
      await store.close();
      rethrow;
    }
    final runtime = AppRuntime(
      store: store,
      credentials: credentials,
      engine: engine,
      clock: clock,
      settings: settings,
      models: models,
      session: session,
      analysis: analysis,
      network: network,
    );
    final selected = models.value.where(
      (m) => m.id == settings.value.model && m.installed,
    );
    if (selected.isNotEmpty) {
      unawaited(
        models
            .prepare(settings.value.model, sessionActive: false)
            .catchError((Object _) {}),
      );
    }
    return runtime;
  }

  Future<void> dispose() async {
    await _library?.close();
    await analysis.close();
    if (session.value.active) await session.stop();
    await session.close();
    await models.close();
    await settings.close();
    await network?.close();
    await engine.dispose();
    await store.close();
  }
}
