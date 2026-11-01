import 'dart:async';

import '../domain/analysis.dart';
import '../domain/failure.dart';
import '../domain/models.dart';
import '../domain/ports.dart';
import 'observable.dart';
import 'session_service.dart';
import 'settings_service.dart';

class AnalysisService extends ObservableState<List<AnalysisJob>> {
  AnalysisService({
    required this.store,
    required this.settings,
    required this.session,
    required this.planner,
    required this.worker,
    required this.clock,
    this.connectivityChanges,
  }) : super(const []);
  final LocalStore store;
  final SettingsService settings;
  final SessionService session;
  final AnalysisPlanner planner;
  final AnalysisWorker worker;
  final Clock clock;
  final warning = ObservableState<String?>(null);
  final Stream<bool>? connectivityChanges;
  StreamSubscription<bool>? _networkChanges;
  StreamSubscription<void>? _changes;
  StreamSubscription<SessionState>? _sessionChanges;
  Timer? _timer;
  final _lastPlan = <String, DateTime>{};
  // Records whose last plan failed deterministically (rules or budget).
  // They are re-checked once per interval instead of on every tick.
  final _unplannable = <String>{};
  final _removing = <String>{};
  bool _ticking = false, _closed = false;
  int _refreshGeneration = 0;

  Future<void> initialize({bool runTimer = true}) async {
    _networkChanges = connectivityChanges?.listen((online) {
      if (online) {
        unawaited(tick(force: true));
      } else {
        worker.pause();
      }
    });
    await store.recover();
    await refresh();
    _changes = store.jobChanges.listen((_) => unawaited(refresh()));
    String? selected = session.value.id;
    _sessionChanges = session.changes.listen((next) {
      if (next.id != selected) {
        selected = next.id;
        unawaited(refresh());
      }
    });
    if (runTimer) {
      _timer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => unawaited(tick()),
      );
    }
  }

  Future<void> refresh() async {
    final generation = ++_refreshGeneration;
    final id = session.value.id;
    try {
      final list = id == null
          ? <AnalysisJob>[]
          : await store.jobs(limit: 100, sessionId: id);
      if (!_closed &&
          generation == _refreshGeneration &&
          session.value.id == id) {
        emit(List.unmodifiable(list));
      }
    } catch (_) {
      /* Keep the last displayed results while storage is unavailable. */
    }
  }

  Future<void> tick({bool force = false}) async {
    if (_ticking || _closed) return;
    _ticking = true;
    worker.resume();
    String? problem;
    try {
      // Scheduling is durable per recording, independent of the selected page.
      for (final record in await store.analysisTargets()) {
        if (_removing.contains(record.id) || record.analysisScope == null) {
          continue;
        }
        final key = '${record.id}:${record.analysisScope}';
        final last = _lastPlan[key];
        final throttled =
            record.status == RecordingStatus.recording ||
            _unplannable.contains(key);
        if (!force &&
            throttled &&
            last != null &&
            clock.now().difference(last).inSeconds < settings.value.interval) {
          continue;
        }
        try {
          await planner.plan(
            record.id,
            record.analysisProfile!,
            record.analysisTemplate!,
            language: settings.value.analysisLanguage,
          );
          _unplannable.remove(key);
        } on FormatException catch (error) {
          // A deterministic problem in one record must not stall the others.
          _unplannable.add(key);
          problem ??= error.message;
        }
        _lastPlan[key] = clock.now();
      }
      if (_lastPlan.length > 200) {
        _lastPlan.removeWhere(
          (key, date) => clock.now().difference(date).inDays > 1,
        );
        _unplannable.retainAll(_lastPlan.keys);
      }
    } catch (error) {
      problem = switch (error) {
        AppFailure() => error.message,
        FormatException() => error.message,
        _ => 'schedulingFailed',
      };
    } finally {
      await _warn(problem);
      _ticking = false;
      // Job transitions are published through store.jobChanges; only the
      // planning pass needs an explicit refresh here.
      if (!_closed) unawaited(worker.tick());
      await refresh();
    }
  }

  Future<void> _warn(String? message) async {
    if (warning.value == message) return;
    warning.emit(message);
    if (message == null) return;
    try {
      await store.appendLog(
        DiagnosticEntry(
          time: clock.now(),
          event: 'analysis_schedule_failed',
          kind: 'storage_or_configuration',
        ),
      );
    } catch (_) {}
  }

  Future<void> configureCurrent(
    bool enabled, {
    bool useCurrentSettings = false,
  }) async {
    final record = session.value.record;
    if (record == null) throw const FormatException('chooseRecordingFirst');
    final profile = useCurrentSettings || record.analysisProfile == null
        ? settings.value.profile
        : record.analysisProfile;
    final template = useCurrentSettings || record.analysisTemplate == null
        ? settings.value.template
        : record.analysisTemplate;
    if (worker.activeSessionId == record.id) worker.pause();
    try {
      await session.configureAnalysis(
        enabled: enabled,
        profile: profile,
        template: template,
      );
      // This is the default for future recordings, not a global stop for other records.
      await settings.update(settings.value.copy(analysisEnabled: enabled));
      _lastPlan.removeWhere((key, _) => key.startsWith('${record.id}:'));
      _unplannable.removeWhere((key) => key.startsWith('${record.id}:'));
    } finally {
      worker.resume();
    }
    await tick(force: true);
  }

  /// Sends the whole transcript of the open, finished recording in a single
  /// request. Uses the scope the analysis page shows: the record's own
  /// profile/template, else the current settings. Analysis is switched on
  /// for the record because the worker only claims jobs of enabled records.
  Future<void> analyzeWhole() async {
    final record = session.value.record;
    if (record == null) throw const FormatException('chooseRecordingFirst');
    if (record.status == RecordingStatus.recording) {
      throw const FormatException('finishRecordingFirst');
    }
    final profile = record.analysisProfile ?? settings.value.profile;
    final template = record.analysisTemplate ?? settings.value.template;
    if (profile == null) throw const FormatException('enterApiKey');
    final scope = '${profile.id}:${template.id}:${template.version}';
    if (!record.analysisEnabled || record.analysisScope != scope) {
      if (worker.activeSessionId == record.id) worker.pause();
      try {
        await session.configureAnalysis(
          enabled: true,
          profile: profile,
          template: template,
        );
      } finally {
        worker.resume();
      }
    }
    await planner.planWhole(
      record.id,
      profile,
      template,
      language: settings.value.analysisLanguage,
    );
    _lastPlan.removeWhere((key, _) => key.startsWith('${record.id}:'));
    _unplannable.removeWhere((key) => key.startsWith('${record.id}:'));
    await tick(force: true);
  }

  Future<void> removeRecording(String id) async {
    if (!_removing.add(id)) return;
    if (worker.activeSessionId == null || worker.activeSessionId == id) {
      worker.pause();
    }
    try {
      await session.delete(id);
      await refresh();
    } finally {
      _removing.remove(id);
      worker.resume();
    }
  }

  Future<void> retry() async {
    final record = session.value.record;
    final profile = record?.analysisProfile;
    if (record == null || profile == null) return;
    await store.retryFailed(profile.id, clock.now(), sessionId: record.id);
    await tick(force: true);
  }

  @override
  Future<void> close() async {
    _closed = true;
    _refreshGeneration++;
    _timer?.cancel();
    worker.pause();
    await _changes?.cancel();
    await _sessionChanges?.cancel();
    await _networkChanges?.cancel();
    await warning.close();
    await super.close();
  }
}
