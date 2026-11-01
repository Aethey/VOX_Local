import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../l10n/localization.dart';
import 'common.dart';

/// The clock rebuilds once a second; only the meter repaints on animation frames.
class RecordingActivity extends ConsumerStatefulWidget {
  const RecordingActivity({required this.startedAt, super.key});
  final DateTime startedAt;

  @override
  ConsumerState<RecordingActivity> createState() => _RecordingActivityState();
}

class _RecordingActivityState extends ConsumerState<RecordingActivity>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && TickerMode.valuesOf(context).enabled) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) ||
        !TickerMode.valuesOf(context).enabled) {
      _pulse.stop();
      _pulse.value = .5;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = ref
        .read(runtimeProvider)
        .clock
        .now()
        .difference(widget.startedAt);
    final label = durationLabel(math.max(0, elapsed.inSeconds).toDouble());
    return Semantics(
      label: '${context.l10n.recording} $label',
      child: Row(
        children: [
          _LiveMeter(pulse: _pulse),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              key: const ValueKey('recording-duration'),
              maxLines: 1,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveMeter extends ConsumerWidget {
  const _LiveMeter({required this.pulse});
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level =
        ref.watch(levelProvider).value ??
        ref.read(runtimeProvider).session.level.value;
    return Semantics(
      label: context.l10n.microphoneLevel,
      child: RepaintBoundary(
        key: const ValueKey('recording-waveform'),
        child: SizedBox(
          width: 58,
          height: 28,
          child: CustomPaint(
            painter: _WavePainter(
              level: level,
              pulse: pulse,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({required this.level, required this.pulse, required this.color})
    : super(repaint: pulse);
  final double level;
  final Animation<double> pulse;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final phase = pulse.value * math.pi * 2;
    final paint = Paint()..color = color;
    // The dot signals recording even in silence; bars reflect actual input level.
    canvas.drawCircle(
      Offset(4, size.height / 2),
      2.5 + .8 * math.sin(phase),
      paint,
    );
    paint
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 7; i++) {
      final envelope = .45 + .55 * math.sin(phase + i * .8).abs();
      final height = 3 + level.clamp(0, 1) * 22 * envelope;
      final x = 16.0 + i * 6;
      canvas.drawLine(
        Offset(x, (size.height - height) / 2),
        Offset(x, (size.height + height) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.level != level ||
      oldDelegate.color != color ||
      oldDelegate.pulse != pulse;
}
