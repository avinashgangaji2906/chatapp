import 'package:chatapp/features/users_list/data/datasource/user_datasource.dart';
import 'package:chatapp/features/users_list/domain/entity/user_entity.dart';
import 'package:chatapp/features/users_list/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource userDatasource;

  UserRepositoryImpl({required this.userDatasource});

  @override
  Future<List<UserEntity>> getAllUsers() {
    return userDatasource.getAllUsers();
  }
}
