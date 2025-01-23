import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String sessionKey = 'session_id';

class SessionService {
  final FlutterSecureStorage _secureStorage;

  SessionService(this._secureStorage);

  save(String sessionId) {
    _secureStorage.write(key: sessionKey, value: sessionId);
  }

  Future<String?> get sessionId async =>
      await _secureStorage.read(key: sessionKey);

  Future<void> delete() async {
    await _secureStorage.delete(key: sessionKey);
  }
}
