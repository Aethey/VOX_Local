import 'models.dart';

class OfflineModelState {
  const OfflineModelState(
    this.id, {
    this.phase = 'missing',
    this.progress = 0,
    this.error,
  });
  final String id, phase;
  final double progress;
  final String? error;
  bool get installed =>
      {'installed', 'preparing', 'ready', 'deleting'}.contains(phase);
  bool get busy =>
      {'downloading', 'verifying', 'preparing', 'deleting'}.contains(phase);
}

class SpeechEvent {
  const SpeechEvent(
    this.kind, {
    this.sessionId,
    this.modelId,
    this.phase,
    this.progress,
    this.text,
    this.level,
    this.segment,
    this.segments,
    this.revision,
  });
  final String kind;
  final String? sessionId, modelId, phase, text;
  final double? progress, level;
  final TranscriptSegment? segment;
  final List<TranscriptSegment>? segments;
  final int? revision;
}

abstract interface class SpeechEngine {
  Stream<SpeechEvent> get events;
  Future<List<OfflineModelState>> models();
  Future<void> download(String id);
  Future<void> load(String id);
  Future<void> delete(String id);

  /// Starts capture. A resumed session passes the last stored sequence and
  /// end time so native numbering and timestamps continue the timeline.
  Future<void> start(
    String sessionId,
    String language, {
    int afterSequence = 0,
    double offset = 0,
  });
  Future<void> stop();
  Future<void> deleteSession(String sessionId);
  Future<List<TranscriptSegment>> replay(String sessionId, int afterSequence);
  Future<void> dispose();
}
