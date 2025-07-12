import 'dart:convert';

import 'package:cos_challenge/core/constants/storage_keys.dart';
import 'package:cos_challenge/core/services/storage/storage_service.dart';
import 'package:cos_challenge/data/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageServiceImpl implements StorageService {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> saveUser(User user) async {
    await _storage.write(
      key: StorageKeys.user,
      value: jsonEncode(user.toJson()),
    );
  }

  @override
  Future<User?> getUser() async {
    final user = await _storage.read(key: StorageKeys.user);

    if (user == null) {
      return null;
    }

    return User.fromJson(jsonDecode(user));
  }

  @override
  Future<void> clearUser() async {
    await _storage.delete(key: StorageKeys.user);
  }
}
