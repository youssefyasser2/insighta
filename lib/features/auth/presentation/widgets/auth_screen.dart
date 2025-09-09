import 'package:flutter/material.dart';
import 'package:test_app/core/constants/color_manager.dart';
import 'package:test_app/core/constants/font_manager.dart';
import 'package:test_app/features/auth/presentation/widgets/auth_footer_text.dart';
import 'package:test_app/features/auth/presentation/widgets/auth_main_button.dart';
import 'package:test_app/features/auth/presentation/widgets/social_login_buttons.dart';


class AuthScreen extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final Widget? extraWidgets;
  final String buttonText;
  final String footerText;
  final VoidCallback? onFooterPressed;
  final Widget? headerWidget;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final VoidCallback? onButtonPressed;
  final Function(String)? onSocialLoginPressed;
  final TextAlign? titleAlignment;
  final double? titleFontSize;
  final EdgeInsetsGeometry? titlePadding;

  const AuthScreen({
    super.key,
    required this.title,
    required this.fields,
    this.extraWidgets,
    required this.buttonText,
    required this.footerText,
    this.onFooterPressed,
    this.headerWidget,
    this.buttonColor,
    this.buttonTextColor,
    this.onButtonPressed,
    this.onSocialLoginPressed,
    this.titleAlignment = TextAlign.center,
    this.titleFontSize,
    this.titlePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ✅ Display header if available
          if (headerWidget != null) ...[
            headerWidget!,
            const SizedBox(height: 25),
          ],

          // ✅ Main title
          Padding(
            padding: titlePadding ?? const EdgeInsets.only(left: 11),
            child: Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize ?? FontManager.fontSizeExtraLarge,
                fontWeight: FontManager.fontWeightBold,
                color: ColorManager.primaryColor,
              ),
              textAlign: titleAlignment,
            ),
          ),

          const SizedBox(height: 15),

          // ✅ Input fields
          ...fields,

          // ✅ Extra widgets (e.g., "Forgot password?" link)
          if (extraWidgets != null) ...[
            const SizedBox(height: 2),
            extraWidgets!,
          ],

          const SizedBox(height: 35),

          // ✅ Primary action button (Login/Signup)
          AuthMainButton(
            text: buttonText,
            onPressed: onButtonPressed,
            buttonColor: buttonColor,
            textColor: buttonTextColor,
          ),

          const SizedBox(height: 10),

          // ✅ Social login buttons (Facebook, Google, Apple)
          SocialLoginButtons(onSocialLoginPressed: onSocialLoginPressed),

          const SizedBox(height: 80),

          // ✅ Footer text (Switch between login & sign-up)
          AuthFooterText(footerText: footerText, onPressed: onFooterPressed),
        ],
      ),
    );
  }
}
