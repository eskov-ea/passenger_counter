import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const user = 'user_id';
}

class DataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> getUser() => _secureStorage.read(key: _Keys.user);
  Future<void> setUser({required String username}) => _secureStorage.write(key: _Keys.user, value: username);
  Future<void> deleteUser() => _secureStorage.delete(key: _Keys.user);

}