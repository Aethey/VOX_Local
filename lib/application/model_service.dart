import 'dart:async';

import '../domain/models.dart';
import '../domain/ports.dart';
import '../domain/speech.dart';
import 'observable.dart';

class ModelService extends ObservableState<List<OfflineModelState>> {
  ModelService(this.engine, this.store, this.clock)
    : super(const [OfflineModelState('turbo'), OfflineModelState('small')]) {
    _subscription = engine.events
        .where((e) => e.kind == 'model')
        .listen(
          (e) => _set(
            OfflineModelState(
              e.modelId!,
              phase: e.phase!,
              progress: e.progress ?? 0,
            ),
          ),
        );
  }
  final SpeechEngine engine;
  final LocalStore store;
  final Clock clock;
  late final StreamSubscription<SpeechEvent> _subscription;
  bool _busy = false;
  String? readyId;
  void _set(OfflineModelState model) =>
      emit(List.unmodifiable(value.map((m) => m.id == model.id ? model : m)));
  Future<void> refresh() async {
    try {
      emit(List.unmodifiable(await engine.models()));
    } catch (_) {
      for (final m in value.toList()) {
        _set(OfflineModelState(m.id, error: 'engineUnavailable'));
      }
    }
  }

  Future<void> prepare(String id, {required bool sessionActive}) async {
    if (_busy || sessionActive) throw StateError('finishBeforeModelChange');
    _busy = true;
    try {
      final model = value.firstWhere((m) => m.id == id);
      if (!model.installed) {
        _set(OfflineModelState(id, phase: 'downloading'));
        await engine.download(id);
      }
      for (final m in value.toList()) {
        if (m.phase == 'ready') {
          _set(OfflineModelState(m.id, phase: 'installed'));
        }
      }
      readyId = null;
      _set(OfflineModelState(id, phase: 'preparing'));
      await engine.load(id);
      readyId = id;
      _set(OfflineModelState(id, phase: 'ready', progress: 1));
    } catch (_) {
      final current = value.firstWhere((m) => m.id == id);
      _set(
        OfflineModelState(
          id,
          phase: current.installed ? 'installed' : 'missing',
          error: current.installed ? 'modelLoadFailed' : 'modelPrepareFailed',
        ),
      );
      try {
        await store.appendLog(
          DiagnosticEntry(
            time: clock.now(),
            event: 'model_prepare_failed',
            kind: 'speech',
          ),
        );
      } catch (_) {}
      rethrow;
    } finally {
      _busy = false;
    }
  }

  Future<void> deleteModel(String id, {required bool sessionActive}) async {
    if (_busy || sessionActive) throw StateError('finishRecordingFirst');
    final previous = value.firstWhere((model) => model.id == id);
    _busy = true;
    if (readyId == id) readyId = null;
    _set(OfflineModelState(id, phase: 'deleting'));
    try {
      await engine.delete(id);
      _set(OfflineModelState(id));
    } catch (_) {
      _set(
        OfflineModelState(
          id,
          phase: previous.installed ? 'installed' : 'missing',
          error: 'modelDeleteFailed',
        ),
      );
      try {
        await store.appendLog(
          DiagnosticEntry(
            time: clock.now(),
            event: 'model_delete_failed',
            kind: 'storage',
          ),
        );
      } catch (_) {}
      rethrow;
    } finally {
      _busy = false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
