import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/core/constants/color_manager.dart';
import 'package:test_app/core/constants/font_manager.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData? icon;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.icon,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  _AuthTextFieldState createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? _errorText;
  double _opacity = 0.0;
  double _translateY = -10;
  Timer? _timer;

  void _validate() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _errorText = widget.validator?.call(widget.controller?.text);
        _opacity = _errorText != null && _errorText!.isNotEmpty ? 1.0 : 0.0;
        _translateY = _opacity == 1.0 ? 0 : -10;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.89,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? widget.obscureText : false,
            keyboardType: widget.keyboardType,
            style: TextStyle(
              fontSize: FontManager.fontSizeMedium,
              color: ColorManager.textColor,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              labelText:
                  _errorText != null && _errorText!.isNotEmpty
                      ? "${widget.label} *"
                      : widget.label,
              labelStyle: TextStyle(
                color:
                    _errorText != null && _errorText!.isNotEmpty
                        ? ColorManager.errorColor
                        : Colors.grey.shade600,
                fontSize: FontManager.fontSizeSmall,
              ),
              prefixIcon:
                  widget.icon != null
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          widget.icon,
                          color: Colors.grey.shade700,
                          size: 22,
                        ),
                      )
                      : null,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
            ),
            onChanged: (value) => _validate(),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _opacity > 0 ? 20 : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _opacity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.translationValues(0, _translateY, 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: ColorManager.errorColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _errorText ?? "",
                      style: TextStyle(
                        color: ColorManager.errorColor,
                        fontSize: FontManager.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
