import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestionmasso/app/domain/models/user.dart';
import 'package:gestionmasso/app/domain/repositories/authentication_repository.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FlutterSecureStorage _secureStorage;

  AuthenticationRepositoryImpl(
    this._secureStorage,
  );

  @override
  Future<User?> getUserData() {
    return Future.value(null);
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }
}
