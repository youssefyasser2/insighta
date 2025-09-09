import 'package:flutter/material.dart';
import 'package:test_app/features/home/home_screen.dart';
import '../core/utils/auth_storage.dart';

class NoAuthGuard extends StatelessWidget {
  final Widget child;

  const NoAuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthStorage.getAccessToken(), // ✅ Correct static method call
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return const HomeScreen();
        }

        return child;
      },
    );
  }
}
