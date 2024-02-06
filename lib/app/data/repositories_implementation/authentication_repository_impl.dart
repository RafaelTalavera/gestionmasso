import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(this._secureStorage);
  final FlutterSecureStorage _secureStorage;

  @override
  Future<User?> getUserData() async {
    try {
      final response = await http
          .post(Uri.parse('http://10.0.2.2:8080/api/auth/authenticate'));

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return User.fromMap(userData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
      String username, String password) async {
    try {
      final requestBody = {
        'username': username,
        'password': password,
      };

      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8080/api/auth/authenticate'), // Use 10.0.2.2 for Android emulator
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Verificar si 'token' está presente y no es nulo
        final token = responseData['jwt'] as String?;
        if (token != null) {
          await _secureStorage.write(key: _key, value: token);
          return Either.right(User(token: token));
        } else {
          return Either.left(SignInFailure.unknown);
        }
      } else if (response.statusCode == 404) {
        return Either.left(SignInFailure.notFound);
      } else {
        return Either.left(SignInFailure.unknown);
      }
    } catch (e) {
      return Either.left(SignInFailure.unknown);
    }
  }

  @override
  Future<void> singOut() {
    return _secureStorage.delete(key: _key);
  }
}
