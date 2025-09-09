import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/constants/color_manager.dart';
import 'package:test_app/core/constants/font_manager.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';
import 'package:test_app/controllers/register_controller.dart';
import 'package:test_app/features/auth/presentation/widgets/auth_screen.dart';
import 'package:test_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:test_app/features/auth/presentation/widgets/visibility_icon.dart';

// Widget to display the registration form UI
class RegisterForm extends StatefulWidget {
  final RegisterController controller;

  const RegisterForm({super.key, required this.controller});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: widget.controller.authCubit, // Listen to AuthCubit state
      builder: (context, state) {
        // Determine if the form is in a loading state
        final isLoading = state is AuthLoading;

        return Stack(
          children: [
            // Main registration form
            AuthScreen(
              title: "Sign up",
              titleAlignment: TextAlign.center,
              titleFontSize: FontManager.fontSizeExtraLargeX,
              titlePadding: const EdgeInsets.only(top: 5),
              fields: [
                const SizedBox(
                  height: 10,
                ), // Adds spacing between title and fields
                // Name field
                AuthTextField(
                  label: "Enter your name",
                  controller: widget.controller.nameController,
                ),

                // Email field
                AuthTextField(
                  label: "Enter your email",
                  controller: widget.controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                // Password field with visibility toggle
                ValueListenableBuilder<bool>(
                  valueListenable: widget.controller.isPasswordVisibleNotifier,
                  builder: (context, isVisible, child) {
                    return AuthTextField(
                      label: "Enter your password",
                      isPassword: true,
                      controller: widget.controller.passwordController,
                      obscureText: !isVisible,
                      suffixIcon: VisibilityIcon(
                        isVisible: isVisible,
                        toggleVisibility:
                            widget.controller.togglePasswordVisibility,
                      ),
                    );
                  },
                ),

                // Confirm password field with visibility toggle
                ValueListenableBuilder<bool>(
                  valueListenable:
                      widget.controller.isConfirmPasswordVisibleNotifier,
                  builder: (context, isVisible, child) {
                    return AuthTextField(
                      label: "Confirm your password",
                      isPassword: true,
                      controller: widget.controller.confirmPasswordController,
                      obscureText: !isVisible,
                      suffixIcon: VisibilityIcon(
                        isVisible: isVisible,
                        toggleVisibility:
                            widget.controller.toggleConfirmPasswordVisibility,
                      ),
                    );
                  },
                ),
              ],
              buttonText: "Sign up",
              footerText: "Already have an account? Log in",
              onFooterPressed: () => context.go('/login'),
              buttonColor: ColorManager.primaryColor,
              buttonTextColor: Colors.white,
              onButtonPressed:
                  isLoading
                      ? null
                      : widget
                          .controller
                          .validateAndRegister, // Disable button during loading
              onSocialLoginPressed:
                  isLoading
                      ? null
                      : widget
                          .controller
                          .socialLogin, // Disable social login during loading
            ),

            // Show a loading overlay when the request is in progress
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(
                  0.3,
                ), // Semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primaryColor,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
