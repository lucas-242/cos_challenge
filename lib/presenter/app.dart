import 'package:cos_challenge/core/services/storage/flutter_secure_storage_service_impl.dart';
import 'package:cos_challenge/core/services/storage/storage_service.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository_impl.dart';
import 'package:cos_challenge/presenter/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageService storageService = FlutterSecureStorageServiceImpl();
    final AuthRepository authRepository = AuthRepositoryImpl(storageService);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: SignInScreen(authRepository: authRepository),
    );
  }
}
