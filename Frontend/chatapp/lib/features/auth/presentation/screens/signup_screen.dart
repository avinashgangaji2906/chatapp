import 'package:chatapp/core/routes/app_routes.dart';
import 'package:chatapp/features/auth/cubit/auth_status_cubit.dart';
import 'package:chatapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatapp/features/auth/presentation/widgets/app_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignupEvent(
          userName: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  // basic username validation to achieve uniqueness
  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    final username = value.trim();

    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{2,19}$');

    if (!regex.hasMatch(username)) {
      return 'Only letters, numbers, underscores (3-20 chars, start with a letter)';
    }

    return null; // valid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<AuthStatusCubit>().checkAuthStatus();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Signup successful!')));
            // navigate user to home screen
            Navigator.pushReplacementNamed(context, AppRoutes.usersList);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.25,
                      ),
                      Text(
                        'SignUp.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 48),
                      AppTextField(
                        controller: _usernameController,
                        label: 'Username',
                        textInputAction: TextInputAction.next,
                        validator: validateUsername,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.next,
                        label: 'Password',
                        obscureText: true,
                        validator:
                            (value) =>
                                value == null || value.length < 6
                                    ? 'Minimum 6 characters'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _rePasswordController,
                        label: 'Re-enter Password',
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        validator:
                            (value) =>
                                value != _passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        onPressed: state is AuthLoading ? null : _submit,
                        child:
                            state is AuthLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Signup",
                                  style: TextStyle(color: Colors.white),
                                ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            );
                          },
                          child: const Text("Already have an account? Login"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
