import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/ports.dart';

class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now().toUtc();
}

class SystemRandom implements RandomSource {
  final _random = Random.secure();
  @override
  double nextDouble() => _random.nextDouble();
}

class SecureCredentials implements CredentialStore {
  const SecureCredentials([this.storage = const FlutterSecureStorage()]);
  final FlutterSecureStorage storage;
  @override
  Future<String?> read(String reference) => storage.read(key: reference);
  @override
  Future<void> write(String reference, String value) =>
      storage.write(key: reference, value: value);
  @override
  Future<void> delete(String reference) => storage.delete(key: reference);
}
