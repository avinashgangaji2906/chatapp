import 'package:chatapp/features/users_list/domain/entity/user_list_entity.dart';

class UserListModel extends UserListEntity {
  const UserListModel({required super.id, required super.username});

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(id: json['id'], username: json['username']);
  }
}
