import 'dart:async';
import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/models.dart';
import '../domain/ports.dart';
import '../domain/speech.dart';
import '../domain/transcript_text.dart';
import '../domain/transcript_timeline.dart';
import 'observable.dart';

part 'session_service.freezed.dart';

@freezed
abstract class SessionState with _$SessionState {
  const SessionState._();
  const factory SessionState({
    String? id,
    RecordingSummary? record,
    @Default(SessionPhase.idle) SessionPhase phase,
    @Default([]) List<TranscriptSegment> segments,
    @Default('') String partial,
    String? error,
    @Default(false) bool dictating,
    @Default('') String draft,
    DateTime? startedAt,
    @Default(false) bool managing,
  }) = _SessionState;

  // Interrupted capture still owns native resources until stop succeeds.
  bool get active => {
    SessionPhase.preparing,
    SessionPhase.recording,
    SessionPhase.finalizing,
    SessionPhase.interrupted,
  }.contains(phase);
  SessionState copy({
    String? id,
    SessionPhase? phase,
    List<TranscriptSegment>? segments,
    String? partial,
    String? error,
    bool? dictating,
    String? draft,
  }) => copyWith(
    id: id ?? this.id,
    phase: phase ?? this.phase,
    segments: segments ?? this.segments,
    partial: partial ?? this.partial,
    error: error,
    dictating: dictating ?? this.dictating,
    draft: draft ?? this.draft,
  );
}

class SessionService extends ObservableState<SessionState> {
  SessionService(this.engine, this.store, this.clock, this.random)
    : super(const SessionState()) {
    _events = engine.events.listen(_onEvent);
  }
  final SpeechEngine engine;
  final LocalStore store;
  final Clock clock;
  final RandomSource random;
  final level = ObservableState<double>(0);
  late final StreamSubscription<SpeechEvent> _events;
  Future<void>? _writes;
  String? _nativeId;
  SessionState? _dictationBase;
  int _serial = 0;
  int _revision = 0;
  // Seconds already captured before the current run of a resumed record.
  double _durationBase = 0;
  final _captureTranscript = <TranscriptSegment>[];

  String _newId() =>
      '${clock.now().microsecondsSinceEpoch}-${(random.nextDouble() * 0x7fffffff).floor()}-${++_serial}';
  void _requireFree() {
    if (value.active) throw StateError('finishRecordingFirst');
    if (value.managing) throw StateError('recordingOperationBusy');
  }

  Future<void> restore() async {
    final id = await store.setting('currentSession');
    if (id == null || id.isEmpty) return;
    var record = await store.recording(id);
    if (record == null) {
      record = RecordingSummary(
        id: id,
        createdAt: clock.now(),
        updatedAt: clock.now(),
        status: RecordingStatus.interrupted,
      );
      await store.saveRecording(record);
    }
    try {
      await _replayJournal(id);
    } catch (_) {
      /* Canonical local records remain readable without the engine. */
    }
    final segments = await store.segments(id);
    final latest = await store.recording(id) ?? record;
    await store.saveRecording(
      latest.copyWith(
        status: latest.status == RecordingStatus.recording
            ? RecordingStatus.interrupted
            : latest.status,
        segmentCount: segments.length,
        duration: segments.isEmpty
            ? latest.duration
            : math.max(latest.duration, segments.last.end),
      ),
    );
    // Recovery does not choose a record or start the microphone. Home owns history.
    emit(const SessionState());
  }

  /// Copies journal segments the canonical store is still missing.
  Future<void> _replayJournal(String id) async {
    var last = TranscriptTimeline.contiguousSequence(await store.segments(id));
    while (true) {
      final recovered = await engine.replay(id, last);
      if (recovered.isEmpty) break;
      for (final segment in recovered) {
        await store.appendSegment(TranscriptText.segment(segment));
      }
      final next = recovered.last.sequence;
      if (next <= last) break;
      last = next;
    }
  }

  Future<void> newRecording() async {
    _requireFree();
    await _writes;
    _writes = null;
    emit(const SessionState());
  }

