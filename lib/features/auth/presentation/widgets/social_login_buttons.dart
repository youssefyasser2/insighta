import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final Function(String)? onSocialLoginPressed;

  const SocialLoginButtons({super.key, this.onSocialLoginPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 100, height: 1, color: Colors.black54),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "or continue with",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Container(width: 100, height: 1, color: Colors.black54),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              Icons.facebook,
              "Facebook",
              Colors.blue,
              screenWidth,
            ),
            const SizedBox(width: 20),
            _buildIconButton(
              Icons.g_translate,
              "Google",
              Colors.red,
              screenWidth,
            ),
            const SizedBox(width: 20),
            _buildIconButton(Icons.apple, "Apple", Colors.black, screenWidth),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(
    IconData icon,
    String platform,
    Color color,
    double screenWidth,
  ) {
    return GestureDetector(
      onTap: () => onSocialLoginPressed?.call(platform),
      child: Container(
        width: screenWidth * 0.25,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 203, 195, 195)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
