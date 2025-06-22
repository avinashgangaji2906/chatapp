import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/core/routes/app_routes.dart';
import 'package:chatapp/features/auth/cubit/auth_status_cubit.dart';
import 'package:chatapp/features/chat/presentation/screens/chat_screen.dart';
import 'package:chatapp/features/users_list/presentation/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_list_bloc.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = sl<AuthStatusCubit>().state;
    String? currentUserId;

    if (authState is AuthStatusAuthenticated) {
      currentUserId = authState.user.id;
    }

    return BlocProvider(
      create: (_) => sl<UserListBloc>()..add(FetchAllUsers()),
      child: Scaffold(
        appBar: AppBar(title: const Text("All Chats")),
        body: BlocBuilder<UserListBloc, UserListState>(
          builder: (context, state) {
            if (state is UserListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserListLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  if (user.id == currentUserId) return const SizedBox.shrink();
                  return UserTile(
                    user: user,
                    onTap: () {
                      if (currentUserId != null) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chat,
                          arguments: ChatScreenArgs(
                            receiver: user,
                            currentUserId: currentUserId,
                          ),
                        );
                      }
                    },
                  );
                },
              );
            } else if (state is UserListError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
