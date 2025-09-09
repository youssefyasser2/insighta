import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/utils/ui_utils.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';
import 'package:test_app/controllers/verify_code_controller.dart';

/// Screen for verifying the OTP code sent to the user's email
class VerifyCodeScreen extends StatefulWidget {
  final String? userId;
  final String email;

  const VerifyCodeScreen({super.key, this.userId, required this.email});

  @override
  VerifyCodeScreenState createState() => VerifyCodeScreenState();
}

class VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late final VerifyCodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VerifyCodeController(context: context, email: widget.email);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is VerifyCodeSuccess) {
              showSnackBar(context, 'Verification successful!');
              context.go('/login', extra: widget.userId ?? '');
            } else if (state is VerifyCodeFailure) {
              showSnackBar(
                context,
                state.message.contains('Invalid')
                    ? 'Invalid code. Please use the first 6-digit code sent to ${widget.email}.'
                    : state.message,
              );
            } else if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      TitleWidget(primaryColor: primaryColor),
                      const SizedBox(height: 12),
                      InstructionWidget(
                        email: widget.email,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 8),
                      AdditionalInstructionWidget(email: widget.email),
                      const SizedBox(height: 32),
                      OtpFieldWidget(
                        controller: _controller.codeController,
                        isLoading: isLoading,
                        primaryColor: primaryColor,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 16),
                      ResendButtonWidget(isLoading: isLoading),
                      const SizedBox(height: 16),
                      SubmitButtonWidget(
                        isLoading: isLoading,
                        onPressed: _controller.verifyCode,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 16),
                      HelpButtonWidget(
                        onPressed: _controller.onHelpPressed,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Primary color used throughout the UI
  static const Color primaryColor = Color(0xFF086473);
  static const Color accentColor = Color(0xFFE0F7FA);
}

/// Widget for displaying the title with an icon
class TitleWidget extends StatelessWidget {
  final Color primaryColor;

  const TitleWidget({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.email_outlined,
          size: 48,
          color: primaryColor,
          semanticLabel: 'Email icon',
        ),
        const SizedBox(height: 8),
        Text(
          'Activate Your Account',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Widget for displaying the instruction text
class InstructionWidget extends StatelessWidget {
  final String email;
  final Color primaryColor;

  const InstructionWidget({
    super.key,
    required this.email,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'We sent a code to ',
        children: [
          TextSpan(
            text: email,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
    );
  }
}

/// Widget for displaying additional instruction text
class AdditionalInstructionWidget extends StatelessWidget {
  final String email;

  const AdditionalInstructionWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Use the first 6-digit code sent to $email. Resend is currently disabled.',
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
      textAlign: TextAlign.center,
    );
  }
}

/// Widget for displaying the OTP input field
class OtpFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final Color primaryColor;
  final Color accentColor;

  const OtpFieldWidget({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Enter 6-digit verification code',
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: '6-Digit Code',
          hintStyle: TextStyle(color: Colors.grey[600], letterSpacing: 2),
          filled: true,
          fillColor: accentColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          counterText: '',
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          letterSpacing: 8,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        autofocus: true,
        enabled: !isLoading,
      ),
    );
  }
}

/// Widget for displaying the resend code button (disabled)
class ResendButtonWidget extends StatelessWidget {
  final bool isLoading;

  const ResendButtonWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: null, // Disabled until server supports resending OTP
      child: Semantics(
        label: 'Resend code button (currently disabled)',
        child: Text(
          'Resend Code (disabled)',
          style: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying the submit button
class SubmitButtonWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final Color primaryColor;

  const SubmitButtonWidget({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                : const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }
}

/// Widget for displaying the help button
class HelpButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Color primaryColor;

  const HelpButtonWidget({
    super.key,
    required this.onPressed,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Semantics(
        label: 'Need help button',
        child: Text(
          'Need Help?',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
