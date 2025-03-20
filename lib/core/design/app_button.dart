import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final Future<void> Function()? onPress; // دعم الدوال غير المتزامنة
  final bool isLoading; // حالة التحميل

  const AppButton({
    super.key,
    required this.text,
    required this.onPress,
    this.buttonStyle,
    this.textStyle,
    this.isLoading = false, // القيمة الافتراضية لـ isLoading
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: isLoading
          ? null
          : () async {
              if (onPress != null) {
                await onPress!(); // استدعاء الدالة عند الضغط على الزر
              }
            },
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
    );
  }
}
