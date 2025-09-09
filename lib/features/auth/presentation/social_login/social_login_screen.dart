import 'package:flutter/material.dart';

class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Social Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.facebook, color: Colors.white),
              label: const Text("Login with Facebook"),
              onPressed: () {
                // استدعاء دالة تسجيل الدخول عبر فيسبوك
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.g_mobiledata, color: Colors.white),
              label: const Text("Login with Google"),
              onPressed: () {
                // استدعاء دالة تسجيل الدخول عبر جوجل
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
