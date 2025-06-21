import 'package:chatapp/features/auth/data/datasource/auth_datasource.dart';
import 'package:chatapp/features/auth/domain/entity/auth_entity.dart';
import 'package:chatapp/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});

  @override
  Future<AuthEntity> login({
    required String username,
    required String password,
  }) async {
    return await authDatasource.login(username: username, password: password);
  }

  @override
  Future<AuthEntity> signup({
    required String username,
    required String password,
  }) async {
    return await authDatasource.signup(username: username, password: password);
  }

  @override
  Future<AuthEntity> getUserSession() async {
    return await authDatasource.getUserSession();
  }

  @override
  Future<void> logout() async {
    await authDatasource.logout();
  }
}
