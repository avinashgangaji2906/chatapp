import 'package:chatapp/features/auth/domain/entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login({
    required String username,
    required String password,
  });
  Future<AuthEntity> signup({
    required String username,
    required String password,
  });

  Future<AuthEntity> getUserSession();

  Future<void> logout();
}
