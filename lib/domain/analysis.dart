import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';

import 'failure.dart';
import 'models.dart';
import 'ports.dart';

class RetryDecision {
  const RetryDecision(this.phase, [this.delay = Duration.zero]);
  final JobPhase phase;
  final Duration delay;
}

class RetryPolicy {
  const RetryPolicy({this.maxAttempts = 4});
  final int maxAttempts;
  RetryDecision decide(AppFailure failure, int attempts, double jitter) {
    if (failure.needsUser) return const RetryDecision(JobPhase.blocked);
    if (!failure.retryable || attempts >= maxAttempts) {
      return const RetryDecision(JobPhase.failed);
    }
    final backoff = Duration(
      milliseconds:
          (2000 * math.pow(2, attempts - 1) * (0.8 + jitter.clamp(0, 1) * 0.4))
              .round(),
    );
    final specified = failure.retryAfter ?? Duration.zero;
    return RetryDecision(
      JobPhase.retrying,
      specified > backoff ? specified : backoff,
    );
  }
}

class AnalysisPlanner {
  AnalysisPlanner(this.store, this.clock);
  final LocalStore store;
  final Clock clock;
  Future<bool> plan(
    String sessionId,
    ProviderProfile profile,
    AnalysisTemplate template, {
    String language = 'zh',
  }) async {
    profile.validate();
    if (template.instruction.trim().isEmpty ||
        template.instruction.length > 4000) {
      throw const FormatException('invalidRulesLength');
    }
    // Cursor is scoped to rule/config versions. A changed rule starts its own coverage.
    final key = '$sessionId:${profile.id}:${template.id}:${template.version}';
    final cursor = await store.cursor(key);
    final all = await store.segments(sessionId);
    final remaining = all.where((s) => s.sequence > cursor).toList();
    if (remaining.isEmpty) {
      await store.markAnalysisPlanned(
        sessionId,
        '${profile.id}:${template.id}:${template.version}',
        cursor,
      );
      return false;
    }
    final budget = profile.inputCharacters - template.instruction.length - 1800;
    if (budget < 500) throw const FormatException('rulesOverBudget');
    final selected = <TranscriptSegment>[];
    var size = 0;
    for (final segment in remaining) {
      final cost = jsonEncode(segment.toJson()).length;
      if (cost > budget) throw const FormatException('segmentOverBudget');
      if (size + cost > budget) break;
      selected.add(segment);
      size += cost;
    }
    final preceding = all
        .where((s) => s.sequence <= cursor)
        .map((s) => s.text)
        .join('\n');
    final context = preceding.length > 1000
        ? preceding.substring(preceding.length - 1000)
        : preceding;
    if (await store.pendingCount() >= 100) {
      throw const AppFailure(FailureKind.storage, 'queueFull');
    }
    final id = sha256
        .convert(
          utf8.encode(
            '$key:${selected.first.sequence}:${selected.last.sequence}',
          ),
        )
        .toString();
    return store.enqueue(
      AnalysisJob(
        id: id,
        sessionId: sessionId,
        profile: profile,
        template: template,
        segments: selected,
        context: context,
        createdAt: clock.now(),
        language: language,
      ),
      cursor,
      key,
    );
  }
}

class AnalysisWorker {
  AnalysisWorker({
    required this.store,
    required this.credentials,
    required this.provider,
    required this.clock,
    required this.random,
    this.policy = const RetryPolicy(),
    this.connectivity,
  });
  final LocalStore store;
  final CredentialStore credentials;
  final AnalysisProvider provider;
  final Clock clock;
  final RandomSource random;
  final RetryPolicy policy;
  final ConnectivityProbe? connectivity;
  bool _busy = false, _stopped = false;
  int _generation = 0;
  String? activeSessionId;
  Future<void> tick({String? scope}) async {
    if (_busy || _stopped || !(connectivity?.available ?? true)) return;
    _busy = true;
    final generation = _generation;
    AnalysisJob? job;
    try {
      job = await store.claim(clock.now(), scope: scope);
      if (job == null) return;
      activeSessionId = job.sessionId;
      final credential = await credentials.read(job.profile.credentialRef);
      if (credential == null || credential.isEmpty) {
        throw const AppFailure(FailureKind.credentials, 'saveApiKey');
      }
      if (_stopped || generation != _generation) {
        await store.updateJob(
          job.update(phase: JobPhase.retrying, dueAt: clock.now()),
        );
        return;
      }
      final result = await provider.analyze(job, credential);
      if (_stopped || generation != _generation) {
        await store.updateJob(
          job.update(phase: JobPhase.retrying, dueAt: clock.now()),
        );
        return;
      }
      await store.updateJob(
        job.update(phase: JobPhase.succeeded, result: result),
      );
      await _log(
        DiagnosticEntry(
          time: clock.now(),
          event: 'analysis_succeeded',
          jobId: job.id,
          attempt: job.attempts,
        ),
      );
    } catch (error) {
      final failure = error is AppFailure
          ? error
          : const AppFailure(FailureKind.storage, 'analysisIncomplete');
      if (job != null) {
        final decision =
            (_stopped ||
                generation != _generation ||
                !(connectivity?.available ?? true))
            ? const RetryDecision(JobPhase.retrying)
            : policy.decide(failure, job.attempts, random.nextDouble());
        try {
          await store.updateJob(
            job.update(
              phase: decision.phase,
              dueAt: clock.now().add(decision.delay),
              error: failure.message,
            ),
          );
        } catch (_) {
          /* Durable running task will be recovered after restart. */
        }
      }
      await _log(
        DiagnosticEntry(
          time: clock.now(),
          event: 'analysis_failed',
          jobId: job?.id,
          kind: failure.kind.name,
          status: failure.status,
          attempt: job?.attempts,
        ),
      );
    } finally {
      activeSessionId = null;
      _busy = false;
    }
  }

  Future<void> _log(DiagnosticEntry entry) async {
    try {
      await store.appendLog(entry);
    } catch (_) {
      /* Diagnostics never change job outcome. */
    }
  }

  void pause() {
    if (!_stopped) _generation++;
    _stopped = true;
    provider.cancel();
  }

  void resume() {
    _stopped = false;
  }
}

class ResultValidator {
  const ResultValidator();
  AnalysisResult parse(String content, AnalysisJob job) {
    try {
      var text = content.trim();
      if (text.startsWith('```')) {
        text = text
            .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
            .replaceFirst(RegExp(r'\s*```$'), '');
      }
      final result = AnalysisResult.fromJson(
        Map<String, dynamic>.from(jsonDecode(text) as Map),
      );
      final ids = job.segments.map((s) => s.id).toSet();
      if ((!result.matched && result.findings.isNotEmpty) ||
          (result.matched && result.findings.isEmpty) ||
          result.findings.length > 30) {
        throw const FormatException();
      }
      for (final finding in result.findings) {
        if (finding.topic.trim().isEmpty ||
            finding.summary.trim().isEmpty ||
            finding.evidence.isEmpty ||
            finding.evidence.any((id) => !ids.contains(id))) {
          throw const FormatException();
        }
      }
      return result;
    } catch (_) {
      throw const AppFailure(
        FailureKind.invalidResponse,
        'invalidAnalysisResult',
      );
    }
  }
}
