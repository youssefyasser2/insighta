import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/core/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Dark Mode",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
          activeColor: Colors.teal,
        ),
      ],
    );
  }
}
