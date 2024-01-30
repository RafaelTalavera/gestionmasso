import 'package:gestionmasso/app/domain/either.dart';
import 'package:gestionmasso/app/domain/enums.dart';
import 'package:gestionmasso/app/domain/models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;
  Future<User?> getUserData();
  Future<void> singOut();

  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  );
}
