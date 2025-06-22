import 'package:chatapp/features/users_list/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onTap;

  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(user.username), onTap: onTap);
  }
}
