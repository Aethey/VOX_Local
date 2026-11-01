// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecordingSummary _$RecordingSummaryFromJson(Map<String, dynamic> json) =>
    _RecordingSummary(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String? ?? '',
      preview: json['preview'] as String? ?? '',
      segmentCount: (json['segmentCount'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      status:
          $enumDecodeNullable(_$RecordingStatusEnumMap, json['status']) ??
          RecordingStatus.completed,
      language: json['language'] as String? ?? '',
      model: json['model'] as String? ?? '',
      analysisEnabled: json['analysisEnabled'] as bool? ?? false,
      analysisProfile: json['analysisProfile'] == null
          ? null
          : ProviderProfile.fromJson(
              json['analysisProfile'] as Map<String, dynamic>,
            ),
      analysisTemplate: json['analysisTemplate'] == null
          ? null
          : AnalysisTemplate.fromJson(
              json['analysisTemplate'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RecordingSummaryToJson(_RecordingSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'preview': instance.preview,
      'segmentCount': instance.segmentCount,
      'duration': instance.duration,
      'status': _$RecordingStatusEnumMap[instance.status]!,
      'language': instance.language,
      'model': instance.model,
      'analysisEnabled': instance.analysisEnabled,
      'analysisProfile': instance.analysisProfile?.toJson(),
      'analysisTemplate': instance.analysisTemplate?.toJson(),
    };

const _$RecordingStatusEnumMap = {
  RecordingStatus.recording: 'recording',
  RecordingStatus.completed: 'completed',
  RecordingStatus.interrupted: 'interrupted',
};

_TranscriptSegment _$TranscriptSegmentFromJson(Map<String, dynamic> json) =>
    _TranscriptSegment(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      sequence: (json['sequence'] as num).toInt(),
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$TranscriptSegmentToJson(_TranscriptSegment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'sequence': instance.sequence,
      'start': instance.start,
      'end': instance.end,
      'text': instance.text,
    };

_AnalysisTemplate _$AnalysisTemplateFromJson(Map<String, dynamic> json) =>
    _AnalysisTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      instruction: json['instruction'] as String,
      version: (json['version'] as num?)?.toInt() ?? 1,
      preset: json['preset'] as bool? ?? false,
    );

Map<String, dynamic> _$AnalysisTemplateToJson(_AnalysisTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'instruction': instance.instruction,
      'version': instance.version,
      'preset': instance.preset,
    };

_ProviderProfile _$ProviderProfileFromJson(Map<String, dynamic> json) =>
    _ProviderProfile(
      id: json['id'] as String,
      provider: json['provider'] as String,
      endpoint: json['endpoint'] as String,
      model: json['model'] as String,
      credentialRef: json['credentialRef'] as String,
      inputCharacters: (json['inputCharacters'] as num?)?.toInt() ?? 12000,
      maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt() ?? 1500,
    );

Map<String, dynamic> _$ProviderProfileToJson(_ProviderProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider': instance.provider,
      'endpoint': instance.endpoint,
      'model': instance.model,
      'credentialRef': instance.credentialRef,
      'inputCharacters': instance.inputCharacters,
      'maxOutputTokens': instance.maxOutputTokens,
    };

_AnalysisJob _$AnalysisJobFromJson(Map<String, dynamic> json) => _AnalysisJob(
  id: json['id'] as String,
  sessionId: json['sessionId'] as String,
  profile: ProviderProfile.fromJson(json['profile'] as Map<String, dynamic>),
  template: AnalysisTemplate.fromJson(json['template'] as Map<String, dynamic>),
  segments: (json['segments'] as List<dynamic>)
      .map((e) => TranscriptSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
  context: json['context'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  language: json['language'] as String? ?? 'zh',
  whole: json['whole'] as bool? ?? false,
  phase:
      $enumDecodeNullable(_$JobPhaseEnumMap, json['phase']) ?? JobPhase.pending,
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  error: json['error'] as String?,
  result: json['result'] == null
      ? null
      : AnalysisResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnalysisJobToJson(_AnalysisJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'profile': instance.profile.toJson(),
      'template': instance.template.toJson(),
      'segments': instance.segments.map((e) => e.toJson()).toList(),
      'context': instance.context,
      'createdAt': instance.createdAt.toIso8601String(),
      'language': instance.language,
      'whole': instance.whole,
      'phase': _$JobPhaseEnumMap[instance.phase]!,
      'attempts': instance.attempts,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'error': instance.error,
      'result': instance.result?.toJson(),
    };

const _$JobPhaseEnumMap = {
  JobPhase.pending: 'pending',
  JobPhase.running: 'running',
  JobPhase.retrying: 'retrying',
  JobPhase.blocked: 'blocked',
  JobPhase.failed: 'failed',
  JobPhase.succeeded: 'succeeded',
  JobPhase.cancelled: 'cancelled',
};

_Finding _$FindingFromJson(Map<String, dynamic> json) => _Finding(
  topic: json['topic'] as String,
  summary: json['summary'] as String,
  evidence: (json['evidenceSegmentIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  questions:
      (json['questions'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$FindingToJson(_Finding instance) => <String, dynamic>{
  'topic': instance.topic,
  'summary': instance.summary,
  'evidenceSegmentIds': instance.evidence,
  'questions': instance.questions,
};

_AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) =>
    _AnalysisResult(
      matched: json['matched'] as bool,
      findings: (json['findings'] as List<dynamic>)
          .map((e) => Finding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalysisResultToJson(_AnalysisResult instance) =>
    <String, dynamic>{
      'matched': instance.matched,
      'findings': instance.findings.map((e) => e.toJson()).toList(),
    };

_DiagnosticEntry _$DiagnosticEntryFromJson(Map<String, dynamic> json) =>
    _DiagnosticEntry(
      time: DateTime.parse(json['time'] as String),
      event: json['event'] as String,
      jobId: json['jobId'] as String?,
      status: (json['status'] as num?)?.toInt(),
      attempt: (json['attempt'] as num?)?.toInt(),
      kind: json['kind'] as String?,
    );

Map<String, dynamic> _$DiagnosticEntryToJson(_DiagnosticEntry instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'event': instance.event,
      'jobId': instance.jobId,
      'status': instance.status,
      'attempt': instance.attempt,
      'kind': instance.kind,
    };
