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
    required String firstname,
    required String lastname,
    required String middlename,
    required String gender,
    required String phone,
    required String email,
    required String citizenship,
    required String comment,
    required String photo,
    required String parentId,
    required String bDay,
    required String bMonth,
    required String bYear
  }) => _secureStorage.write(key: _Keys.personDraft, value: <String, String>{
          "firstname" : firstname,
          "lastname" : lastname,
          "middlename" : middlename,
          "gender" : gender,
          "phone" : phone,
          "email" : email,
          "citizenship" : citizenship,
          "comment" : comment,
          "photo" : photo,
          "parentId" : parentId,
          "bDay" : bDay,
          "bMonth" :bMonth,
          "bYear" : bYear
        }.toString());
  Future<void> deletePersonDraft() => _secureStorage.delete(key: _Keys.personDraft);

}