// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:test_app/features/auth/logic/auth_cubit.dart';
// import 'package:test_app/features/auth/logic/auth_state.dart';

// class ForgotPasswordController {
//   final AuthCubit authCubit;
//   final TextEditingController emailController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   ForgotPasswordController({required this.authCubit});

//   /// Validate the email field
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     if (!value.contains('@')) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }

//   /// Submit form to request password reset
//   void submitForm() {
//     if (formKey.currentState!.validate()) {
//       authCubit.forgotPassword(emailController.text);
//     }
//   }

//   /// Handle state changes
//   void handleState(BuildContext context, AuthState state) {
//     if (state is ForgotPasswordSuccess) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password reset email sent successfully!'),
//         ),
//       );
//       context.go('/'); // Redirect to login screen
//     } else if (state is AuthFailure) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(state.message)));
//     }
//   }

//   /// Dispose resources
//   void dispose() {
//     emailController.dispose();
//   }
// }

import 'package:flutter/material.dart';

class ForgotPasswordController extends StatelessWidget {
  const ForgotPasswordController({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}