import 'dart:async';

class ObservableState<T> {
  ObservableState(this._value);
  T _value;
  T get value => _value;
  final _controller = StreamController<T>.broadcast(sync: true);
  Stream<T> get changes => _controller.stream;
  void emit(T next) {
    _value = next;
    if (!_controller.isClosed) _controller.add(next);
  }

  Future<void> close() async {
    // Hidden routes may pause listeners. Resource cleanup must not wait for them.
    unawaited(_controller.close());
  }
}
