import 'package:chatapp/features/auth/domain/entity/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({required super.id, required super.username});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(id: json['id'], username: json['username']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'username': username};
}
