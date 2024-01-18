import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const String user = 'user_id';
  static const String dbInitializationStatus = 'db_initialization_status';
  static const String personDraft = 'person';
}

class DataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> getUser() => _secureStorage.read(key: _Keys.user);
  Future<void> setUser({required String username}) => _secureStorage.write(key: _Keys.user, value: username);
  Future<void> deleteUser() => _secureStorage.delete(key: _Keys.user);

  Future<String?> getDBInitializationStatus() => _secureStorage.read(key: _Keys.dbInitializationStatus);
  Future<void> setDBInitializationStatus({required int status}) => _secureStorage.write(key: _Keys.dbInitializationStatus, value: status.toString());
  Future<void> deleteDBInitializationStatus() => _secureStorage.delete(key: _Keys.dbInitializationStatus);

  Future<String?> getPersonDraft() => _secureStorage.read(key: _Keys.personDraft);
  Future<void> setPersonDraft({
    required String value
  }) => _secureStorage.write(key: _Keys.personDraft, value: value);
  Future<void> deletePersonDraft() => _secureStorage.delete(key: _Keys.personDraft);

}