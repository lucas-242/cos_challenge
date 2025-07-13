import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/data/repositories/vehicle/vehicle_repository_impl.dart';
import 'package:cos_challenge/presenter/auth/auth_controller.dart';
import 'package:cos_challenge/presenter/home/home_controller.dart';
import 'package:cos_challenge/presenter/home/home_screen.dart';
import 'package:cos_challenge/shared/utils/cos_challenge.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.authRepository,
    required this.controller,
  });

  final AuthRepository authRepository;
  final AuthController controller;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _controller = widget.controller;

  @override
  void initState() {
    super.initState();
    _autoLogin();
    _listenError();
  }

  void _autoLogin() => _controller.autoLogin().then(_navigateToHome);

  void _navigateToHome(bool isLoggedIn) {
    if (isLoggedIn && mounted) {
      final homeController = HomeController(
        VehicleRepositoryImpl(CosChallenge.httpClient),
        widget.authRepository,
        CosChallenge.vinLength,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            authRepository: widget.authRepository,
            controller: homeController,
          ),
        ),
      );
    }
  }

  void _listenError() {
    _controller.error.addListener(() {
      final error = _controller.error.value;
      if (error == null) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _controller.isLoading,
              builder: (context, isLoading, _) {
                return ElevatedButton(
                  onPressed: _onSignIn,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign in'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSignIn() => _controller
      .signIn(_emailController.text, _passwordController.text)
      .then(_navigateToHome);
}
