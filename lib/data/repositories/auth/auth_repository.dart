import 'package:cos_challenge/data/models/user.dart';

abstract interface class AuthRepository {
  Future<User?> autoLogin();
  Future<User> signIn(String email, String password);
}