  Future<void> open(String id) async {
    if (value.id == id && !value.dictating) return;
    _requireFree();
    emit(value.copyWith(managing: true, error: null));
    try {
      await _writes;
      final record = await store.recording(id);
      if (record == null) throw const FormatException('recordingNotFound');
      final segments = await store.segments(id);
      emit(
        SessionState(
          id: id,
          record: record,
          phase: SessionPhase.completed,
          segments: List.unmodifiable(segments),
        ),
      );
    } finally {
      if (value.managing) emit(value.copyWith(managing: false));
    }
  }

  Future<void> rename(String id, String title) async {
    if (value.managing) throw StateError('recordingOperationBusy');
    final name = title.trim();
    if (name.isEmpty || name.length > 80) {
      throw const FormatException('invalidRecordingTitle');
    }
    final record = await store.recording(id);
    if (record == null) throw const FormatException('recordingNotFound');
    final renamed = record.copyWith(title: name, updatedAt: clock.now());
    await store.saveRecording(renamed);
    if (value.id == id) {
      emit(value.copyWith(record: await store.recording(id) ?? renamed));
    }
  }

  Future<String> transcript(String id) async =>
      (await store.segments(id)).map((segment) => segment.text).join('\n\n');

  Future<void> delete(String id) async {
    _requireFree();
    emit(value.copyWith(managing: true, error: null));
    try {
      await _writes;
      await engine.deleteSession(id);
      await store.deleteRecording(id);
      if (value.id == id) emit(const SessionState());
    } finally {
      if (value.managing) emit(value.copyWith(managing: false));
    }
  }

  Future<void> configureAnalysis({
    required bool enabled,
    ProviderProfile? profile,
    AnalysisTemplate? template,
  }) async {
    final id = value.id;
    if (id == null || value.dictating || value.managing) {
      throw const FormatException('chooseRecordingFirst');
    }
    if (enabled && (profile == null || template == null)) {
      throw const FormatException('enterApiKey');
    }
    final record = await store.recording(id);
    if (record == null) throw const FormatException('recordingNotFound');
    final next = record.copyWith(
      analysisEnabled: enabled,
      analysisProfile: profile ?? record.analysisProfile,
      analysisTemplate: template ?? record.analysisTemplate,
    );
    await store.saveRecording(next);
    if (value.id == id) emit(value.copyWith(record: next));
  }

  Future<void> start({
    required bool ready,
    required String language,
    String model = 'turbo',
    bool dictation = false,
    ProviderProfile? analysisProfile,
    AnalysisTemplate? analysisTemplate,
  }) async {
    if (value.active || value.managing) return;
    if (!ready) {
      emit(value.copy(error: 'downloadModelFirst'));
      return;
    }
    if (!dictation && value.id != null) {
      throw StateError('createNewRecordingFirst');
    }
    final previous = value;
    final id = _newId();
    _nativeId = id;
    _revision = 0;
    _durationBase = 0;
    _captureTranscript.clear();
    _dictationBase = dictation ? previous : null;
    final record = RecordingSummary(
      id: id,
      createdAt: clock.now(),
      updatedAt: clock.now(),
      status: RecordingStatus.recording,
      language: language,
      model: model,
      analysisEnabled: analysisProfile != null && analysisTemplate != null,
      analysisProfile: analysisProfile,
      analysisTemplate: analysisTemplate,
    );
    emit(
      dictation
          ? previous.copy(
              phase: SessionPhase.preparing,
              dictating: true,
              draft: '',
              partial: '',
            )
          : SessionState(id: id, record: record, phase: SessionPhase.preparing),
    );
    try {
      if (!dictation) {
        await store.saveRecording(record);
      }
      await engine.start(id, language);
      emit(
        value.copyWith(phase: SessionPhase.recording, startedAt: clock.now()),
      );
    } catch (_) {
      var stopped = false;
      try {
        await engine.stop();
        stopped = true;
      } catch (_) {}
      await _writes;
      if (!stopped) {
        emit(
          value.copy(
            phase: SessionPhase.interrupted,
            error: 'speechStopFailed',
          ),
        );
        await _log('speech_start_cleanup_failed');
        return;
      }
      if (!dictation) {
        try {
          final captured = await store.segments(id);
          if (captured.isEmpty) {
            await engine.deleteSession(id);
            await store.deleteRecording(id);
          } else {
            await store.saveRecording(
              record.copyWith(status: RecordingStatus.interrupted),
            );
          }
        } catch (_) {
          /* Retain recoverable native data if storage is unavailable. */
        }
      } else {
        try {
          await engine.deleteSession(id);
        } catch (_) {
          await _log('dictation_cleanup_failed');
        }
      }
      _nativeId = null;
      _dictationBase = null;
      emit(previous.copy(error: 'speechStartFailed', dictating: false));
      await _log('speech_start_failed');
    }
  }

