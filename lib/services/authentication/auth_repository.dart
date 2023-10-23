import 'auth_provider.dart';

class AuthRepository {
  final _authProvider = AuthProvider();

  Future<String> login({required String email, required String password}) => _authProvider.login(email: email, password: password);
}