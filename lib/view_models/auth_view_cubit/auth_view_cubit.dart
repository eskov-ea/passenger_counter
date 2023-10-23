import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';
import '../../exceptions/api_exception.dart';
import 'auth_view_cubit_state.dart';


class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit({
    required AuthViewCubitState initialState,
    required this.authBloc,
  }) : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
    authBloc.add(AuthCheckAuthEvent());
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  void auth({required String email, required String password}) {
    authBloc.add(AuthLoginEvent(email: email, password: password));
  }

  void logout(BuildContext context){
    authBloc.add(AuthLogoutEvent());
  }

  void _onState(AuthState state) {
    if (state is UnauthenticatedAuthState) {
      emit(const AuthViewCubitFormFillInProgressState());
    } else if (state is AuthenticatedAuthState) {
      emit(const AuthViewCubitSuccessAuthState());
    } else if (state is AuthenticatingFailureAuthState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(error: message));
    } else if (state is AuthenticatingAuthState) {
      emit(const AuthViewCubitAuthProgressState());
    } else if (state is AuthCheckStatusFillFormInProgressAuthState) {
      emit(const AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is !AppErrorException) {
      return 'Неизвестная ошибка, поторите попытку';
    }
    switch (error.type) {
      case AppErrorExceptionType.network:
        return 'Сервер не доступен. Проверте подключение к интернету';
      case AppErrorExceptionType.auth:
        return 'Неправильный логин или пароль!';
      case AppErrorExceptionType.access:
        return 'Недостаточно прав доступа!';
      case AppErrorExceptionType.sessionExpired:
        return 'Сессия устарела, обновите КЕШ';
      case AppErrorExceptionType.other:
        return 'Произошла ошибка. Попробуйте еще раз';
      case AppErrorExceptionType.parsing:
        return 'Произошла ошибка при обработке данных. Если повторится - свяжитесь с разработчиком';
      case AppErrorExceptionType.getData:
        return 'Произошла ошибка при получении данных с сервера. Попробуйте еще раз';
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}