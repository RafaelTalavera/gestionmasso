import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestionmasso/app/domain/either.dart';
import 'package:gestionmasso/app/domain/enums.dart';
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
    return Future.value(
      User(),
    );
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    await Future.delayed(
        const Duration(seconds: 2)); //simula una espera de dos segundos
    if (username != 'test') {
      return Either.left(SignInFailure.notFound);
    }
    if (password != '12345') {
      return Either.left(SignInFailure.unauthorized);
    }

    await _secureStorage.write(
        key: _key, value: '123'); //datos de inicio de sesion simulados

    return Either.right(
      User(),
    );
  }

  @override
  Future<void> singOut() {
    return _secureStorage.delete(key: _key);
  }
}
