import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String label;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  const CustomTextWidget({
    super.key,
    required this.label,
    this.textAlign,
    this.maxLines, this.style,
    this.textDirection,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textDirection: textDirection,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      label,
      style: style,
    );
  }
}
