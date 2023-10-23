import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/authentication/auth_repository.dart';
import '../../storage/data_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final DataProvider _dataProvider = DataProvider();

  AuthBloc() : super(const AuthCheckStatusFillFormInProgressAuthState()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLoginEvent) {
        await onAuthLoginEvent(event, emit);
      } else if(event is AuthCheckAuthEvent) {
        emit(const UnauthenticatedAuthState());
      }
    });
  }

  Future<void> onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {

  }
}