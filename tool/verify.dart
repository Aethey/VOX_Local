import 'dart:io';

import 'package:crypto/crypto.dart';

Map<String, String> generated() {
  final result = <String, String>{};
  for (final root in ['lib', 'ios/Runner', 'android/app/src/main/kotlin']) {
    for (final entry in Directory(
      root,
    ).listSync(recursive: true).whereType<File>()) {
      if (entry.path.endsWith('.g.dart') ||
          entry.path.startsWith('lib/l10n/generated/') ||
          entry.path.endsWith('/InfoPlist.strings') ||
          entry.path.endsWith('.freezed.dart') ||
          entry.path.endsWith('Speech.g.swift') ||
          entry.path.endsWith('Speech.g.kt')) {
        result[entry.path] = sha256.convert(entry.readAsBytesSync()).toString();
      }
    }
  }
  return result;
}

Future<void> run(String command, List<String> arguments) async {
  final process = await Process.start(
    command,
    arguments,
    mode: ProcessStartMode.inheritStdio,
  );
  final result = await process.exitCode;
  if (result != 0) exit(result);
}

Future<void> main() async {
  final before = generated();
  await run('dart', ['run', 'pigeon', '--input', 'pigeons/speech.dart']);
  await run('dart', ['run', 'build_runner', 'build']);
  await run('flutter', ['gen-l10n']);
  await run('dart', ['run', 'tool/generate_native_localizations.dart']);
  await run('dart', ['format', 'lib', 'pigeons', 'test', 'tool']);
  final after = generated();
  if (before.length != after.length ||
      before.entries.any((e) => after[e.key] != e.value)) {
    stderr.writeln(
      'Generated code was stale. Review and commit the regenerated files, then run again.',
    );
    exit(1);
  }
  await run('flutter', ['analyze']);
  await run('flutter', ['test']);
}
