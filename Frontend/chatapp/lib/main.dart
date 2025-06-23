import 'dart:developer';
import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/core/routes/app_routes.dart';
import 'package:chatapp/core/theme/app_theme.dart';
import 'package:chatapp/features/auth/cubit/auth_status_cubit.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatapp/features/chat/data/datasource/chat_socket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log('FlutterError: ${details.exception}');
    log('StackTrace: ${details.stack}');
  };
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<AuthStatusCubit>(
          create: (_) => sl<AuthStatusCubit>()..checkAuthStatus(),
        ),
      ],
      child: BlocListener<AuthStatusCubit, AuthStatusState>(
        listener: (context, state) {
          final socketClient = sl<ChatSocketClient>();
          if (state is AuthStatusAuthenticated) {
            socketClient.connect(state.user.id);
          } else if (state is AuthStatusUnauthenticated) {
            socketClient.disconnect();
          }
        },
        child: MaterialApp(
          title: 'Chat App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: AppRoutes.splash,
        ),
      ),
    );
  }
}
