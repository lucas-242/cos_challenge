import 'package:cos_challenge/core/services/storage/flutter_secure_storage_service_impl.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository_impl.dart';
import 'package:cos_challenge/presenter/auth/auth_controller.dart';
import 'package:cos_challenge/presenter/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = FlutterSecureStorageServiceImpl(
      FlutterSecureStorage(),
    );
    final authRepository = AuthRepositoryImpl(storageService);
    final authController = AuthController(authRepository: authRepository);

    return MaterialApp(
      title: 'Cos Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: SignInScreen(
        authRepository: authRepository,
        controller: authController,
      ),
    );
  }
}
