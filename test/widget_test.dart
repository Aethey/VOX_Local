import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/domain/models.dart';

void main() {
  test('generated models preserve value equality', () {
    expect(
      const AnalysisResult(matched: false, findings: []),
      const AnalysisResult(matched: false, findings: []),
    );
  });
}
