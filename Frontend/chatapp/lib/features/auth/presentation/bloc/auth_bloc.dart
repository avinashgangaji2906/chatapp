import 'package:chatapp/core/errors/app_exception.dart';
import 'package:chatapp/features/auth/domain/entity/auth_entity.dart';
import 'package:chatapp/features/auth/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthSignupEvent>(onSignupEvent);
    on<AuthLoginEvent>(onLoginEvent);
  }
  // Signup Handler
  Future<void> onSignupEvent(
    AuthSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signup(
        username: event.userName,
        password: event.password,
      );
      emit(AuthSuccess(user: user));
    } on AppException catch (e) {
      emit(AuthError(errorMessage: e.message));
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  // Login Handler
  Future<void> onLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
        username: event.userName,
        password: event.password,
      );
      emit(AuthSuccess(user: user));
    } on AppException catch (e) {
      emit(AuthError(errorMessage: e.message));
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }
}
