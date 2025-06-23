import 'package:chatapp/features/users_list/domain/entity/user_list_entity.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final UserListEntity user;
  final VoidCallback onTap;

  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey.shade700,
        child: Icon(Icons.person, color: Colors.white70),
      ),
      shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      title: Text(user.username, style: TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}
