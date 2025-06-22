import 'package:chatapp/features/users_list/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getAllUsers();
}
