import 'models.dart';

abstract interface class Clock {
  DateTime now();
}

abstract interface class RandomSource {
  double nextDouble();
}

abstract interface class ConnectivityProbe {
  bool get available;
}

abstract interface class CredentialStore {
  Future<String?> read(String reference);
  Future<void> write(String reference, String value);
  Future<void> delete(String reference);
}

abstract interface class AnalysisProvider {
  Future<AnalysisResult> analyze(AnalysisJob job, String credential);
  Future<List<String>> models(ProviderProfile profile, String credential);
  void cancel();
}

abstract interface class LocalStore {
  Stream<void> get jobChanges;
  Stream<void> get recordingChanges;
  Future<List<RecordingSummary>> recordings({
    int limit = 40,
    int offset = 0,
    String query = '',
  });
  Future<RecordingSummary?> recording(String id);
  Future<void> saveRecording(RecordingSummary recording);
  Future<void> deleteRecording(String id);
  Future<List<RecordingSummary>> analysisTargets({int limit = 20});
  Future<void> markAnalysisPlanned(String id, String scope, int sequence);
  Future<String?> setting(String key);
  Future<void> saveSetting(String key, String value);
  Future<void> appendSegment(TranscriptSegment segment);
  Future<List<TranscriptSegment>> segments(String sessionId);
  Future<bool> enqueue(
    AnalysisJob job,
    int expectedCursor,
    String cursorKey, {
    int capacity = 100,
  });
  Future<int> cursor(String key);
  Future<int> pendingCount();
  Future<List<AnalysisJob>> jobs({int? limit, String? sessionId});
  Future<AnalysisJob?> claim(DateTime now, {String? scope});
  Future<void> updateJob(AnalysisJob job);
  Future<void> recover();
  Future<void> retryFailed(String profileId, DateTime now, {String? sessionId});
  Future<void> appendLog(DiagnosticEntry entry);
  Future<List<DiagnosticEntry>> logs();
  Future<void> close();
}
