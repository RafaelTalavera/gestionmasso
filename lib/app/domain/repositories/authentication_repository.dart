import '../either.dart';
import '../enums.dart';
import '../models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;
  Future<User?> getUserData();
  Future<void> singOut();

  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  );
}
