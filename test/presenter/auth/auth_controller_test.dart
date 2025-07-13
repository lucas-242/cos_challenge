import 'package:cos_challenge/data/models/user.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository.dart';
import 'package:cos_challenge/presenter/auth/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_controller_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late AuthController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    controller = AuthController(authRepository: mockAuthRepository);
  });

  group('autoLogin', () {
    test('should return true if autoLogin is successful', () async {
      final user = User.view(email: 'test@test.com');
      when(mockAuthRepository.autoLogin()).thenAnswer((_) async => user);

      final result = await controller.autoLogin();

      expect(result, true);
    });

    test('should return false if autoLogin fails', () async {
      when(mockAuthRepository.autoLogin()).thenAnswer((_) async => null);

      final result = await controller.autoLogin();

      expect(result, false);
    });
  });

  group('signIn', () {
    const email = 'test@test.com';
    const password = 'password';
    final user = User.view(email: email);

    test('should return true if signIn is successful', () async {
      when(
        mockAuthRepository.signIn(email, password),
      ).thenAnswer((_) async => user);

      final result = await controller.signIn(email, password);

      expect(result, true);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, isNull);
    });

    test('should return false and set error if email is empty', () async {
      final result = await controller.signIn('', password);

      expect(result, false);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, 'E-mail and password can\'t be empty');
    });

    test('should return false and set error if password is empty', () async {
      final result = await controller.signIn(email, '');

      expect(result, false);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, 'E-mail and password can\'t be empty');
    });

    test(
      'should return false and set error if signIn throws an exception',
      () async {
        when(
          mockAuthRepository.signIn(email, password),
        ).thenThrow(Exception('Sign in failed'));

        final result = await controller.signIn(email, password);

        expect(result, false);
        expect(controller.isLoading.value, false);
        expect(
          controller.error.value,
          'Unexpected error: Exception: Sign in failed',
        );
      },
    );
  });

  group('dispose', () {
    test('should dispose isLoading and error ValueNotifiers', () {
      final isLoadingNotifier = controller.isLoading;
      final errorNotifier = controller.error;

      controller.dispose();

      expect(
        () => isLoadingNotifier.addListener(() {}),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => errorNotifier.addListener(() {}),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
