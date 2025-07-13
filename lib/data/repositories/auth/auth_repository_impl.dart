import 'package:cos_challenge/core/services/storage/storage_service.dart';
import 'package:cos_challenge/data/models/user.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(StorageService storageService)
    : _storageService = storageService;

  final StorageService _storageService;

  @override
  Future<User?> autoLogin() async {
    final user = await _storageService.getUser();
    if (user == null) {
      return null;
    }

    return user;
  }

  @override
  Future<User> signIn(String email, String password) async {
    final user = User.view(email: email);

    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<void> signOut() => _storageService.clearUser();
}
