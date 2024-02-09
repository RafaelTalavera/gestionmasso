import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'authToken';

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
}
