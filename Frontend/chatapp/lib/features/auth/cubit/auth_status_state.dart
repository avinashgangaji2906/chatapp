part of 'auth_status_cubit.dart';

sealed class AuthStatusState extends Equatable {
  const AuthStatusState();

  @override
  List<Object?> get props => [];
}

final class AuthStatusInitial extends AuthStatusState {}

final class AuthStatusLoading extends AuthStatusState {}

final class AuthStatusAuthenticated extends AuthStatusState {
  final AuthEntity user;

  const AuthStatusAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthStatusUnauthenticated extends AuthStatusState {}
