import 'package:gestionmasso/app/domain/models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get insSignedIn;
  Future<User?> getUserData();
}
