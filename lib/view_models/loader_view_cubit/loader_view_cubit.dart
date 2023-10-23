import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';

enum LoaderViewCubitState { unknown, authorized, notAuthorized }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  LoaderViewCubit({
    required this.authBloc,
  }) : super(LoaderViewCubitState.unknown) {
    Future.microtask(
          () {
        _onState(authBloc.state);
        authBlocSubscription = authBloc.stream.listen(_onState);
        authBloc.add(AuthCheckAuthEvent());
      },
    );
  }

  void _onState(AuthState state) {
    if (state is AuthenticatedAuthState) {
      emit(LoaderViewCubitState.authorized);
    } else if (state is UnauthenticatedAuthState) {
      emit(LoaderViewCubitState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}