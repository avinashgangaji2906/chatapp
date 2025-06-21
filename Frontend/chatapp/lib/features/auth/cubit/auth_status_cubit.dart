import 'package:chatapp/features/auth/domain/entity/auth_entity.dart';
import 'package:chatapp/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_status_state.dart';

class AuthStatusCubit extends Cubit<AuthStatusState> {
  final AuthRepository authRepository;

  AuthStatusCubit({required this.authRepository}) : super(AuthStatusInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthStatusLoading());
    try {
      final user = await authRepository.getUserSession(); // Uses cookie
      emit(AuthStatusAuthenticated(user));
    } catch (e) {
      emit(AuthStatusUnauthenticated());
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    emit(AuthStatusUnauthenticated());
  }
}
