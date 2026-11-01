import 'dart:async';

import '../domain/models.dart';
import '../domain/speech.dart';
import 'generated/speech.g.dart';

class NativeSpeechEngine extends SpeechFlutterApi implements SpeechEngine {
  NativeSpeechEngine() {
    SpeechFlutterApi.setUp(this);
  }
  final _host = SpeechHostApi();
  final _events = StreamController<SpeechEvent>.broadcast();
  @override
  Stream<SpeechEvent> get events => _events.stream;
  TranscriptSegment _segment(NativeSegment s) => TranscriptSegment(
    id: '${s.sessionId}:${s.sequence}',
    sessionId: s.sessionId,
    sequence: s.sequence,
    start: s.start,
    end: s.end,
    text: s.text,
  );
  @override
  void onEvent(NativeEvent event) {
    if (!_events.isClosed) {
      _events.add(
        SpeechEvent(
          event.kind,
          sessionId: event.sessionId,
          modelId: event.modelId,
          phase: event.phase,
          progress: event.progress,
          text: event.text,
          level: event.level,
          segment: event.segment == null ? null : _segment(event.segment!),
          segments: event.segments?.map(_segment).toList(growable: false),
          revision: event.revision,
        ),
      );
    }
  }

  @override
  Future<List<OfflineModelState>> models() async => (await _host.models())
      .map(
        (m) => OfflineModelState(
          m.id,
          phase: m.installed ? 'installed' : 'missing',
        ),
      )
      .toList();
  @override
  Future<void> download(String id) => _host.download(id);
  @override
  Future<void> load(String id) => _host.load(id);
  @override
  Future<void> delete(String id) => _host.delete(id);
  @override
  Future<void> start(
    String sessionId,
    String language, {
    int afterSequence = 0,
    double offset = 0,
  }) => _host.start(sessionId, language, afterSequence, offset);
  @override
  Future<void> stop() async {
    await _host.stop();
    // onEvent's broadcast stream delivers asynchronously. Drain it before the
    // session waits for canonical writes or finalizes template dictation.
    await Future<void>.delayed(Duration.zero);
  }

  @override
  Future<void> deleteSession(String sessionId) =>
      _host.deleteSession(sessionId);
  @override
  Future<List<TranscriptSegment>> replay(
    String sessionId,
    int afterSequence,
  ) async =>
      (await _host.replay(sessionId, afterSequence)).map(_segment).toList();
  @override
  Future<void> dispose() async {
    SpeechFlutterApi.setUp(null);
    await _events.close();
  }
}
