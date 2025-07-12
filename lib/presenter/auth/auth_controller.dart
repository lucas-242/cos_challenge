import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthController {
  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final AuthRepository _authRepository;

  Future<bool> autoLogin() async {
    final user = await _authRepository.autoLogin();
    if (user != null) {
      return true;
    }

    return false;
  }

  Future<bool> signIn(String email, String password) async {
    isLoading.value = true;
    error.value = null;

    try {
      if (email.isEmpty || password.isEmpty) {
        error.value = 'E-mail and password can\'t be empty';
        return false;
      }
      await _authRepository.signIn(email, password);
      return true;
    } catch (e) {
      error.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }

    return false;
  }
}
