import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/network_service.dart';
import 'package:vox_local/domain/analysis.dart';
import 'package:vox_local/domain/ports.dart';
import 'package:vox_local/domain/speech.dart';

import '../fakes.dart';

class OfflineProbe implements ConnectivityProbe {
  @override
  bool available = false;
}

void main() {
  test('offline does not claim task or consume attempts', () async {
    final store = MemoryStore();
    addTearDown(store.close);
    store.queue['job'] = job();
    final keys = FakeCredentials()
      ..values[profile.credentialRef] = 'synthetic-fixture';
    final provider = FakeProvider();
    final network = OfflineProbe();
    final worker = AnalysisWorker(
      store: store,
      credentials: keys,
      provider: provider,
      clock: FakeClock(),
      random: FixedRandom(),
      connectivity: network,
    );
    await worker.tick();
    expect(provider.calls, 0);
    expect(store.queue['job']!.attempts, 0);
    network.available = true;
    await worker.tick();
    expect(provider.calls, 1);
  });
  test('native connectivity changes are isolated and deduplicated', () async {
    final engine = FakeSpeech();
    final network = NetworkService(engine);
    var changes = 0;
    final sub = network.changes.listen((_) {
      changes++;
    });
    engine.source.add(const SpeechEvent('network', phase: 'offline'));
    engine.source.add(const SpeechEvent('network', phase: 'offline'));
    expect(network.available, false);
    expect(changes, 1);
    engine.source.add(const SpeechEvent('network', phase: 'online'));
    expect(network.available, true);
    expect(changes, 2);
    await sub.cancel();
    await network.close();
    await engine.dispose();
  });
}
