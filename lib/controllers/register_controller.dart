import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';

/// Controller to manage the registration form and its logic.
class RegisterController {
  final AuthCubit authCubit;
  final Function(String) onShowSnackBar;
  final BuildContext context;

  // Text controllers for the registration form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Subscription to listen to AuthCubit state changes
  StreamSubscription<AuthState>? _authSubscription;

  // Notifiers to manage password visibility
  final ValueNotifier<bool> isPasswordVisibleNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isConfirmPasswordVisibleNotifier = ValueNotifier(
    false,
  );

  RegisterController({
    required this.authCubit,
    required this.onShowSnackBar,
    required this.context,
  }) {
    _listenToAuthState(); // Initialize listening to AuthCubit state changes
  }

  /// Toggles the visibility of the password field.
  void togglePasswordVisibility() {
    isPasswordVisibleNotifier.value = !isPasswordVisibleNotifier.value;
  }

  /// Toggles the visibility of the confirm password field.
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisibleNotifier.value =
        !isConfirmPasswordVisibleNotifier.value;
  }

  /// Initiates the registration process by delegating to AuthCubit.
  void validateAndRegister() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Rely on AuthCubit for validation to avoid duplication
    authCubit.register(name, email, password, confirmPassword);
  }

  /// Listens to AuthCubit state changes and handles navigation or error display.
  void _listenToAuthState() {
    _authSubscription?.cancel();

    _authSubscription = authCubit.stream.listen((state) async {
      if (state is AuthLoading) {
        onShowSnackBar("🔄 Processing your request...");
      } else if (state is AuthSuccess && state.isRegister) {
        final userId = state.userId;
        print('AuthSuccess: userId = $userId'); // Debug log

        if (userId != null && userId.isNotEmpty) {
          _clearFields(); // Clear input fields after success
          try {
            // Navigate to the verification screen using go_router
            context.pushReplacement(
              '/verify-code',
              extra: {'userId': userId, 'email': emailController.text.trim()},
            );
          } catch (e) {
            onShowSnackBar("❌ Navigation failed: $e");
            print('❌ Navigation Error: $e');
          }
        } else {
          // Show error if userId is missing
          onShowSnackBar("❌ Registration failed: User ID is missing.");
          print('❌ Registration Error: User ID is missing.');
          _clearFields();
        }
      } else if (state is AuthFailure) {
        print("AuthFailure: ${state.message}"); // Debug log

        // Display the error message from AuthCubit
        onShowSnackBar("❌ ${state.message}");
        _clearFields(); // Clear fields on failure
      }
    });
  }

  /// Clears all input fields after success or failure.
  void _clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  /// Initiates social login with the specified provider.
  void socialLogin(String provider) {
    if (provider.isEmpty) {
      onShowSnackBar("❌ Please specify a login provider.");
      return;
    }
    onShowSnackBar("Logging in with $provider...");
    authCubit.socialLogin(provider);
  }

  /// Disposes resources to prevent memory leaks.
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _authSubscription?.cancel();
    isPasswordVisibleNotifier.dispose();
    isConfirmPasswordVisibleNotifier.dispose();
  }
}
