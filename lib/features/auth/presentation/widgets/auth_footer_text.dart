import 'package:flutter/material.dart';
import 'package:test_app/core/constants/color_manager.dart';

class AuthFooterText extends StatelessWidget {
  final String footerText;
  final VoidCallback? onPressed;

  const AuthFooterText({super.key, required this.footerText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: RichText(
        text: TextSpan(
          text:
              footerText.contains("Sign up")
                  ? "Don't have an account? "
                  : "Already have an account? ",
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: footerText.contains("Sign up") ? "Sign up" : "Login",
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
