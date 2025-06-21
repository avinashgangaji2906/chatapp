part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String userName;
  final String password;

  const AuthLoginEvent({required this.userName, required this.password});
}

class AuthSignupEvent extends AuthEvent {
  final String userName;
  final String password;

  const AuthSignupEvent({required this.userName, required this.password});
}
