import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../l10n/localization.dart';
import '../routes.dart';
import 'common.dart';

/// Floating shortcut back to a recording that is still being captured.
/// Mounted as the floatingActionButton of every screen except the record
/// screen itself; renders nothing when no conversation is being recorded.
class ActiveRecordingButton extends ConsumerStatefulWidget {
  const ActiveRecordingButton({super.key});

  @override
  ConsumerState<ActiveRecordingButton> createState() =>
      _ActiveRecordingButtonState();
}

class _ActiveRecordingButtonState extends ConsumerState<ActiveRecordingButton> {
  Timer? _timer;

  void _sync(bool active) {
    if (active && _timer == null) {
      // Elapsed time updates once a second; hidden routes do not rebuild.
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && TickerMode.valuesOf(context).enabled) setState(() {});
      });
    } else if (!active && _timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final capture = ref.watch(
      sessionProvider.select(
        (s) => (
          active: s.active && !s.dictating,
          id: s.id,
          startedAt: s.startedAt,
        ),
      ),
    );
    _sync(capture.active);
    if (!capture.active || capture.id == null) return const SizedBox.shrink();
    final started = capture.startedAt;
    final elapsed = started == null
        ? null
        : ref.read(runtimeProvider).clock.now().difference(started);
    final label = elapsed == null
        ? context.l10n.recording
        : '${context.l10n.recording} · ${durationLabel((elapsed.isNegative ? 0 : elapsed.inSeconds).toDouble())}';
    return FloatingActionButton.extended(
      key: const ValueKey('active-recording'),
      heroTag: null,
      tooltip: context.l10n.returnToRecording,
      onPressed: () => RecordRoute(id: capture.id).go(context),
      icon: const Icon(Icons.graphic_eq_rounded),
      label: Text(label),
    );
  }
}
