import 'dart:convert';

import 'package:cos_challenge/core/constants/storage_keys.dart';
import 'package:cos_challenge/core/services/storage/flutter_secure_storage_service_impl.dart';
import 'package:cos_challenge/data/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flutter_secure_storage_service_impl_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late FlutterSecureStorageServiceImpl service;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    service = FlutterSecureStorageServiceImpl(mockFlutterSecureStorage);
  });

  group('saveUser', () {
    final user = User.view(email: 'test@test.com');
    final userJson = jsonEncode(user.toJson());

    test('should call storage.write with correct values on success', () async {
      when(
        mockFlutterSecureStorage.write(key: StorageKeys.user, value: userJson),
      ).thenAnswer((_) async => Future.value());

      await service.saveUser(user);

      verify(
        mockFlutterSecureStorage.write(key: StorageKeys.user, value: userJson),
      );
    });

    test('should throw an exception if storage.write fails', () async {
      when(
        mockFlutterSecureStorage.write(
          key: StorageKeys.user,
          value: anyNamed('value'),
        ),
      ).thenThrow(Exception('Failed to write'));

      final call = service.saveUser;

      expect(() => call(user), throwsA(isA<Exception>()));
    });
  });

  group('getUser', () {
    final user = User.view(email: 'test@test.com');
    final userJson = jsonEncode(user.toJson());

    test('should return a User object on success', () async {
      when(
        mockFlutterSecureStorage.read(key: StorageKeys.user),
      ).thenAnswer((_) async => userJson);

      final result = await service.getUser();

      expect(result, user);
    });

    test('should return null if no user is stored', () async {
      when(
        mockFlutterSecureStorage.read(key: StorageKeys.user),
      ).thenAnswer((_) async => null);

      final result = await service.getUser();

      expect(result, isNull);
    });

    test('should throw an exception if storage.read fails', () async {
      when(
        mockFlutterSecureStorage.read(key: StorageKeys.user),
      ).thenThrow(Exception('Failed to read'));

      final call = service.getUser;

      expect(call, throwsA(isA<Exception>()));
    });
  });

  group('clearUser', () {
    test('should call storage.delete with correct key on success', () async {
      when(
        mockFlutterSecureStorage.delete(key: StorageKeys.user),
      ).thenAnswer((_) async => Future.value());

      await service.clearUser();

      verify(mockFlutterSecureStorage.delete(key: StorageKeys.user));
    });

    test('should throw an exception if storage.delete fails', () async {
      when(
        mockFlutterSecureStorage.delete(key: StorageKeys.user),
      ).thenThrow(Exception('Failed to delete'));

      final call = service.clearUser;

      expect(call, throwsA(isA<Exception>()));
    });
  });
}
