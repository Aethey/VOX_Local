import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/model_service.dart';

import '../fakes.dart';

class FailingSpeech extends FakeSpeech {
  bool failLoad = false, failDelete = false;
  @override
  Future<void> load(String id) async {
    if (failLoad) throw StateError('fixture');
  }

  @override
  Future<void> delete(String id) async {
    if (failDelete) throw StateError('fixture');
  }
}

void main() {
  test('recording prevents model mutation', () async {
    final engine = FailingSpeech();
    final store = MemoryStore();
    final service = ModelService(engine, store, FakeClock());
    await expectLater(
      service.prepare('small', sessionActive: true),
      throwsStateError,
    );
    expect(service.readyId, isNull);
    await service.close();
    await engine.dispose();
    await store.close();
  });
  test('failed switch never reports unloaded model ready', () async {
    final engine = FailingSpeech();
    final store = MemoryStore();
    final service = ModelService(engine, store, FakeClock());
    await service.prepare('turbo', sessionActive: false);
    expect(service.readyId, 'turbo');
    engine.failLoad = true;
    await expectLater(
      service.prepare('small', sessionActive: false),
      throwsStateError,
    );
    expect(service.readyId, isNull);
    expect(service.value.any((m) => m.phase == 'ready'), false);
    await service.close();
    await engine.dispose();
    await store.close();
  });
  test('deleting selected model clears readiness', () async {
    final engine = FailingSpeech();
    final store = MemoryStore();
    final service = ModelService(engine, store, FakeClock());
    await service.prepare('small', sessionActive: false);
    await service.deleteModel('small', sessionActive: false);
    expect(service.readyId, isNull);
    expect(service.value.firstWhere((m) => m.id == 'small').installed, false);
    await service.close();
    await engine.dispose();
    await store.close();
  });
  test(
    'failed deletion clears readiness, records diagnostics and allows recovery',
    () async {
      final engine = FailingSpeech();
      final store = MemoryStore();
      final service = ModelService(engine, store, FakeClock());
      await service.prepare('small', sessionActive: false);
      engine.failDelete = true;
      await expectLater(
        service.deleteModel('small', sessionActive: false),
        throwsStateError,
      );
      expect(service.readyId, isNull);
      final model = service.value.firstWhere((model) => model.id == 'small');
      expect(model.phase, 'installed');
      expect(model.error, 'modelDeleteFailed');
      expect(store.entries.single.event, 'model_delete_failed');
      engine.failDelete = false;
      await service.deleteModel('small', sessionActive: false);
      expect(
        service.value.firstWhere((model) => model.id == 'small').installed,
        isFalse,
      );
      await service.close();
      await engine.dispose();
      await store.close();
    },
  );
  test('recording prevents model deletion without losing readiness', () async {
    final engine = FailingSpeech();
    final store = MemoryStore();
    final service = ModelService(engine, store, FakeClock());
    await service.prepare('small', sessionActive: false);
    await expectLater(
      service.deleteModel('small', sessionActive: true),
      throwsStateError,
    );
    expect(service.readyId, 'small');
    await service.close();
    await engine.dispose();
    await store.close();
  });
}
