import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/constants/color_manager.dart';
import 'package:test_app/controllers/login_controller.dart';
import 'package:test_app/features/auth/presentation/login/stay_connected_checkbox_widget.dart';
import 'package:test_app/features/auth/presentation/widgets/auth_screen.dart';
import 'package:test_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:test_app/features/auth/presentation/widgets/visibility_icon.dart';

class LoginForm extends StatefulWidget {
  final LoginController controller;
  final Widget? headerWidget; // ✅ دعم للشعار

  const LoginForm({super.key, required this.controller, this.headerWidget});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: "Login to your Account",
      titleAlignment: TextAlign.start,
      headerWidget: widget.headerWidget, // ✅ تمرير الشعار إلى AuthScreen
      fields: [
        AuthTextField(
          label: "Enter your email",
          controller: widget.controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        AuthTextField(
          label: "Enter your password",
          isPassword: true,
          controller: widget.controller.passwordController,
          obscureText: !widget.controller.isPasswordVisible,
          suffixIcon: VisibilityIcon(
            isVisible: widget.controller.isPasswordVisible,
            toggleVisibility: () {
              setState(() {
                widget.controller.togglePasswordVisibility(() {
                  setState(() {});
                });
              });
            },
          ),
        ),
      ],
      extraWidgets: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StayConnectedCheckbox(
            value: widget.controller.stayConnected,
            onChanged: (value) {
              setState(() {
                widget.controller.setStayConnected(value ?? false);
              });
            },
          ),
          TextButton(
            onPressed: () => context.go('/forgot-password'),
            child: const Text(
              "Forgot password?",
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ),
        ],
      ),
      buttonText: "Login",
      footerText: "Don't have an account? Sign up",
      onFooterPressed: () => context.go('/register'),
      buttonColor: ColorManager.primaryColor,
      buttonTextColor: Colors.white,
      onButtonPressed:
          () =>
              widget.controller.validateAndLogin(context), // ✅ تمرير `context`
      onSocialLoginPressed: widget.controller.socialLogin,
    );
  }
}
