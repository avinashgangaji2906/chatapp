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
    return BlocConsumer<AuthStatusCubit, AuthStatusState>(
      listener: (context, state) {
        if (state is AuthStatusUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      builder: (context, authState) {
        if (authState is AuthStatusLoading || authState is AuthStatusInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            ),
          );
        } else if (authState is AuthStatusUnauthenticated) {
          // Redirect to login if needed
          return const Scaffold(body: Center(child: Text('Please login')));
        } else if (authState is AuthStatusAuthenticated) {
          final currentUserId = authState.user.id;
          final userName = authState.user.username;

          return BlocProvider(
            create: (_) => sl<UserListBloc>()..add(FetchAllUsers()),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("All Chats"),
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        context.read<AuthStatusCubit>().logout();
                      }
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem<String>(
                            value: 'username',
                            child: Row(
                              children: [
                                const Icon(Icons.person, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(userName),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                const Icon(Icons.logout, color: Colors.red),
                                const SizedBox(width: 8),
                                const Text("Logout"),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
                // actions: [
                //   IconButton(
                //     onPressed: () {
                //       context.read<AuthStatusCubit>().logout();
                //     },
                //     icon: const Icon(Icons.logout, color: Colors.red),
                //   ),
                // ],
              ),
              body: BlocBuilder<UserListBloc, UserListState>(
                builder: (context, state) {
                  if (state is UserListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserListLoaded) {
                    return ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        if (user.id == currentUserId) {
                          return const SizedBox.shrink();
                        }
                        return UserTile(
                          user: user,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.chat,
                              arguments: ChatScreenArgs(
                                receiver: user,
                                currentUserId: currentUserId,
                              ),
                            );
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

        return const SizedBox.shrink(); // fallback
      },
    );
  }
}
