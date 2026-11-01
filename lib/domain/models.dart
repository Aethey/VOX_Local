import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.freezed.dart';
part 'models.g.dart';

enum SessionPhase {
  idle,
  preparing,
  recording,
  finalizing,
  completed,
  interrupted,
}

enum JobPhase {
  pending,
  running,
  retrying,
  blocked,
  failed,
  succeeded,
  cancelled,
}

enum RecordingStatus { recording, completed, interrupted }

@freezed
abstract class RecordingSummary with _$RecordingSummary {
  const RecordingSummary._();
  const factory RecordingSummary({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String title,
    @Default('') String preview,
    @Default(0) int segmentCount,
    @Default(0.0) double duration,
    @Default(RecordingStatus.completed) RecordingStatus status,
    @Default('') String language,
    @Default('') String model,
    @Default(false) bool analysisEnabled,
    ProviderProfile? analysisProfile,
    AnalysisTemplate? analysisTemplate,
  }) = _RecordingSummary;
  factory RecordingSummary.fromJson(Map<String, dynamic> json) =>
      _$RecordingSummaryFromJson(json);

  String? get analysisScope =>
      analysisProfile == null || analysisTemplate == null
      ? null
      : '${analysisProfile!.id}:${analysisTemplate!.id}:${analysisTemplate!.version}';
}

@freezed
abstract class TranscriptSegment with _$TranscriptSegment {
  const factory TranscriptSegment({
    required String id,
    required String sessionId,
    required int sequence,
    required double start,
    required double end,
    required String text,
  }) = _TranscriptSegment;
  factory TranscriptSegment.fromJson(Map<String, dynamic> json) =>
      _$TranscriptSegmentFromJson(json);
}

@freezed
abstract class AnalysisTemplate with _$AnalysisTemplate {
  const factory AnalysisTemplate({
    required String id,
    required String name,
    required String instruction,
    @Default(1) int version,
    @Default(false) bool preset,
  }) = _AnalysisTemplate;
  factory AnalysisTemplate.fromJson(Map<String, dynamic> json) =>
      _$AnalysisTemplateFromJson(json);

  /// Default template for new installations and new recordings.
  static const actions = AnalysisTemplate(
    id: 'actions',
    name: '行动与待办',
    instruction: '识别对话中明确提出的任务、负责人和时间；缺失信息列为待确认，不要编造。',
    preset: true,
  );
  static const presets = [
    actions,
    AnalysisTemplate(
      id: 'decisions',
      name: '决策与分歧',
      instruction: '识别已经达成的决定、尚未解决的分歧和需要确认的问题。区分提议与最终决定。',
      preset: true,
    ),
    AnalysisTemplate(
      id: 'risks',
      name: '风险与疑问',
      instruction: '识别明确提及的风险、约束、依赖和未回答的问题，附原话依据。',
      preset: true,
    ),
  ];
}

@freezed
abstract class ProviderProfile with _$ProviderProfile {
  const ProviderProfile._();
  const factory ProviderProfile({
    required String id,
    required String provider,
    required String endpoint,
    required String model,
    required String credentialRef,
    @Default(12000) int inputCharacters,
    @Default(1500) int maxOutputTokens,
  }) = _ProviderProfile;
  factory ProviderProfile.fromJson(Map<String, dynamic> json) =>
      _$ProviderProfileFromJson(json);
  Uri get baseUri =>
      Uri.parse(endpoint.endsWith('/') ? endpoint : '$endpoint/');
  void validate() {
    final uri = Uri.tryParse(endpoint);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw const FormatException('invalidEndpoint');
    }
    if (model.trim().isEmpty) throw const FormatException('enterModelId');
    if (inputCharacters < 1000 || maxOutputTokens < 100) {
      throw const FormatException('budgetTooSmall');
    }
  }
}

@freezed
abstract class AnalysisJob with _$AnalysisJob {
  const AnalysisJob._();
  const factory AnalysisJob({
    required String id,
    required String sessionId,
    required ProviderProfile profile,
    required AnalysisTemplate template,
    required List<TranscriptSegment> segments,
    required String context,
    required DateTime createdAt,

    /// Language the provider is asked to write findings in.
    @Default('zh') String language,

    /// True when the job carries the full transcript in one request
    /// (manual re-analysis) instead of an incremental batch.
    @Default(false) bool whole,
    @Default(JobPhase.pending) JobPhase phase,
    @Default(0) int attempts,
    DateTime? scheduledAt,
    String? error,
    AnalysisResult? result,
  }) = _AnalysisJob;
  factory AnalysisJob.fromJson(Map<String, dynamic> json) =>
      _$AnalysisJobFromJson(json);
  DateTime get dueAt => scheduledAt ?? createdAt;
  String get scopeKey => '${profile.id}:${template.id}:${template.version}';
  AnalysisJob update({
    JobPhase? phase,
    int? attempts,
    DateTime? dueAt,
    String? error,
    AnalysisResult? result,
  }) => copyWith(
    phase: phase ?? this.phase,
    attempts: attempts ?? this.attempts,
    scheduledAt: dueAt ?? scheduledAt,
    error: error,
    result: result ?? this.result,
  );
}

@freezed
abstract class Finding with _$Finding {
  const factory Finding({
    required String topic,
    required String summary,
    @JsonKey(name: 'evidenceSegmentIds') required List<String> evidence,
    @Default([]) List<String> questions,
  }) = _Finding;
  factory Finding.fromJson(Map<String, dynamic> json) =>
      _$FindingFromJson(json);
}

@freezed
abstract class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required bool matched,
    required List<Finding> findings,
  }) = _AnalysisResult;
  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);
}

@freezed
abstract class DiagnosticEntry with _$DiagnosticEntry {
  const factory DiagnosticEntry({
    required DateTime time,
    required String event,
    String? jobId,
    int? status,
    int? attempt,
    String? kind,
  }) = _DiagnosticEntry;
  factory DiagnosticEntry.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticEntryFromJson(json);
}