  /// Continues capturing into a finished or interrupted record. The engine
  /// is told where numbering and time resume so new segments follow the
  /// stored timeline; the record keeps its analysis configuration.
  Future<void> resume({
    required String id,
    required bool ready,
    required String language,
    String model = 'turbo',
  }) async {
    _requireFree();
    if (!ready) throw StateError('downloadModelFirst');
    emit(value.copyWith(managing: true, error: null));
    final RecordingSummary stored;
    final List<TranscriptSegment> segments;
    try {
      await _writes;
      _writes = null;
      final found = await store.recording(id);
      if (found == null) throw const FormatException('recordingNotFound');
      stored = found;
      try {
        await _replayJournal(id);
      } catch (_) {
        await _log('transcript_replay_failed');
      }
      segments = await store.segments(id);
    } finally {
      if (value.managing) emit(value.copyWith(managing: false));
    }
    final previous = value;
    final last = segments.lastOrNull;
    _nativeId = id;
    _revision = 0;
    _durationBase = stored.duration;
    _captureTranscript
      ..clear()
      ..addAll(segments);
    _dictationBase = null;
    final record = stored.copyWith(
      status: RecordingStatus.recording,
      language: language,
      model: model,
      updatedAt: clock.now(),
    );
    emit(
      SessionState(
        id: id,
        record: record,
        phase: SessionPhase.preparing,
        segments: List.unmodifiable(segments),
      ),
    );
    try {
      await store.saveRecording(record);
      await engine.start(
        id,
        language,
        afterSequence: last?.sequence ?? 0,
        offset: last?.end ?? 0,
      );
      emit(
        value.copyWith(phase: SessionPhase.recording, startedAt: clock.now()),
      );
    } catch (_) {
      var stopped = false;
      try {
        await engine.stop();
        stopped = true;
      } catch (_) {}
      await _writes;
      if (!stopped) {
        emit(
          value.copy(
            phase: SessionPhase.interrupted,
            error: 'speechStopFailed',
          ),
        );
        await _log('speech_start_cleanup_failed');
        return;
      }
      try {
        await store.saveRecording(record.copyWith(status: stored.status));
      } catch (_) {
        /* The record stays marked recording; restore() downgrades it. */
      }
      _nativeId = null;
      emit(previous);
      await _log('speech_start_failed');
      throw StateError('speechStartFailed');
    }
  }

  void _onEvent(SpeechEvent event) {
    if (event.sessionId != _nativeId) return;
    if (event.kind == 'level') {
      level.emit((event.level ?? 0).clamp(0, 1));
      return;
    }
    if (event.kind == 'error') {
      emit(
        value.copy(
          phase: SessionPhase.interrupted,
          error: event.text ?? 'speechInterrupted',
        ),
      );
      unawaited(_log('speech_interrupted'));
      return;
    }
    if (event.kind == 'transcript') {
      final revision = event.revision;
      if (revision == null || revision <= _revision) return;
      _revision = revision;
      _applyTranscript(event.segments ?? const [], event.text ?? '');
    } else if (event.kind == 'partial') {
      // Compatibility with engines that only emit replacement previews.
      _applyTranscript(const [], event.text ?? '');
    } else if (event.kind == 'segment' && event.segment != null) {
      _applyTranscript([event.segment!], null);
    }
  }

