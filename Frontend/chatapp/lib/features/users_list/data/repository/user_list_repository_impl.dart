import 'package:chatapp/features/users_list/data/datasource/user_list_datasource.dart';
import 'package:chatapp/features/users_list/domain/entity/user_list_entity.dart';
import 'package:chatapp/features/users_list/domain/repository/user_list_repository.dart';

class UserListRepositoryImpl implements UserListRepository {
  final UserListDatasource userListDatasource;

  UserListRepositoryImpl({required this.userListDatasource});

  @override
  Future<List<UserListEntity>> getAllUsers() {
    return userListDatasource.getAllUsers();
  }
}
