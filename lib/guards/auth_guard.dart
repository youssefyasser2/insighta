import 'package:flutter/material.dart';
import 'package:test_app/features/auth/presentation/login/login_screen.dart';
import '../core/utils/auth_storage.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthStorage.getAccessToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data?.isEmpty ?? true) {
          return const LoginScreen();
        }

        return child;
      },
    );
  }
}
