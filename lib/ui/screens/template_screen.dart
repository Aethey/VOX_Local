import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../application/session_service.dart';
import '../../domain/models.dart';
import '../../l10n/localization.dart';
import '../widgets/active_recording_button.dart';
import '../widgets/common.dart';
import '../widgets/labeled_field.dart';
import '../widgets/settings_group.dart';

class TemplateScreen extends ConsumerStatefulWidget {
  const TemplateScreen({super.key});
  @override
  ConsumerState<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends ConsumerState<TemplateScreen> {
  final name = TextEditingController(), instruction = TextEditingController();
  AnalysisTemplate? editing;
  late final SessionService recording;
  bool busy = false, ownDictation = false;
  String? error;
  @override
  void initState() {
    super.initState();
    recording = ref.read(runtimeProvider).session;
  }

  @override
  void dispose() {
    if (ownDictation) unawaited(recording.stop());
    name.dispose();
    instruction.dispose();
    super.dispose();
  }

  Future<void> dictate() async {
    if (busy) return;
    setState(() => busy = true);
    try {
      if (ownDictation) {
        await ref.read(sessionProvider.notifier).stop();
        if (!mounted) return;
        if (recording.value.active) return;
        final draft = ref.read(sessionProvider).draft;
        instruction.text =
            '${instruction.text}${instruction.text.isEmpty ? '' : '\n'}$draft';
        setState(() => ownDictation = false);
      } else {
        if (ref.read(sessionProvider).active) {
          showMessage(context, context.l10n.message('finishBeforeDictation'));
          return;
        }
        await ref.read(sessionProvider.notifier).start(dictation: true);
        if (mounted) {
          setState(() => ownDictation = ref.read(sessionProvider).dictating);
        }
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> save() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final service = ref.read(runtimeProvider).settings;
      final template = AnalysisTemplate(
        id:
            editing?.id ??
            'custom-${ref.read(runtimeProvider).clock.now().microsecondsSinceEpoch}',
        name: name.text.trim(),
        instruction: instruction.text.trim(),
        version: (editing?.version ?? 0) + 1,
      );
      await service.saveTemplate(template);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is FormatException ? e.message : 'saveTemplateFailed',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final session = ref.watch(sessionProvider);
    return PopScope(
      canPop: !ownDictation && !busy,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || busy || !ownDictation) return;
        await guardAction(context, dictate);
        if (context.mounted && !ownDictation) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.analysisTemplates)),
        floatingActionButton: const ActiveRecordingButton(),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            SectionTitle(context.l10n.savedTemplates),
            SettingsGroup(
              children: [
                for (final template in [
                  ...AnalysisTemplate.presets,
                  ...settings.customTemplates,
                ])
                  SettingsRow(
                    icon: settings.template.id == template.id
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    title: context.l10n.templateNameFor(template),
                    subtitle: context.l10n.templateRulesFor(template),
                    enabled: !ownDictation,
                    trailing: template.preset
                        ? const SizedBox.shrink()
                        : IconButton(
                            tooltip: context.l10n.editTemplate,
                            onPressed: ownDictation
                                ? null
                                : () => setState(() {
                                    editing = template;
                                    name.text = template.name;
                                    instruction.text = template.instruction;
                                  }),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                    onTap: () => guardAction(
                      context,
                      () => ref
                          .read(settingsProvider.notifier)
                          .update(settings.copy(template: template)),
                      success: context.l10n.selectedTemplate(
                        context.l10n.templateNameFor(template),
                      ),
                    ),
                  ),
              ],
            ),
            SectionTitle(
              editing == null
                  ? context.l10n.customTemplate
                  : context.l10n.editingTemplate(editing!.name),
            ),
            LabeledField(
              label: context.l10n.templateName,
              controller: name,
              maxLength: 60,
              child: TextField(
                controller: name,
                enabled: !busy && !ownDictation,
                maxLength: 60,
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: context.l10n.analysisRules,
              controller: instruction,
              maxLength: 4000,
              child: TextField(
                controller: instruction,
                enabled: !busy && !ownDictation,
                minLines: 5,
                maxLines: 12,
                maxLength: 4000,
                decoration: InputDecoration(
                  hintText: context.l10n.rulesHint,
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (ownDictation)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StatusNote(
                  '${session.draft}${session.partial}'.isEmpty
                      ? context.l10n.listeningForRules
                      : '${session.draft}${session.partial}',
                  icon: Icons.mic_none_rounded,
                ),
              ),
            if (session.error != null && ownDictation)
              StatusNote(context.l10n.message(session.error!)),
            OutlinedButton.icon(
              onPressed: busy ? null : () => guardAction(context, dictate),
              icon: Icon(
                ownDictation ? Icons.stop_rounded : Icons.mic_none_rounded,
              ),
              label: Text(
                ownDictation
                    ? context.l10n.finishDictation
                    : context.l10n.dictateRules,
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: StatusNote(context.l10n.message(error!)),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: busy || ownDictation ? null : save,
              child: Text(context.l10n.saveAndUse),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.templateSaveHelp,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
