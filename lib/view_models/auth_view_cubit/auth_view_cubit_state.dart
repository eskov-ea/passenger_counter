import 'package:equatable/equatable.dart';

abstract class AuthViewCubitState extends Equatable {

  const AuthViewCubitState();
  @override
  List<Object> get props => [];
}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {

  const AuthViewCubitFormFillInProgressState();
}


class AuthViewCubitErrorState extends AuthViewCubitState {
  final String error;

  const AuthViewCubitErrorState({required this.error});
  @override
  List<Object> get props => [error];
}


class AuthViewCubitAuthProgressState extends AuthViewCubitState {

  const AuthViewCubitAuthProgressState();
}


class AuthViewCubitSuccessAuthState extends AuthViewCubitState {

  const AuthViewCubitSuccessAuthState();
}