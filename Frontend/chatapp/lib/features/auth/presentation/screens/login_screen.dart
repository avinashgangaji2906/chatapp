import 'package:chatapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatapp/features/auth/presentation/widgets/app_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginEvent(
          userName: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login successful!')));
            // navigate user to home screen
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        'Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 42),
                      AppTextField(
                        controller: _usernameController,
                        label: 'Username',
                        textInputAction: TextInputAction.next,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Enter username'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        label: 'Password',
                        obscureText: true,
                        validator:
                            (value) =>
                                value == null || value.length < 6
                                    ? 'Minimum 6 characters'
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
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: const Text("Don't have an account? Signup"),
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
