import 'package:cos_challenge/models/user.dart';
import 'package:flutter/material.dart';

class AuthController {
  final ValueNotifier<String?> error = ValueNotifier(null);
  final isLoading = ValueNotifier(false);

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    error.value = null;

    try {
      if (email.isEmpty || password.isEmpty) {
        error.value = 'E-mail and password can\'t be empty';
        return;
      }
      final user = User.signIn(email: email, password: password);
      //TODO add repository
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      error.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
