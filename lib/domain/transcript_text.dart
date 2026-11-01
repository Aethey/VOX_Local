import 'models.dart';

/// Whisper decoder markers are metadata, not conversation content.
abstract final class TranscriptText {
  static final _tokens = RegExp(r'<\|[^<>\r\n]*\|>');
  static final _unfinishedToken = RegExp(r'<\|[a-zA-Z0-9_.:-]*\|?$');

  static String clean(String text) => text
      .replaceAll(_tokens, '')
      .replaceAll(_unfinishedToken, '')
      .replaceAll('\r\n', '\n')
      .replaceAll(RegExp(r'[\t ]+'), ' ')
      .replaceAll(RegExp(r' *\n *'), '\n')
      .trim();

  static TranscriptSegment segment(TranscriptSegment value) =>
      value.copyWith(text: clean(value.text));

  static AnalysisJob job(AnalysisJob value) => value.copyWith(
    segments: value.segments.map(segment).toList(growable: false),
    context: clean(value.context),
  );
}
