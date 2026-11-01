import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../l10n/localization.dart';
import '../widgets/common.dart';
import '../widgets/recording_actions.dart';
import 'analysis_screen.dart';
import 'listen_screen.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({this.id, super.key});
  final String? id;
  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  late Future<void> loading;
  @override
  void initState() {
    super.initState();
    loading = Future<void>.microtask(open);
  }

  @override
  void didUpdateWidget(covariant RecordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) loading = Future<void>.microtask(open);
  }

  Future<void> open() async {
    if (widget.id != null) {
      await ref.read(sessionProvider.notifier).open(widget.id!);
    } else if (ref.read(sessionProvider).id != null) {
      await ref.read(sessionProvider.notifier).newRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final record = session.record;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            record == null
                ? context.l10n.newRecording
                : recordingTitle(context, record),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            if (record != null)
              RecordingMenu(
                record: record,
                onDeleted: () {
                  if (mounted) Navigator.of(context).pop();
                },
              ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.transcriptTab),
              Tab(text: context.l10n.analysis),
            ],
          ),
        ),
        body: SafeArea(
          top: false,
          child: FutureBuilder<void>(
            future: loading,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: StatusNote(
                      context.l10n.message(
                        snapshot.error is FormatException
                            ? (snapshot.error as FormatException).message
                            : snapshot.error is StateError
                            ? (snapshot.error as StateError).message
                            : 'recordingOpenFailed',
                      ),
                      action: TextButton(
                        onPressed: () => setState(() => loading = open()),
                        child: Text(context.l10n.retry),
                      ),
                    ),
                  ),
                );
              }
              return const TabBarView(
                children: [ListenScreen(), AnalysisScreen()],
              );
            },
          ),
        ),
      ),
    );
  }
}
