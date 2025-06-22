import 'dart:developer';

import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/core/routes/app_routes.dart';
import 'package:chatapp/core/theme/app_theme.dart';
import 'package:chatapp/features/auth/cubit/auth_status_cubit.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register the error handler early
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log(' FlutterError: ${details.exception}');
    log(' StackTrace: ${details.stack}');
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
        //  Global Bloc and Cubit registrations
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<AuthStatusCubit>(
          create:
              (_) =>
                  sl<AuthStatusCubit>()
                    ..checkAuthStatus(), // check user auth status
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // set theme
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
