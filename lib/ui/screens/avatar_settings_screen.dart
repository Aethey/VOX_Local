import 'package:flutter/material.dart';

enum AvatarCharacter {
  hiyori('百瀬ひより', 'assets/avatar/hiyori/', 'Avatar.model3.json', 1.85, -0.6),
  wanko(
    'わんころもち',
    'assets/wanko_ja/runtime/',
    'VoxWanko.model3.json',
    1.9,
    0.56,
  );

  const AvatarCharacter(
    this.label,
    this.assetDirectory,
    this.modelFile,
    this.scale,
    this.alignmentY,
  );

  final String label;
  final String assetDirectory;
  final String modelFile;
  final double scale;
  final double alignmentY;
}

class AvatarSettingsScreen extends StatelessWidget {
  const AvatarSettingsScreen({required this.selected, super.key});

  final AvatarCharacter selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('アバター設定'),
        backgroundColor: colors.surface,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: RadioGroup<AvatarCharacter>(
              groupValue: selected,
              onChanged: (character) {
                if (character != null) Navigator.of(context).pop(character);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  for (final character in AvatarCharacter.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: character == selected
                            ? colors.primaryContainer
                            : colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: RadioListTile<AvatarCharacter>(
                          value: character,
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          secondary: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.asset(
                              'assets/avatar/previews/${character.name}.webp',
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                              excludeFromSemantics: true,
                            ),
                          ),
                          title: Text(
                            character.label,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
