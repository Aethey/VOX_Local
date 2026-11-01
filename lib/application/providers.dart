import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models.dart';
import '../domain/speech.dart';
import 'analysis_service.dart';
import 'recording_library.dart';
import 'runtime.dart';
import 'session_service.dart';
import 'settings_service.dart';

final runtimeProvider = Provider<AppRuntime>(
  (ref) => throw StateError('Runtime must be injected at app bootstrap'),
);
final settingsProvider = NotifierProvider<SettingsController, SettingsState>(
  SettingsController.new,
);

class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final service = ref.watch(runtimeProvider).settings;
    final sub = service.changes.listen((next) => state = next);
    ref.onDispose(sub.cancel);
    return service.value;
  }

  Future<void> update(SettingsState next) =>
      ref.read(runtimeProvider).settings.update(next);
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);

class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() {
    final service = ref.watch(runtimeProvider).session;
    final sub = service.changes.listen((next) => state = next);
    ref.onDispose(sub.cancel);
    return service.value;
  }

  Future<void> start({bool dictation = false}) async {
    final runtime = ref.read(runtimeProvider);
    await runtime.session.start(
      ready: runtime.models.readyId == runtime.settings.value.model,
      language: runtime.settings.value.language,
      model: runtime.settings.value.model,
      analysisProfile: runtime.settings.value.analysisEnabled
          ? runtime.settings.value.profile
          : null,
      analysisTemplate: runtime.settings.value.analysisEnabled
          ? runtime.settings.value.template
          : null,
      dictation: dictation,
    );
  }

  Future<void> stop() async {
    final runtime = ref.read(runtimeProvider);
    await runtime.session.stop();
    unawaited(runtime.analysis.tick(force: true));
  }

  Future<void> newRecording() =>
      ref.read(runtimeProvider).session.newRecording();
  Future<void> open(String id) async {
    final runtime = ref.read(runtimeProvider);
    await runtime.session.open(id);
    await runtime.analysis.refresh();
  }

  Future<void> resume(String id) async {
    final runtime = ref.read(runtimeProvider);
    await runtime.session.resume(
      id: id,
      ready: runtime.models.readyId == runtime.settings.value.model,
      language: runtime.settings.value.language,
      model: runtime.settings.value.model,
    );
    await runtime.analysis.refresh();
  }

  Future<void> rename(String id, String title) =>
      ref.read(runtimeProvider).session.rename(id, title);
  Future<void> delete(String id) =>
      ref.read(runtimeProvider).analysis.removeRecording(id);
  Future<String> transcript(String id) =>
      ref.read(runtimeProvider).session.transcript(id);
}

final recordingLibraryProvider =
    NotifierProvider<RecordingLibraryController, RecordingLibraryState>(
      RecordingLibraryController.new,
    );

class RecordingLibraryController extends Notifier<RecordingLibraryState> {
  @override
  RecordingLibraryState build() {
    final library = ref.watch(runtimeProvider).library;
    final subscription = library.changes.listen((next) => state = next);
    ref.onDispose(subscription.cancel);
    return library.value;
  }

  Future<void> refresh({String? query}) =>
      ref.read(runtimeProvider).library.refresh(query: query);
  Future<void> loadMore() => ref.read(runtimeProvider).library.loadMore();
}

final modelProvider =
    NotifierProvider<ModelController, List<OfflineModelState>>(
      ModelController.new,
    );

class ModelController extends Notifier<List<OfflineModelState>> {
  @override
  List<OfflineModelState> build() {
    final service = ref.watch(runtimeProvider).models;
    final sub = service.changes.listen((next) => state = next);
    ref.onDispose(sub.cancel);
    return service.value;
  }

  Future<void> prepare(String id) async {
    final r = ref.read(runtimeProvider);
    await r.models.prepare(id, sessionActive: r.session.value.active);
    await r.settings.update(r.settings.value.copy(model: id));
  }

  Future<void> delete(String id) {
    final r = ref.read(runtimeProvider);
    return r.models.deleteModel(id, sessionActive: r.session.value.active);
  }
}

final analysisProvider =
    NotifierProvider<AnalysisController, List<AnalysisJob>>(
      AnalysisController.new,
    );

class AnalysisController extends Notifier<List<AnalysisJob>> {
  @override
  List<AnalysisJob> build() {
    final AnalysisService service = ref.watch(runtimeProvider).analysis;
    final sub = service.changes.listen((next) => state = next);
    ref.onDispose(sub.cancel);
    return service.value;
  }

  Future<void> retry() => ref.read(runtimeProvider).analysis.retry();
  Future<void> analyzeWhole() =>
      ref.read(runtimeProvider).analysis.analyzeWhole();
  Future<void> configure(bool enabled, {bool useCurrentSettings = false}) => ref
      .read(runtimeProvider)
      .analysis
      .configureCurrent(enabled, useCurrentSettings: useCurrentSettings);
}

final levelProvider = StreamProvider<double>(
  (ref) => ref.watch(runtimeProvider).session.level.changes,
);
final logsProvider = FutureProvider<List<DiagnosticEntry>>(
  (ref) => ref.watch(runtimeProvider).store.logs(),
  retry: (_, _) => null,
);

final analysisWarningProvider = StreamProvider<String?>(
  (ref) => ref.watch(runtimeProvider).analysis.warning.changes,
);
