import 'package:chatapp/features/users_list/domain/entity/user_list_entity.dart';

abstract class UserListRepository {
  Future<List<UserListEntity>> getAllUsers();
}
