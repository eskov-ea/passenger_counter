import '../../storage/data_storage.dart';

class AuthProvider {
  final DataProvider _dataProvider = DataProvider();

  Future<String> login({required String email, required String password}) async {
    return email;
  }
}