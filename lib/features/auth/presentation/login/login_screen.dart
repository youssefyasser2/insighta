import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/services/storage_service.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';
import 'package:test_app/controllers/login_controller.dart';
import 'package:test_app/features/auth/presentation/login/login_form.dart';
import 'package:test_app/navigation/routes.dart';

/// Screen for user login, redirects to CompleteProfileScreen (first login) or HomeScreen.
class LoginScreen extends StatefulWidget {
  final String? userId; // Optional userId from VerifyCodeScreen

  const LoginScreen({super.key, this.userId});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize LoginController with userId
    _controller = LoginController(
      storageService: context.read<StorageService>(),
      authCubit: context.read<AuthCubit>(),
      onShowSnackBar: (message) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      userId: widget.userId,
    );
    // Load saved login credentials
    _controller.loadSavedLogin();
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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          // Handle successful login
          if (state is AuthSuccess) {
            if (state.userId != null) {
              // Show success message
              _controller.onShowSnackBar("Login successful!");
              // Save user session
              await _controller.saveUserSession(state.userId!);
              // Navigate based on profile completion
              final route =
                  !state.isProfileCompleted
                      ? Routes.completeProfile
                      : Routes.home;
              if (mounted) {
                context.go(
                  route,
                  extra: state.userId, // Pass userId from AuthSuccess
                );
              }
            } else {
              // Show error if userId is missing and redirect to Register
              _controller.onShowSnackBar(
                '❌ Error: User ID is not available. Please register again.',
              );
              if (mounted) {
                context.go(Routes.register);
              }
            }
          } else if (state is AuthFailure) {
            // Show error message on login failure
            _controller.onShowSnackBar(state.message);
          }
        },
        builder: (context, state) {
          // Show loading overlay if in loading state
          return Stack(
            children: [
              // Login form with logo header
              SingleChildScrollView(
                child: LoginForm(
                  controller: _controller,
                  headerWidget: Image.asset(
                    'assets/images/logo.png', // Ensure correct path to app logo
                    height: 200,
                  ),
                ),
              ),
              // Loading overlay
              if (state is AuthLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
