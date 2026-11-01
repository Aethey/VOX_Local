import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models.dart';
import '../../domain/speech.dart';
import '../../l10n/localization.dart';
import '../routes.dart';
import '../widgets/common.dart';
import '../widgets/recording_actions.dart';
import '../widgets/settings_group.dart';

class RecordingLibraryScreen extends ConsumerStatefulWidget {
  const RecordingLibraryScreen({super.key});
  @override
  ConsumerState<RecordingLibraryScreen> createState() =>
      _RecordingLibraryScreenState();
}

class _RecordingLibraryScreenState
    extends ConsumerState<RecordingLibraryScreen> {
  final search = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    search.text = ref.read(recordingLibraryProvider).query;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    search.dispose();
    super.dispose();
  }

  Future<void> newRecording() => guardAction(context, () async {
    final session = ref.read(sessionProvider);
    if (session.active) {
      if (session.dictating) throw StateError('finishRecordingFirst');
      if (mounted) RecordRoute(id: session.id).push(context);
      return;
    }
    await ref.read(sessionProvider.notifier).newRecording();
    if (mounted) const RecordRoute().push(context);
  });

  Future<void> open(RecordingSummary record) => guardAction(context, () async {
    await ref.read(sessionProvider.notifier).open(record.id);
    if (mounted) RecordRoute(id: record.id).push(context);
  });

  @override
  Widget build(BuildContext context) {
    final library = ref.watch(recordingLibraryProvider);
    final session = ref.watch(sessionProvider);
    final settings = ref.watch(settingsProvider);
    final models = ref.watch(modelProvider);
    final model = models.firstWhere(
      (model) => model.id == settings.model,
      orElse: () => OfflineModelState(settings.model),
    );
    final active = session.active && !session.dictating;
    final empty = library.records.isEmpty && library.query.isEmpty;
    final colors = Theme.of(context).colorScheme;
    // Only shown while idle; ActiveRecordingButton covers the recording case.
    final newButton = FilledButton.icon(
      onPressed: session.managing ? null : newRecording,
      icon: const Icon(Icons.add_rounded),
      label: Text(context.l10n.newRecording),
    );
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(recordingLibraryProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverList.list(
                    children: [
                      Text(
                        context.l10n.recordings,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      if (model.phase != 'ready') ...[
                        SettingsGroup(
                          children: [
                            SettingsRow(
                              icon: model.busy
                                  ? Icons.hourglass_top_rounded
                                  : model.installed
                                  ? Icons.offline_pin_outlined
                                  : Icons.download_for_offline_outlined,
                              title: model.installed
                                  ? context.l10n.localModelLoading
                                  : context.l10n.offlineModels,
                              subtitle: model.busy
                                  ? model.phase == 'downloading'
                                        ? context.l10n.downloadProgress(
                                            (model.progress * 100).floor(),
                                          )
                                        : context.l10n.preparingOfflineModel
                                  : model.installed
                                  ? context.l10n.modelInstalled
                                  : context.l10n.downloadModelToStart,
                              onTap: () => const ModelRoute().push(context),
                            ),
                            if (model.busy) const LinearProgressIndicator(),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (!empty)
                        TextField(
                          controller: search,
                          decoration: InputDecoration(
                            hintText: context.l10n.searchRecordings,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon:
                                library.query.isEmpty && search.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: context.l10n.clearSearch,
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {
                                      _debounce?.cancel();
                                      search.clear();
                                      ref
                                          .read(
                                            recordingLibraryProvider.notifier,
                                          )
                                          .refresh(query: '');
                                    },
                                  ),
                          ),
                          onChanged: (text) {
                            _debounce?.cancel();
                            _debounce = Timer(
                              const Duration(milliseconds: 250),
                              () {
                                if (mounted) {
                                  ref
                                      .read(recordingLibraryProvider.notifier)
                                      .refresh(query: text);
                                }
                              },
                            );
                          },
                        ),
                      if (!empty) const SizedBox(height: 12),
                      if (session.managing ||
                          library.loading && library.records.isNotEmpty)
                        const LinearProgressIndicator(),
                      if (library.error != null)
                        StatusNote(
                          context.l10n.message(library.error!),
                          action: TextButton(
                            onPressed: () => ref
                                .read(recordingLibraryProvider.notifier)
                                .refresh(),
                            child: Text(context.l10n.retry),
                          ),
                        ),
                    ],
                  ),
                ),
                if (library.loading && library.records.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (library.records.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            empty
                                ? Icons.library_books_outlined
                                : Icons.search_off_rounded,
                            size: 56,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            empty
                                ? context.l10n.noRecordings
                                : context.l10n.noMatchingRecordings,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // While recording, the floating button is the way back.
                          if (empty && !active) newButton,
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: library.records.length,
                    itemBuilder: (context, index) {
                      final record = library.records[index];
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            title: Text(
                              recordingTitle(context, record),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (record.preview.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      record.preview,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      recordingDate(context, record),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    Text(
                                      durationLabel(record.duration),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    if (record.status !=
                                        RecordingStatus.completed)
                                      Text(
                                        record.status ==
                                                RecordingStatus.recording
                                            ? context.l10n.recording
                                            : context.l10n.recordingInterrupted,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: colors.primary),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: RecordingMenu(
                              record: record,
                              canResume: true,
                            ),
                            onTap: session.managing ? null : () => open(record),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
                if (library.hasMore && library.records.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                      child: OutlinedButton(
                        onPressed: library.loading
                            ? null
                            : () => ref
                                  .read(recordingLibraryProvider.notifier)
                                  .loadMore(),
                        child: Text(context.l10n.loadMoreRecordings),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
        if (!empty && !active)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: SizedBox(width: double.infinity, child: newButton),
          ),
      ],
    );
  }
}
