import 'package:chatapp/features/auth/cubit/auth_status_cubit.dart';
import 'package:chatapp/features/auth/presentation/screens/login_screen.dart';
import 'package:chatapp/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthStatusCubit, AuthStatusState>(
      builder: (context, state) {
        if (state is AuthStatusLoading || state is AuthStatusInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            ),
          );
        } else if (state is AuthStatusAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
