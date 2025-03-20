import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/text_style_theme.dart';

class CustomRichText extends StatelessWidget {
  final String text, subText;
  final VoidCallback onTap;

  const CustomRichText({
    super.key,
    required this.text,
    required this.onTap,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: TextStyleTheme.textStyle14SemiBold,
            ),
            TextSpan(
              text: subText,
              recognizer: TapGestureRecognizer()..onTap = onTap,
              style: TextStyleTheme.textStyle14SemiBold.copyWith(
                color: AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
