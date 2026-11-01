import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../application/settings_service.dart';
import '../../domain/failure.dart';
import '../../domain/models.dart';
import '../../infrastructure/chat_provider.dart';
import '../../l10n/localization.dart';
import '../widgets/active_recording_button.dart';
import '../widgets/common.dart';
import '../widgets/labeled_field.dart';
import '../widgets/settings_group.dart';
import '../widgets/sheets.dart';

class ProviderScreen extends ConsumerStatefulWidget {
  const ProviderScreen({super.key});
  @override
  ConsumerState<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends ConsumerState<ProviderScreen> {
  final endpoint = TextEditingController(),
      model = TextEditingController(),
      secret = TextEditingController();
  late final ChatCompletionProvider client;
  String provider = 'deepseek';
  bool busy = false, savedCredential = false, obscure = true;
  String? note;
  List<String> available = [];
  @override
  void initState() {
    super.initState();
    final runtime = ref.read(runtimeProvider);
    client = ChatCompletionProvider(
      diagnostics: runtime.store.appendLog,
      clock: runtime.clock,
    );
    final profile = ref.read(runtimeProvider).settings.value.profile;
    provider = profile?.provider ?? 'deepseek';
    endpoint.text = profile?.endpoint ?? 'https://api.deepseek.com';
    model.text = profile?.model ?? '';
    savedCredential = profile != null;
  }

  ProviderProfile profile({bool catalog = false}) => SettingsService.profileFor(
    provider,
    endpoint.text,
    catalog && model.text.trim().isEmpty ? 'catalog' : model.text,
  );
  Future<void> fetchModels() async {
    setState(() {
      busy = true;
      note = null;
    });
    try {
      final p = profile(catalog: true);
      p.validate();
      final saved = ref.read(runtimeProvider).settings.value.profile;
      final sameEndpoint =
          saved?.endpoint == p.endpoint && saved?.provider == p.provider;
      final key = secret.text.trim().isNotEmpty
          ? secret.text.trim()
          : sameEndpoint && saved != null
          ? await ref
                .read(runtimeProvider)
                .credentials
                .read(saved.credentialRef)
          : null;
      if (key == null || key.isEmpty) {
        throw const FormatException('enterApiKey');
      }
      final list = await client.models(p, key);
      if (!mounted) return;
      setState(() {
        available = list;
        note = list.isEmpty ? 'noProviderModels' : 'modelsFetched';
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          note = e is AppFailure
              ? e.message
              : e is FormatException
              ? e.message
              : 'fetchModelsFailed';
        });
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> save() async {
    setState(() {
      busy = true;
      note = null;
    });
    try {
      final p = profile();
      final service = ref.read(runtimeProvider).settings;
      String? key = secret.text.trim().isEmpty ? null : secret.text.trim();
      final previous = service.value.profile;
      if (key == null &&
          previous != null &&
          previous.endpoint == p.endpoint &&
          previous.provider == p.provider) {
        key = await ref
            .read(runtimeProvider)
            .credentials
            .read(previous.credentialRef);
      }
      await service.saveProfile(p, key);
      secret.clear();
      if (!mounted) return;
      showMessage(context, context.l10n.configurationSaved);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(
          () => note = e is FormatException
              ? e.message
              : 'configurationSaveFailed',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> clear() async {
    final confirmed = await confirmSheet(
      context,
      title: context.l10n.clearProviderTitle,
      message: context.l10n.clearProviderBody,
      confirmLabel: context.l10n.clearProviderConfiguration,
    );
    if (!confirmed || !mounted) return;
    setState(() {
      busy = true;
      note = null;
    });
    try {
      await ref.read(runtimeProvider).settings.clearProfile();
      secret.clear();
      if (!mounted) return;
      showMessage(context, context.l10n.providerConfigurationCleared);
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => note = 'configurationClearFailed');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    client.cancel();
    secret.clear();
    endpoint.dispose();
    model.dispose();
    secret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.providerAndModel)),
    floatingActionButton: const ActiveRecordingButton(),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        const SizedBox(height: 16),
        SettingsGroup(
          children: [
            ChoiceRow<String>(
              icon: Icons.cloud_outlined,
              title: context.l10n.provider,
              selected: provider,
              enabled: !busy,
              options: [
                const ChoiceOption('deepseek', 'DeepSeek'),
                ChoiceOption('compatible', context.l10n.compatibleProvider),
              ],
              onChanged: (v) => setState(() {
                provider = v;
                endpoint.text = v == 'deepseek'
                    ? 'https://api.deepseek.com'
                    : '';
                model.clear();
                secret.clear();
                savedCredential = false;
                available = [];
                note = null;
              }),
            ),
          ],
        ),
        const SizedBox(height: 24),
        LabeledField(
          label: context.l10n.baseUrl,
          help: context.l10n.baseUrlHelp,
          child: TextField(
            controller: endpoint,
            enabled: !busy,
            autocorrect: false,
            keyboardType: TextInputType.url,
          ),
        ),
        const SizedBox(height: 20),
        LabeledField(
          label: context.l10n.apiKey,
          help: savedCredential
              ? context.l10n.savedKeyHelp
              : context.l10n.keyHelp,
          child: TextField(
            controller: secret,
            enabled: !busy,
            obscureText: obscure,
            autocorrect: false,
            enableSuggestions: false,
            autofillHints: const [],
            decoration: InputDecoration(
              suffixIcon: IconButton(
                tooltip: obscure ? context.l10n.showKey : context.l10n.hideKey,
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: busy ? null : fetchModels,
          icon: busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.sync_rounded),
          label: Text(context.l10n.testConnection),
        ),
        const SizedBox(height: 20),
        LabeledField(
          label: context.l10n.modelId,
          help: context.l10n.modelIdHelp,
          child: TextField(
            controller: model,
            enabled: !busy,
            autocorrect: false,
          ),
        ),
        if (available.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: OutlinedButton.icon(
              onPressed: busy
                  ? null
                  : () async {
                      final picked = await showChoiceSheet<String>(
                        context,
                        title: context.l10n.chooseAvailableModel,
                        options: [
                          for (final id in available) ChoiceOption(id, id),
                        ],
                        selected: model.text.trim(),
                      );
                      if (picked != null && mounted) {
                        setState(() => model.text = picked);
                      }
                    },
              icon: const Icon(Icons.expand_more_rounded),
              label: Text(context.l10n.chooseAvailableModel),
            ),
          ),
        if (note != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: StatusNote(
              note == 'modelsFetched'
                  ? context.l10n.modelsFetched(available.length)
                  : context.l10n.message(note!),
            ),
          ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: busy ? null : save,
          child: Text(context.l10n.saveConfiguration),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.providerSaveHelp,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        if (ref.watch(settingsProvider.select((s) => s.profile != null))) ...[
          const SizedBox(height: 24),
          TextButton.icon(
            key: const ValueKey('clear-provider'),
            onPressed: busy ? null : clear,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(context.l10n.clearProviderConfiguration),
          ),
        ],
      ],
    ),
  );
}
