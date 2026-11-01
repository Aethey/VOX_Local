import 'models.dart';
import 'transcript_text.dart';

/// Idempotence is based on audio coverage and sequence, never on spoken words.
abstract final class TranscriptTimeline {
  static int contiguousSequence(Iterable<TranscriptSegment> segments) {
    var expected = 1;
    for (final segment in segments) {
      if (segment.sequence != expected) break;
      expected++;
    }
    return expected - 1;
  }

  static bool valid(TranscriptSegment segment) =>
      segment.start.isFinite &&
      segment.end.isFinite &&
      segment.start >= 0 &&
      segment.end > segment.start;

  static bool follows(TranscriptSegment segment, TranscriptSegment previous) =>
      segment.sequence > previous.sequence &&
      segment.start + 0.0001 >= previous.end &&
      segment.end > previous.end;

  static List<TranscriptSegment> additions(
    List<TranscriptSegment> existing,
    Iterable<TranscriptSegment> incoming,
  ) {
    final accepted = <TranscriptSegment>[];
    var previous = existing.lastOrNull;
    final ordered = incoming.toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    for (final raw in ordered) {
      final segment = TranscriptText.segment(raw);
      if (segment.text.isEmpty ||
          !valid(segment) ||
          segment.sequence <= 0 ||
          previous != null && !follows(segment, previous)) {
        continue;
      }
      accepted.add(segment);
      previous = segment;
    }
    return accepted;
  }
}
