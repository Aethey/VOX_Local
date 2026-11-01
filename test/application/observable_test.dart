import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/observable.dart';

void main() {
  test('paused UI subscriber cannot block service cleanup', () async {
    final state = ObservableState(0);
    final sub = state.changes.listen((_) {})..pause();
    await state.close().timeout(const Duration(seconds: 1));
    await sub.cancel();
  });
}