  void _applyTranscript(List<TranscriptSegment> incoming, String? preview) {
    final accepted = TranscriptTimeline.additions(
      _captureTranscript,
      incoming.where((segment) => segment.sessionId == _nativeId),
    );
    _captureTranscript.addAll(accepted);
    final partial = preview == null
        ? value.partial
        : TranscriptText.clean(preview);
    if (value.dictating) {
      final text = accepted.map((segment) => segment.text).join('\n');
      emit(
        value.copyWith(
          draft: text.isEmpty
              ? value.draft
              : [if (value.draft.isNotEmpty) value.draft, text].join('\n'),
          partial: partial,
        ),
      );
      return;
    }
    final all = [...value.segments, ...accepted];
    final metadata = accepted.isEmpty
        ? value.record
        : value.record?.copyWith(
            segmentCount: all.length,
            preview: value.record!.preview.isEmpty
                ? accepted.first.text
                : value.record!.preview,
            duration: math.max(value.record!.duration, accepted.last.end),
            updatedAt: clock.now(),
          );
    // Confirmed text and its replacement preview become visible in one update.
    // Slow storage must never clear a preview that arrived later.
    emit(
      value.copyWith(
        segments: List.unmodifiable(all),
        record: metadata,
        partial: partial,
      ),
    );
    if (accepted.isEmpty) return;
    final id = _nativeId;
    _writes = (_writes ?? Future<void>.value())
        .then((_) async {
          for (final segment in accepted) {
            await store.appendSegment(segment);
          }
        })
        .catchError((Object _) {
          if (value.id == id) emit(value.copy(error: 'transcriptSaveFailed'));
          unawaited(_log('transcript_save_failed'));
        });
  }

  Future<void> stop() async {
    if (!value.active || value.phase == SessionPhase.finalizing) return;
    final dictating = value.dictating;
    emit(value.copy(phase: SessionPhase.finalizing));
    try {
      await engine.stop();
      await _writes;
      if (dictating) {
        try {
          if (_nativeId != null) await engine.deleteSession(_nativeId!);
        } catch (_) {
          await _log('dictation_cleanup_failed');
        }
        emit(
          (_dictationBase ?? const SessionState()).copyWith(
            draft: value.draft,
            dictating: false,
            error: null,
          ),
        );
      } else {
        // Retry any canonical write that failed while capture was running.
        // The engine has already stopped; a replay problem must not report
        // the stop itself as failed. The journal stays available for restore().
        if (_nativeId != null) {
          try {
            await _replayJournal(_nativeId!);
          } catch (_) {
            await _log('transcript_replay_failed');
          }
        }
        final record = value.id == null
            ? null
            : await store.recording(value.id!);
        if (record != null) {
          final elapsed = value.startedAt == null
              ? 0.0
              : clock.now().difference(value.startedAt!).inMilliseconds / 1000;
          final finished = record.copyWith(
            status: RecordingStatus.completed,
            updatedAt: clock.now(),
            duration: math.max(record.duration, _durationBase + elapsed),
          );
          await store.saveRecording(finished);
          emit(
            value.copyWith(
              record: finished,
              segments: List.unmodifiable(await store.segments(finished.id)),
              phase: SessionPhase.completed,
              partial: '',
              error: null,
            ),
          );
        } else {
          emit(
            value.copy(
              phase: SessionPhase.completed,
              dictating: false,
              partial: '',
            ),
          );
        }
      }
      _nativeId = null;
      _dictationBase = null;
    } catch (_) {
      emit(
        value.copy(phase: SessionPhase.interrupted, error: 'speechStopFailed'),
      );
      await _log('speech_stop_failed');
    } finally {
      level.emit(0);
    }
  }

  Future<void> _log(String event) async {
    try {
      await store.appendLog(
        DiagnosticEntry(time: clock.now(), event: event, kind: 'speech'),
      );
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    await _events.cancel();
    if (_writes != null) await _writes;
    await level.close();
    await super.close();
  }
}
