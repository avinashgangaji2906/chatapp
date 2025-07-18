import 'package:chatapp/features/chat/presentation/screens/chat_screen.dart';
import 'package:chatapp/features/users_list/presentation/screens/user_list_screen.dart';
import 'package:chatapp/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/features/auth/presentation/screens/login_screen.dart';
import 'package:chatapp/features/auth/presentation/screens/signup_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String usersList = '/usersList';
  static const String chat = '/chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case usersList:
        return MaterialPageRoute(builder: (_) => const UserListScreen());
      case chat:
        final args = settings.arguments as ChatScreenArgs;
        return MaterialPageRoute(
          builder:
              (_) => ChatScreen(
                receiver: args.receiver,
                currentUserId: args.currentUserId,
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No route found'))),
        );
    }
  }
}
