import 'package:flutter/material.dart';

import '../../l10n/localization.dart';
import '../routes.dart';
import '../widgets/active_recording_button.dart';
import 'recording_library_screen.dart';
import 'settings_screen.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({required this.tab, super.key});
  final int tab;
  @override
  Widget build(BuildContext context) {
    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.library_books_outlined),
        label: context.l10n.recordings,
      ),
      NavigationDestination(
        icon: const Icon(Icons.tune_rounded),
        label: context.l10n.settings,
      ),
    ];
    final content = [
      const RecordingLibraryScreen(),
      const SettingsScreen(),
    ][tab.clamp(0, 1)];
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.spa_outlined, size: 22),
                SizedBox(width: 9),
                Text(
                  'Vox Local',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          floatingActionButton: const ActiveRecordingButton(),
          body: SafeArea(
            top: false,
            child: Row(
              children: [
                if (wide)
                  NavigationRail(
                    selectedIndex: tab.clamp(0, 1),
                    onDestinationSelected: (i) =>
                        WorkspaceRoute(tab: i).go(context),
                    labelType: NavigationRailLabelType.all,
                    destinations: destinations
                        .map(
                          (d) => NavigationRailDestination(
                            icon: d.icon,
                            label: Text(d.label),
                          ),
                        )
                        .toList(),
                  ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  height: 64,
                  selectedIndex: tab.clamp(0, 1),
                  onDestinationSelected: (i) =>
                      WorkspaceRoute(tab: i).go(context),
                  destinations: destinations,
                ),
        );
      },
    );
  }
}
