import 'package:gestionmasso/app/domain/models/user.dart';
import 'package:gestionmasso/app/domain/repositories/authentication_repositoty.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<User> getUserData() {
    return Future.value(User());
  }

  @override
  Future<bool> get insSignedIn {
    return Future.value(true);
  }
}
