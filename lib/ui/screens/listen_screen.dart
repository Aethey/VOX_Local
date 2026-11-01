import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../domain/models.dart';
import '../../domain/speech.dart';
import '../../l10n/localization.dart';
import '../routes.dart';
import '../widgets/common.dart';
import '../widgets/recording_actions.dart';
import '../widgets/recording_activity.dart';

class ListenScreen extends ConsumerStatefulWidget {
  const ListenScreen({super.key});
  @override
  ConsumerState<ListenScreen> createState() => _ListenScreenState();
}

class _ListenScreenState extends ConsumerState<ListenScreen> {
  final _scroll = ScrollController();
  bool _followTail = true;
  bool _initialScroll = true;
  bool _userScrolling = false;
  int _followRequest = 0;

  void _followLatest({bool animate = true}) {
    _userScrolling = false;
    final request = ++_followRequest;
    bool current() =>
        mounted &&
        _scroll.hasClients &&
        _followTail &&
        request == _followRequest;
    // Variable-height slivers refine their extent after laying out the new end.
    // Correct that estimate on the next frame, without animating through history.
    void correctExtent() {
      if (!current()) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (current() && _scroll.position.extentAfter > 1) correctExtent();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!current()) return;
      final target = _scroll.position.maxScrollExtent;
      if (!animate ||
          MediaQuery.disableAnimationsOf(context) ||
          target - _scroll.offset > _scroll.position.viewportDimension) {
        correctExtent();
      } else {
        await _scroll.animateTo(
          target,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
        if (current() && _scroll.position.extentAfter > 1) correctExtent();
      }
    });
  }

  bool _trackScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _userScrolling = true;
      if (_followTail) setState(() => _followTail = false);
    } else if (notification is ScrollEndNotification && _userScrolling) {
      _userScrolling = false;
      final following = notification.metrics.extentAfter < 72;
      if (_followTail != following) setState(() => _followTail = following);
    }
    return false;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionProvider);
    ref.listen(sessionProvider, (previous, next) {
      if (previous?.id != next.id) _followTail = true;
      if (previous?.segments.length != next.segments.length ||
          previous?.partial != next.partial) {
        _followLatest();
      }
    });
    final models = ref.watch(modelProvider);
    final selected = ref.watch(settingsProvider.select((s) => s.model));
    final selectedModel = models.firstWhere(
      (model) => model.id == selected,
      orElse: () => OfflineModelState(selected),
    );
    final ready = selectedModel.phase == 'ready';
    final busy = models.any((m) => m.busy);
    final canStop = state.active || state.phase == SessionPhase.interrupted;
    final transitional =
        state.phase == SessionPhase.preparing ||
        state.phase == SessionPhase.finalizing;
    final recording = state.phase == SessionPhase.recording;
    final hasText = state.segments.isNotEmpty;
    final readOnly = state.record != null && !state.active;
    Future<void> createNew() => guardAction(context, () async {
      await ref.read(sessionProvider.notifier).newRecording();
      if (context.mounted) const RecordRoute().go(context);
    });
    final modelName = modelDisplayName(selected);
    final actionLabel = switch (state.phase) {
      SessionPhase.preparing => context.l10n.openingMic,
      SessionPhase.finalizing => context.l10n.finalizingRecording,
      SessionPhase.recording => context.l10n.stopRecording,
      SessionPhase.interrupted => context.l10n.stopAndKeep,
      _ =>
        busy
            ? context.l10n.preparingOfflineModel
            : !ready
            ? selectedModel.installed
                  ? context.l10n.prepareAndUse
                  : context.l10n.chooseDownloadModel
            : hasText
            ? context.l10n.startNewRecording
            : context.l10n.startRecording,
    };
    if (_initialScroll && hasText) {
      _initialScroll = false;
      if (state.active) _followLatest(animate: false);
    }
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _trackScroll,
            child: CustomScrollView(
              key: const ValueKey('transcript-scroll'),
              controller: _scroll,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  sliver: SliverList.list(
                    children: [
                      if (state.record?.status == RecordingStatus.interrupted &&
                          !state.active)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: StatusNote(
                            context.l10n.recoveredRecordingNotice,
                          ),
                        ),
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: StatusNote(context.l10n.message(state.error!)),
                        ),
                      if (hasText)
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              context.l10n.transcript,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              context.l10n.segmentCount(state.segments.length),
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: state.segments.length,
                    itemBuilder: (context, index) {
                      final segment = state.segments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 48,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  durationLabel(segment.start),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                segment.text,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(height: 1.65),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (state.partial.isNotEmpty && !state.dictating)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(68, 0, 20, 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.phase == SessionPhase.finalizing
                                ? context.l10n.finalizingRecording
                                : context.l10n.recognitionPreview,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colors.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.partial,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  height: 1.65,
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!hasText && state.partial.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (readOnly) ...[
                            Icon(
                              Icons.description_outlined,
                              size: 48,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.l10n.noConfirmedTranscript,
                              textAlign: TextAlign.center,
                            ),
                          ] else if (!state.active) ...[
                            Image.asset(
                              'assets/illustrations/listening.png',
                              width: 220,
                              height: 146,
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                              filterQuality: FilterQuality.medium,
                            ),
                            const SizedBox(height: 24),
                            const ConversationFlow(),
                          ] else
                            Icon(
                              Icons.mic_none_rounded,
                              size: 48,
                              color: colors.onSurfaceVariant,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Container(
          key: const ValueKey('recording-dock'),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(top: BorderSide(color: colors.outlineVariant)),
          ),
          child: readOnly
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.savedRecordingDuration(
                          durationLabel(state.record!.duration),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.copyTranscript,
                      onPressed: hasText && !state.managing
                          ? () => copyRecording(context, ref, state.record!)
                          : null,
                      icon: const Icon(Icons.copy_all_outlined),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: context.l10n.newRecording,
                      onPressed: state.managing ? null : createNew,
                      style: IconButton.styleFrom(
                        fixedSize: const Size(48, 48),
                      ),
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: recording
                          ? RecordingActivity(
                              startedAt:
                                  state.startedAt ??
                                  ref.read(runtimeProvider).clock.now(),
                            )
                          : transitional
                          ? Text(
                              actionLabel,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          : TextButton.icon(
                              onPressed: () => const ModelRoute().push(context),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              ),
                              icon: Icon(
                                ready
                                    ? Icons.offline_pin_outlined
                                    : Icons.download_for_offline_outlined,
                                size: 18,
                              ),
                              label: Text(
                                modelName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                    ),
                    if (!_followTail && hasText)
                      IconButton(
                        tooltip: context.l10n.latestTranscript,
                        onPressed: () {
                          setState(() => _followTail = true);
                          _followLatest();
                        },
                        icon: const Icon(Icons.vertical_align_bottom_rounded),
                      ),
                    if (recording)
                      IconButton(
                        tooltip: modelName,
                        onPressed: () => const ModelRoute().push(context),
                        icon: const Icon(Icons.offline_pin_outlined, size: 20),
                      ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      key: const ValueKey('record-action'),
                      tooltip: actionLabel,
                      onPressed: transitional || busy && !canStop
                          ? null
                          : !ready && !canStop
                          ? () => const ModelRoute().push(context)
                          : () => guardAction(
                              context,
                              () => canStop
                                  ? ref.read(sessionProvider.notifier).stop()
                                  : ref.read(sessionProvider.notifier).start(),
                            ),
                      style: IconButton.styleFrom(
                        fixedSize: const Size(48, 48),
                        backgroundColor: canStop ? colors.errorContainer : null,
                        foregroundColor: canStop
                            ? colors.onErrorContainer
                            : null,
                      ),
                      icon: transitional || busy && !canStop
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              canStop
                                  ? Icons.stop_rounded
                                  : !ready
                                  ? Icons.download_rounded
                                  : Icons.mic_none_rounded,
                              size: 26,
                            ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
