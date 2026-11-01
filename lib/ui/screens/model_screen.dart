import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/speech.dart';
import '../../l10n/localization.dart';
import '../widgets/active_recording_button.dart';
import '../widgets/common.dart';
import '../widgets/sheets.dart';

class ModelScreen extends ConsumerWidget {
  const ModelScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(modelProvider);
    final active = ref.watch(sessionProvider.select((s) => s.active));
    final busy = models.any((m) => m.busy);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.offlineModels)),
      floatingActionButton: const ActiveRecordingButton(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const SizedBox(height: 12),
          if (active)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: StatusNote(context.l10n.modelActiveNotice),
            ),
          for (final model in models)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ModelCard(model: model, locked: active || busy),
            ),
          const SizedBox(height: 8),
          Text(
            context.l10n.modelAdvice,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends ConsumerWidget {
  const _ModelCard({required this.model, required this.locked});
  final OfflineModelState model;
  final bool locked;

  Future<void> delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmSheet(
      context,
      title: context.l10n.deleteModelTitle(modelDisplayName(model.id)),
      message: context.l10n.deleteModelBody,
      confirmLabel: context.l10n.delete,
    );
    if (confirmed && context.mounted) {
      await guardAction(
        context,
        () => ref.read(modelProvider.notifier).delete(model.id),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final ready = model.phase == 'ready';
    final status = switch (model.phase) {
      'downloading' => context.l10n.downloadProgress(
        (model.progress * 100).floor(),
      ),
      'verifying' => context.l10n.verifyingModel,
      'deleting' => context.l10n.deletingModel,
      'preparing' => context.l10n.preparingModel,
      'ready' => context.l10n.modelReady,
      'installed' => context.l10n.modelInstalled,
      _ => context.l10n.modelMissing,
    };
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: ready ? colors.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(modelDisplayName(model.id), style: text.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        model.id == 'turbo'
                            ? context.l10n.turboDescription
                            : context.l10n.smallDescription,
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Status pill: selected state uses the primary pair, every
                // other phase stays quiet.
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: ready ? colors.primary : colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (model.busy)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: colors.onSecondaryContainer,
                              ),
                            ),
                          ),
                        if (ready)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: colors.onPrimary,
                            ),
                          ),
                        Flexible(
                          child: Text(
                            status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelMedium?.copyWith(
                              color: ready
                                  ? colors.onPrimary
                                  : colors.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (model.busy)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: LinearProgressIndicator(
                  value: model.phase == 'downloading' && model.progress > 0
                      ? model.progress
                      : null,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            if (model.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: StatusNote(context.l10n.message(model.error!)),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: locked || ready
                        ? null
                        : () => guardAction(
                            context,
                            () => ref
                                .read(modelProvider.notifier)
                                .prepare(model.id),
                          ),
                    icon: Icon(
                      model.installed
                          ? Icons.play_arrow_rounded
                          : Icons.download_rounded,
                    ),
                    label: Text(
                      ready
                          ? context.l10n.inUse
                          : model.installed
                          ? context.l10n.prepareAndUse
                          : context.l10n.downloadAndPrepare,
                    ),
                  ),
                ),
                if (model.installed) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: locked ? null : () => delete(context, ref),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.onSurfaceVariant,
                    ),
                    child: Text(context.l10n.deleteModel),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
