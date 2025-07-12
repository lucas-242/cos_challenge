import 'package:cos_challenge/data/models/user.dart';

abstract interface class StorageService {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}
