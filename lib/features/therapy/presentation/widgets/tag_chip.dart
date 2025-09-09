import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String tag;
  final Color? backgroundColor; // Optional background color
  final Color? textColor; // Optional text color
  final VoidCallback? onTap; // Optional tap callback

  const TagChip({
    super.key,
    required this.tag,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Default colors if not provided
    final Color bgColor =
        backgroundColor ?? const Color(0xFF4A90E2).withOpacity(0.1);
    final Color txtColor = textColor ?? const Color(0xFF4A90E2);

    return GestureDetector(
      onTap: onTap, // Enable tap functionality
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ), // Slightly increased padding
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: txtColor.withOpacity(
              0.3,
            ), // Subtle border matching text color
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            14,
          ), // Slightly larger radius for modern look
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 11, // Slightly larger for readability
            color: txtColor,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis, // Handle long text
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
