import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'domain has no UI, infrastructure, platform, or direct I/O dependency',
    () {
      for (final file
          in Directory('lib/domain').listSync().whereType<File>().where(
            (f) =>
                !f.path.endsWith('.g.dart') &&
                !f.path.endsWith('.freezed.dart'),
          )) {
        final imports = RegExp(r'''import\s+['"]([^'"]+)['"]''')
            .allMatches(file.readAsStringSync())
            .map((m) => m[1]!);
        for (final path in imports) {
          expect(
            path,
            isNot(
              matches(
                r'flutter|infrastructure|application|dart:io|dio|sqflite',
              ),
            ),
            reason: file.path,
          );
        }
      }
    },
  );
  test('presentation never accesses native engine or database directly', () {
    for (final file
        in Directory('lib/ui')
            .listSync(recursive: true)
            .whereType<File>()
            .where(
              (f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'),
            )) {
      final content = file.readAsStringSync();
      expect(
        content,
        isNot(contains("infrastructure/local_store")),
        reason: file.path,
      );
      expect(
        content,
        isNot(contains("infrastructure/generated")),
        reason: file.path,
      );
    }
  });
}
