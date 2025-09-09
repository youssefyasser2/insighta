import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/services/storage_service.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';

/// Controller for managing login Stuart login logic and user session.
class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final StorageService storageService;
  final AuthCubit authCubit;
  final Function(String message) onShowSnackBar;
  final String? userId; // Optional userId from VerifyCodeScreen

  bool isPasswordVisible = false;
  bool stayConnected = false;

  LoginController({
    required this.storageService,
    required this.authCubit,
    required this.onShowSnackBar,
    this.userId, // Add userId as optional parameter
  });

  /// Loads saved login credentials if stay connected is enabled.
  Future<void> loadSavedLogin() async {
    final bool savedStayConnected = await storageService.isStayConnected();

    if (savedStayConnected) {
      final loginInfo = await storageService.getLoginInfo();
      emailController.text = loginInfo['email'] ?? '';
      passwordController.text = loginInfo['password'] ?? '';
      stayConnected = true;
    }
  }

  /// Toggles password visibility and triggers UI update.
  void togglePasswordVisibility(VoidCallback onUpdate) {
    isPasswordVisible = !isPasswordVisible;
    onUpdate();
  }

  /// Sets the stay connected option.
  void setStayConnected(bool value) {
    stayConnected = value;
  }

  /// Saves user session after successful login.
  Future<void> saveUserSession(String userId) async {
    await storageService.saveUserId(userId);
  }

  /// Validates login credentials and initiates login process.
  Future<void> validateAndLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!_isEmailValid(email)) {
      onShowSnackBar('Please enter a valid email address');
      return;
    }
    if (password.isEmpty) {
      onShowSnackBar('Please enter your password');
      return;
    }

    // Initiate login through AuthCubit
    context.read<AuthCubit>().login(email, password);

    // Save login info if stay connected is enabled
    if (stayConnected) {
      await storageService.saveLoginInfo(email, password);
    } else {
      await storageService.clearLoginInfo();
    }
  }

  /// Initiates social login with the specified platform.
  void socialLogin(String platform) {
    authCubit.socialLogin(platform);
  }

  /// Validates email format.
  bool _isEmailValid(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  /// Cleans up resources.
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}