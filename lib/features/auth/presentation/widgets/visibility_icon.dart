import 'package:flutter/material.dart';

class VisibilityIcon extends StatelessWidget {
  final bool isVisible;
  final VoidCallback toggleVisibility;

  const VisibilityIcon({
    super.key,
    required this.isVisible,
    required this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey.shade600,
        size: 20,
      ),
      splashRadius: 18,
      onPressed: toggleVisibility,
    );
  }
}
