import 'package:chatapp/features/users_list/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.username});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], username: json['username']);
  }
}
