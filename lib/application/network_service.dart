import 'dart:async';

import '../domain/ports.dart';
import '../domain/speech.dart';
import 'observable.dart';

class NetworkService extends ObservableState<bool>
    implements ConnectivityProbe {
  NetworkService(SpeechEngine engine) : super(true) {
    _events = engine.events.where((e) => e.kind == 'network').listen((event) {
      final online = event.phase == 'online';
      if (online != value) emit(online);
    });
  }
  late final StreamSubscription<SpeechEvent> _events;
  @override
  bool get available => value;
  @override
  Future<void> close() async {
    await _events.cancel();
    await super.close();
  }
}
