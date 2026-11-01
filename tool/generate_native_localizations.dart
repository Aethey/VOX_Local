import 'dart:convert';
import 'dart:io';

/// Keep the iOS permission prompt in the same translation source as Flutter.
void main() {
  for (final locale in ['en', 'ja', 'zh']) {
    final arb = jsonDecode(
      File('lib/l10n/app_$locale.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final region = locale == 'zh' ? 'zh-Hans' : locale;
    final folder = Directory('ios/Runner/$region.lproj')
      ..createSync(recursive: true);
    File('${folder.path}/InfoPlist.strings').writeAsStringSync(
      '// Generated from lib/l10n/app_$locale.arb. Do not edit.\n'
      '"NSMicrophoneUsageDescription" = ${jsonEncode(arb['microphonePermission'])};\n',
    );
    if (locale == 'en') {
      final plist = File('ios/Runner/Info.plist');
      final prompt = (arb['microphonePermission'] as String)
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;');
      plist.writeAsStringSync(
        plist.readAsStringSync().replaceFirst(
          RegExp(
            r'(<key>NSMicrophoneUsageDescription</key>\s*<string>)[\s\S]*?(</string>)',
          ),
          '<key>NSMicrophoneUsageDescription</key>\n\t<string>$prompt</string>',
        ),
      );
    }
  }
}
