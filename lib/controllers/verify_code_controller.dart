
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/utils/ui_utils.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';

/// Controller for managing the logic of VerifyCodeScreen
class VerifyCodeController {
  final BuildContext context;
  final TextEditingController codeController = TextEditingController();
  final String email;

  VerifyCodeController({required this.context, required this.email});

  /// Verifies the 6-digit OTP code entered by the user
  void verifyCode() {
    final trimmedCode = codeController.text.trim();
    if (trimmedCode.isEmpty) {
      showSnackBar(context, 'Please enter the verification code');
      return;
    }
    if (trimmedCode.length != 6 || !RegExp(r'^\d+$').hasMatch(trimmedCode)) {
      showSnackBar(context, 'Please enter a valid 6-digit code');
      return;
    }

    context.read<AuthCubit>().verifyCode(email, trimmedCode);
  }

  /// Handles the "Need Help" action
  void onHelpPressed() {
    showSnackBar(context, 'Contact support at support@testapp.com');
  }

  /// Disposes of resources
  void dispose() {
    codeController.dispose();
  }
}
