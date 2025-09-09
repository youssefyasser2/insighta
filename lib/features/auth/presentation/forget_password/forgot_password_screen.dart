// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:test_app/core/constants/color_manager.dart';
// import 'package:test_app/features/auth/logic/auth_cubit.dart';
// import 'package:test_app/features/auth/presentation/forget_password/forgot_password_controller.dart';
// import 'package:test_app/features/auth/presentation/widgets/auth_screen.dart';
// import 'package:test_app/features/auth/presentation/widgets/auth_text_field.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   late ForgotPasswordController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = ForgotPasswordController(
//       authCubit: context.read<AuthCubit>(),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AuthScreen(
//       title: "Forgot Password",
//       fields: [
//         const SizedBox(height: 10),
//         const Text(
//           "Enter your email address to reset your password",
//           style: TextStyle(fontSize: 16, color: Colors.black54),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         AuthTextField(
//           label: "Email",
//           controller: _controller.emailController,
//           keyboardType: TextInputType.emailAddress,
//           validator: _controller.validateEmail,
//         ),
//         const SizedBox(height: 20),
//       ],
//       buttonText: "Reset Password", // ✅ Fix: Use buttonText instead of button
//       onButtonPressed: _controller.submitForm, // ✅ Fix: Use onButtonPressed
//       buttonColor:
//           ColorManager.primaryColor, // ✅ Fix: Ensure this parameter exists
//       buttonTextColor: Colors.white,
//       footerText: "Back to Login",
//       onFooterPressed: () => context.go('/'),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}