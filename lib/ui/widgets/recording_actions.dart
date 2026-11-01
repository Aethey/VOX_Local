import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/providers.dart';
import '../../domain/models.dart';
import '../../l10n/localization.dart';
import '../routes.dart';
import 'common.dart';
import 'labeled_field.dart';
import 'sheets.dart';

String recordingDate(BuildContext context, RecordingSummary record) =>
    DateFormat.yMMMd(context.l10n.localeName)
        .add_Hm()
        .format(record.createdAt.toLocal());

String recordingTitle(BuildContext context, RecordingSummary record) {
  if (record.title.isNotEmpty) return record.title;
  if (record.preview.isNotEmpty) {
    final firstLine = record.preview.split('\n').first;
    return firstLine.runes.length > 32
        ? '${String.fromCharCodes(firstLine.runes.take(32))}…'
        : firstLine;
  }
  return context.l10n.recordingDateTitle(recordingDate(context, record));
}

Future<void> copyRecording(
  BuildContext context,
  WidgetRef ref,
  RecordingSummary record,
) => guardAction(context, () async {
  final text = await ref.read(sessionProvider.notifier).transcript(record.id);
  if (!context.mounted) return;
  if (text.isEmpty) {
    showMessage(context, context.l10n.noTranscriptToCopy);
    return;
  }
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) showMessage(context, context.l10n.transcriptCopied);
});

/// Continues capturing into [record] and opens it. The record screen's own
/// open() is a no-op because the session already holds this id.
Future<void> resumeRecording(
  BuildContext context,
  WidgetRef ref,
  RecordingSummary record,
) => guardAction(context, () async {
  await ref.read(sessionProvider.notifier).resume(record.id);
  if (context.mounted) RecordRoute(id: record.id).push(context);
});

Future<void> renameRecording(
  BuildContext context,
  WidgetRef ref,
  RecordingSummary record,
) async {
  final title = await showVoxSheet<String>(
    context,
    builder: (_) => _RenameRecording(initial: recordingTitle(context, record)),
  );
  if (title != null && context.mounted) {
    await guardAction(
      context,
      () => ref.read(sessionProvider.notifier).rename(record.id, title),
    );
  }
}

Future<bool> deleteRecording(
  BuildContext context,
  WidgetRef ref,
  RecordingSummary record,
) async {
  final confirmed = await confirmSheet(
    context,
    title: context.l10n.deleteRecordingTitle(recordingTitle(context, record)),
    message: context.l10n.deleteRecordingBody,
    confirmLabel: context.l10n.delete,
  );
  if (!confirmed || !context.mounted) return false;
  var removed = false;
  await guardAction(context, () async {
    await ref.read(sessionProvider.notifier).delete(record.id);
    removed = true;
  });
  return removed;
}

class RecordingMenu extends ConsumerWidget {
  const RecordingMenu({
    required this.record,
    this.onDeleted,
    this.canResume = false,
    super.key,
  });
  final RecordingSummary record;
  final VoidCallback? onDeleted;

  /// Resuming is offered from the library only; the record screen stays
  /// focused on the current capture.
  final bool canResume;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    return IconButton(
      tooltip: context.l10n.recordingActions,
      onPressed: session.managing
          ? null
          : () async {
              final action = await showActionSheet(
                context,
                title: recordingTitle(context, record),
                actions: [
                  if (canResume)
                    SheetAction(
                      'resume',
                      session.active
                          ? context.l10n.finishRecordingBeforeResume
                          : context.l10n.resumeRecording,
                      icon: Icons.mic_none_rounded,
                      enabled: !session.active,
                    ),
                  SheetAction(
                    'rename',
                    context.l10n.renameRecording,
                    icon: Icons.edit_outlined,
                  ),
                  SheetAction(
                    'copy',
                    context.l10n.copyTranscript,
                    icon: Icons.copy_all_outlined,
                  ),
                  SheetAction(
                    'delete',
                    session.active
                        ? context.l10n.finishRecordingBeforeDelete
                        : context.l10n.deleteRecording,
                    icon: Icons.delete_outline_rounded,
                    destructive: true,
                    enabled: !session.active,
                  ),
                ],
              );
              if (!context.mounted) return;
              switch (action) {
                case 'resume':
                  await resumeRecording(context, ref, record);
                case 'rename':
                  await renameRecording(context, ref, record);
                case 'copy':
                  await copyRecording(context, ref, record);
                case 'delete':
                  if (await deleteRecording(context, ref, record)) {
                    onDeleted?.call();
                  }
              }
            },
      icon: const Icon(Icons.more_horiz_rounded),
    );
  }
}

class _RenameRecording extends StatefulWidget {
  const _RenameRecording({required this.initial});
  final String initial;
  @override
  State<_RenameRecording> createState() => _RenameRecordingState();
}

class _RenameRecordingState extends State<_RenameRecording> {
  final form = GlobalKey<FormState>();
  late final controller = TextEditingController(text: widget.initial);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (form.currentState!.validate()) {
      Navigator.pop(context, controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      SheetTitle(context.l10n.renameRecording),
      LabeledField(
        label: context.l10n.recordingName,
        controller: controller,
        maxLength: 80,
        child: Form(
          key: form,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            maxLength: 80,
            decoration: const InputDecoration(counterText: ''),
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.message('invalidRecordingTitle')
                : null,
            onFieldSubmitted: (_) => submit(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: submit,
        child: Text(context.l10n.saveRecordingName),
      ),
      const SizedBox(height: 10),
      FilledButton.tonal(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
    ],
  );
}
