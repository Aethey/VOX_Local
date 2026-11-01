import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/models.dart';
import '../domain/ports.dart';
import 'observable.dart';

part 'recording_library.freezed.dart';

@freezed
abstract class RecordingLibraryState with _$RecordingLibraryState {
  const factory RecordingLibraryState({
    @Default([]) List<RecordingSummary> records,
    @Default('') String query,
    @Default(false) bool loading,
    @Default(true) bool hasMore,
    String? error,
  }) = _RecordingLibraryState;
}

class RecordingLibrary extends ObservableState<RecordingLibraryState> {
  RecordingLibrary(this.store) : super(const RecordingLibraryState()) {
    _changes = store.recordingChanges.listen((_) => unawaited(refresh()));
    unawaited(refresh());
  }
  final LocalStore store;
  late final StreamSubscription<void> _changes;
  int _generation = 0;
  bool _closed = false;

  Future<void> refresh({String? query}) async {
    final generation = ++_generation;
    final search = query ?? value.query;
    final limit = search != value.query || value.records.length < 40
        ? 40
        : value.records.length;
    emit(value.copyWith(query: search, loading: true, error: null));
    try {
      final records = await store.recordings(limit: limit + 1, query: search);
      if (_closed || generation != _generation) return;
      emit(
        RecordingLibraryState(
          records: records.take(limit).toList(),
          query: search,
          hasMore: records.length > limit,
        ),
      );
    } catch (_) {
      if (!_closed && generation == _generation) {
        emit(value.copyWith(loading: false, error: 'recordingListFailed'));
      }
    }
  }

  Future<void> loadMore() async {
    if (value.loading || !value.hasMore) return;
    final generation = ++_generation;
    final before = value;
    emit(before.copyWith(loading: true, error: null));
    try {
      final next = await store.recordings(
        limit: 41,
        offset: before.records.length,
        query: before.query,
      );
      if (_closed || generation != _generation) return;
      emit(
        before.copyWith(
          records: [...before.records, ...next.take(40)],
          loading: false,
          hasMore: next.length > 40,
        ),
      );
    } catch (_) {
      if (!_closed && generation == _generation) {
        emit(value.copyWith(loading: false, error: 'recordingListFailed'));
      }
    }
  }

  @override
  Future<void> close() async {
    _closed = true;
    _generation++;
    await _changes.cancel();
    await super.close();
  }
}
