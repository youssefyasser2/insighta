import 'package:flutter/material.dart';
import 'package:test_app/core/constants/font_manager.dart';

class AuthMainButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape; // ✅ تغيير ShapeBorder إلى OutlinedBorder

  const AuthMainButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonColor,
    this.textColor,
    this.width = 350,
    this.height = 61.1,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.shape, // ✅ استخدام OutlinedBorder بدلاً من ShapeBorder
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            elevation: 5,
            backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
            shape:
                shape ??
                RoundedRectangleBorder(
                  // ✅ الآن متوافق مع OutlinedBorder
                  borderRadius: BorderRadius.circular(8),
                ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: FontManager.fontSizeLarge,
              fontWeight: FontManager.fontWeightBold,
            ),
          ),
        ),
      ),
    );
  }
}
