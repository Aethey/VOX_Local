import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/domain/transcript_text.dart';

void main() {
  test('removes decoder metadata without deleting actual words or numbers', () {
    expect(
      TranscriptText.clean(
        '<|startoftranscript|><|zh|><|transcribe|><|0.00|>能听见我说话吗<|2.82|><|endoftext|>',
      ),
      '能听见我说话吗',
    );
    expect(
      TranscriptText.clean(
        '<|en|>Budget: 3.14 <tag>\n  Next step. <|endoftext|>',
      ),
      'Budget: 3.14 <tag>\nNext step.',
    );
  });
  test('partial markers and marker-only output do not become content', () {
    expect(TranscriptText.clean('继续<|endof'), '继续');
    expect(
      TranscriptText.clean('<|startoftranscript|><|zh|><|0.00|>'),
      isEmpty,
    );
    expect(TranscriptText.clean('  日本語  の会話  '), '日本語 の会話');
  });
}
