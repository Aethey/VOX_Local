import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/providers.dart';
import '../../l10n/localization.dart';
import '../widgets/active_recording_button.dart';
import '../widgets/common.dart';
import '../widgets/settings_group.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logsProvider);
    return Scaffold(
      floatingActionButton: const ActiveRecordingButton(),
      appBar: AppBar(
        title: Text(context.l10n.diagnostics),
        actions: [
          IconButton(
            tooltip: context.l10n.refreshLogs,
            onPressed: () => ref.invalidate(logsProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: logs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Padding(
          padding: EdgeInsets.all(24),
          child: StatusNote(context.l10n.message('logsUnavailable')),
        ),
        data: (entries) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                context.l10n.logPrivacy,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(context.l10n.noLogs),
              )
            else
              SettingsGroup(
                children: [
                  for (final entry in entries)
                    SettingsRow(
                      icon: entry.kind == null
                          ? Icons.check_circle_outline_rounded
                          : Icons.error_outline_rounded,
                      title: switch (entry.event) {
                        'analysis_succeeded' => context.l10n.analysisSucceeded,
                        'analysis_failed' => context.l10n.analysisFailed,
                        'provider_request_failed' =>
                          context.l10n.providerRequestFailed,
                        'model_prepare_failed' =>
                          context.l10n.modelPrepareFailedLog,
                        'model_delete_failed' =>
                          context.l10n.modelDeleteFailedLog,
                        'speech_start_failed' =>
                          context.l10n.speechStartFailedLog,
                        'speech_interrupted' =>
                          context.l10n.speechInterruptedLog,
                        _ => context.l10n.runtimeLog,
                      },
                      subtitle:
                          '${DateFormat.yMMMd(context.l10n.localeName).add_Hms().format(entry.time.toLocal())}\n${entry.kind == null ? context.l10n.success : context.l10n.diagnosticKind(entry.kind!)}${entry.status == null ? '' : ' · HTTP ${entry.status}'}${entry.attempt == null ? '' : ' · ${context.l10n.retryAttempt(entry.attempt!)}'}',
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
