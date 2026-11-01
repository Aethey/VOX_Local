import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models.dart';
import '../../l10n/localization.dart';
import '../routes.dart';
import '../widgets/common.dart';
import '../widgets/settings_group.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuration = ref.watch(settingsProvider);
    final all = ref.watch(analysisProvider);
    final warning =
        ref.watch(analysisWarningProvider).value ??
        ref.read(runtimeProvider).analysis.warning.value;
    final session = ref.watch(sessionProvider);
    final sessionId = session.id;
    final record = session.record;
    if (record == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_outlined, size: 44),
              const SizedBox(height: 16),
              Text(
                context.l10n.recordBeforeAnalysis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => DefaultTabController.of(context).animateTo(0),
                icon: const Icon(Icons.mic_none_rounded),
                label: Text(context.l10n.startRecording),
              ),
            ],
          ),
        ),
      );
    }
    // AnalysisService already scopes jobs to the selected recording.
    final jobs = all;
    final results = jobs.where((j) => j.phase == JobPhase.succeeded).toList();
    final failed = jobs
        .where(
          (j) =>
              (j.phase == JobPhase.blocked || j.phase == JobPhase.failed) &&
              j.profile.id == record.analysisProfile?.id,
        )
        .toList();
    final waiting = jobs
        .where(
          (j) => {
            JobPhase.pending,
            JobPhase.retrying,
            JobPhase.running,
          }.contains(j.phase),
        )
        .length;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final muted = text.bodyMedium?.copyWith(color: colors.onSurfaceVariant);
    final providerMissing =
        (record.analysisProfile ?? configuration.profile) == null;
    // Whole-transcript analysis only makes sense once the recording is over
    // and there is text to send.
    final canAnalyzeWhole =
        record.status != RecordingStatus.recording &&
        session.segments.isNotEmpty;
    Future<void> analyzeWhole() async {
      if (providerMissing) {
        await const ProviderRoute().push(context);
        if (!context.mounted ||
            ref.read(sessionProvider).id != sessionId ||
            ref.read(settingsProvider).profile == null) {
          return;
        }
      }
      if (context.mounted) {
        await guardAction(
          context,
          () => ref.read(analysisProvider.notifier).analyzeWhole(),
        );
      }
    }

    Widget wholeButton() => FilledButton.tonalIcon(
      key: const ValueKey('analyze-whole'),
      onPressed: session.managing || waiting > 0 ? null : analyzeWhole,
      icon: Icon(
        providerMissing ? Icons.add_link_rounded : Icons.auto_awesome_outlined,
      ),
      label: Text(
        providerMissing
            ? context.l10n.configureAnalysisProvider
            : context.l10n.analyzeWhole,
      ),
    );
    // Re-apply the record's analysis scope after a settings screen changed it.
    Future<void> reconfigureIfChanged<T>(
      T Function() read,
      Future<void> Function() open,
    ) async {
      final before = read();
      await open();
      if (context.mounted &&
          ref.read(sessionProvider).id == sessionId &&
          read() != before) {
        await guardAction(
          context,
          () => ref
              .read(analysisProvider.notifier)
              .configure(
                ref.read(sessionProvider).record!.analysisEnabled,
                useCurrentSettings: true,
              ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        const SizedBox(height: 12),
        SettingsGroup(
          children: [
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
              title: Text(context.l10n.onlineAnalysis),
              subtitle: Text(
                (record.analysisProfile ?? configuration.profile) == null
                    ? context.l10n.configureProviderFirst
                    : context.l10n.analysisEvery(configuration.interval),
              ),
              value: record.analysisEnabled,
              onChanged: session.managing
                  ? null
                  : (enabled) async {
                      if (enabled &&
                          record.analysisProfile == null &&
                          configuration.profile == null) {
                        await const ProviderRoute().push(context);
                        if (!context.mounted ||
                            ref.read(sessionProvider).id != sessionId ||
                            ref.read(settingsProvider).profile == null) {
                          return;
                        }
                      }
                      if (context.mounted) {
                        await guardAction(
                          context,
                          () => ref
                              .read(analysisProvider.notifier)
                              .configure(enabled),
                        );
                      }
                    },
            ),
            SettingsRow(
              icon: Icons.edit_note_rounded,
              title: context.l10n.analysisTemplates,
              value: context.l10n.templateNameFor(
                record.analysisTemplate ?? configuration.template,
              ),
              onTap: () => reconfigureIfChanged(
                () => ref.read(settingsProvider).template,
                () => const TemplateRoute().push(context),
              ),
            ),
            SettingsRow(
              icon: Icons.cloud_outlined,
              title: context.l10n.providerAndModel,
              value:
                  record.analysisProfile?.model ??
                  configuration.profile?.model ??
                  context.l10n.notConfigured,
              onTap: () => reconfigureIfChanged(
                () => ref.read(settingsProvider).profile,
                () => const ProviderRoute().push(context),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
          child: Text(context.l10n.analysisPrivacy, style: muted),
        ),
        // With results on screen the whole-transcript action sits with the
        // controls; the empty state below offers it as the primary action.
        if (canAnalyzeWhole && results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                wholeButton(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                  child: Text(context.l10n.analyzeWholeHelp, style: muted),
                ),
              ],
            ),
          ),
        if (warning != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: StatusNote(context.l10n.message(warning)),
          ),
        if (failed.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: StatusNote(
              context.l10n.message(failed.first.error ?? 'analysisNeedsRetry'),
              action: TextButton(
                onPressed: () => guardAction(
                  context,
                  () => ref.read(analysisProvider.notifier).retry(),
                ),
                child: Text(context.l10n.retry),
              ),
            ),
          ),
        if (waiting > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 4, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    record.analysisEnabled
                        ? context.l10n.waitingBatches(waiting)
                        : context.l10n.pausedAnalysisBatches(waiting),
                    style: muted,
                  ),
                ),
              ],
            ),
          ),
        SectionTitle(context.l10n.analysisResults),
        if (all.length >= 100)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(context.l10n.recentAnalysis, style: muted),
          ),
        if (results.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(
              children: [
                const ConversationFlow(analysis: true),
                const SizedBox(height: 24),
                if (canAnalyzeWhole) ...[
                  wholeButton(),
                  if (!providerMissing)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Text(
                        context.l10n.analyzeWholeHelp,
                        style: muted,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ] else
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      if (!record.analysisEnabled) {
                        if (record.analysisProfile == null &&
                            ref.read(settingsProvider).profile == null) {
                          await const ProviderRoute().push(context);
                          if (!context.mounted ||
                              ref.read(sessionProvider).id != sessionId ||
                              ref.read(settingsProvider).profile == null) {
                            return;
                          }
                        }
                        if (context.mounted) {
                          await guardAction(
                            context,
                            () => ref
                                .read(analysisProvider.notifier)
                                .configure(true),
                          );
                        }
                      } else {
                        DefaultTabController.of(context).animateTo(0);
                      }
                    },
                    icon: Icon(
                      (record.analysisProfile ?? configuration.profile) == null
                          ? Icons.add_link_rounded
                          : record.analysisEnabled
                          ? Icons.mic_none_rounded
                          : Icons.power_settings_new_rounded,
                    ),
                    label: Text(
                      (record.analysisProfile ?? configuration.profile) == null
                          ? context.l10n.configureAnalysisProvider
                          : record.analysisEnabled
                          ? context.l10n.startRecording
                          : context.l10n.enableOnlineAnalysis,
                    ),
                  ),
              ],
            ),
          ),
        for (final job in results)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ResultCard(job: job),
          ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.job});
  final AnalysisJob job;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final meta = text.labelMedium?.copyWith(color: colors.onSurfaceVariant);
    final findings = job.result?.findings ?? const <Finding>[];
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 2,
              children: [
                if (job.whole)
                  Text(
                    context.l10n.wholeAnalysis,
                    style: meta?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (job.segments.isNotEmpty)
                  Text(
                    '${durationLabel(job.segments.first.start)} — ${durationLabel(job.segments.last.end)}',
                    style: meta,
                  ),
                Text(
                  '${context.l10n.templateNameFor(job.template)} · ${job.profile.model}',
                  style: meta,
                ),
              ],
            ),
            if (job.result?.matched == false)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                child: Text(context.l10n.noMatch),
              ),
            for (final finding in findings) ...[
              const SizedBox(height: 14),
              Text(finding.topic, style: text.titleMedium),
              const SizedBox(height: 6),
              SelectableText(finding.summary, style: text.bodyLarge),
              if (finding.questions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    context.l10n.openQuestions(finding.questions.join('; ')),
                    style: text.bodyMedium?.copyWith(color: colors.primary),
                  ),
                ),
              _Evidence(
                lines: [
                  for (final id in finding.evidence)
                    job.segments
                        .where((segment) => segment.id == id)
                        .map((segment) => segment.text)
                        .join('\n'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Quoted transcript lines behind a text toggle instead of an ExpansionTile.
class _Evidence extends StatefulWidget {
  const _Evidence({required this.lines});
  final List<String> lines;
  @override
  State<_Evidence> createState() => _EvidenceState();
}

class _EvidenceState extends State<_Evidence> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final lines = widget.lines.where((line) => line.isNotEmpty).toList();
    if (lines.isEmpty) return const SizedBox(height: 8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => open = !open),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              visualDensity: VisualDensity.compact,
            ),
            icon: AnimatedRotation(
              turns: open ? .5 : 0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: const Icon(Icons.expand_more_rounded, size: 20),
            ),
            label: Text(
              open ? context.l10n.hideOriginal : context.l10n.viewOriginal,
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: open
              ? Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  decoration: BoxDecoration(
                    color: colors.secondaryContainer.withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final line in lines)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: SelectableText(
                            line,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: colors.onSecondaryContainer),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
