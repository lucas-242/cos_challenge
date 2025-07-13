import 'package:cos_challenge/core/services/storage/storage_service.dart';
import 'package:cos_challenge/data/models/user.dart';
import 'package:cos_challenge/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late final User userMock;
  late final MockStorageService mockStorageService;
  late final AuthRepositoryImpl repository;

  setUpAll(() {
    userMock = User.signIn(email: 'test@test.com', password: 'test123');
    mockStorageService = MockStorageService();
    repository = AuthRepositoryImpl(mockStorageService);
  });

  group('autoLogin', () {
    test('should return a User object on success', () async {
      when(mockStorageService.getUser()).thenAnswer((_) async => userMock);

      final result = await repository.autoLogin();

      expect(result, userMock);
    });

    test('should return null if no user is stored', () async {
      when(mockStorageService.getUser()).thenAnswer((_) async => null);

      final result = await repository.autoLogin();

      expect(result, isNull);
    });

    test('should throw an exception if storage.getUser fails', () async {
      when(mockStorageService.getUser()).thenThrow(Exception('Failed to read'));

      final call = repository.autoLogin;

      expect(call, throwsA(isA<Exception>()));
    });
  });

  group('signIn', () {
    test('should return a User object on success', () async {
      when(
        mockStorageService.saveUser(userMock),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.signIn('test@test.com', 'password');

      expect(result, userMock);
    });

    test('should throw an exception if storage.saveUser fails', () async {
      when(
        mockStorageService.saveUser(userMock),
      ).thenThrow(Exception('Failed to write'));

      final call = repository.signIn;

      expect(() => call('test@test.com', ''), throwsA(isA<Exception>()));
    });
  });

  group('signOut', () {
    test('should call storage.clearUser on success', () async {
      when(
        mockStorageService.clearUser(),
      ).thenAnswer((_) async => Future.value());

      await repository.signOut();

      verify(mockStorageService.clearUser());
    });

    test('should throw an exception if storage.clearUser fails', () async {
      when(
        mockStorageService.clearUser(),
      ).thenThrow(Exception('Failed to delete'));

      final call = repository.signOut;

      expect(call, throwsA(isA<Exception>()));
    });
  });
}
