import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{

  const AuthState();

  @override
  List<Object> get props => [];
}

class UnauthenticatedAuthState extends AuthState {
  const UnauthenticatedAuthState();
}

class AuthenticatingAuthState extends AuthState {
  const AuthenticatingAuthState();
}

class AuthCheckStatusFillFormInProgressAuthState extends AuthState {
  const AuthCheckStatusFillFormInProgressAuthState();
}


class AuthenticatingFailureAuthState extends AuthState {
  final Object error;

  const AuthenticatingFailureAuthState({required this.error});

  @override
  List<Object> get props => [error];
}


class AuthenticatedAuthState extends AuthState {
  final String user;

  const AuthenticatedAuthState({required this.user});

  @override
  List<Object> get props => [user];
}
