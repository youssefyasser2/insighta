import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';
import 'package:test_app/controllers/register_controller.dart';
import 'package:test_app/features/auth/presentation/register/register_form.dart';
import 'package:test_app/navigation/routes.dart';

/// Register screen where users can create a new account
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with required dependencies
    _controller = RegisterController(
      authCubit: context.read<AuthCubit>(),
      onShowSnackBar: _showSnackBar,
      context: context,
    );
  }

  /// Displays a snackbar with the given message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    // Clean up the controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                // Show success message
                _controller.onShowSnackBar("Registration successful!");
                // Navigate to VerifyCode with proper extra data
                context.go(
                  Routes.verifyCode,
                  extra: {
                    'email':
                        state.user?.email ??
                        '', // Use email from UserModel, fallback to empty string if null
                    'userId': state.userId ?? '',
                  },
                );
              } else if (state is AuthFailure) {
                final errorMessage =
                    state.message.isNotEmpty
                        ? state.message
                        : "Registration failed. Please try again.";
                _controller.onShowSnackBar(errorMessage);
              }
            },
            builder: (context, state) {
              // Show loading indicator or the form based on state
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Register form
                  RegisterForm(controller: _controller),
                  // Show loading overlay if in loading state
                  if (state is AuthLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
