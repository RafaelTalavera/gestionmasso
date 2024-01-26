import 'package:gestionmasso/app/domain/models/user.dart';
import 'package:gestionmasso/app/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<User?> getUserData() {
    return Future.value(null);
  }

  @override
  Future<bool> get insSignedIn {
    return Future.value(true);
  }
}
