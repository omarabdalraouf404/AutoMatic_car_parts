import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/design/app_image.dart';
import '../../core/design/title_text.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/text_style_theme.dart';

class AccountItem extends StatelessWidget {
  final String title, icon;
  final void Function()? onTap;
  const AccountItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppImage(icon, height: 33.h, width: 33.h),
        horizontalSpace(30),
        GestureDetector(
          onTap: onTap,
          child: CustomTextWidget(
            label: title,
            style: TextStyleTheme.textStyle17medium,
          ),
        ),
      ],
    );
  }
}
