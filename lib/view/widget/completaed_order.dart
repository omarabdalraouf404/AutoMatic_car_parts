import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/design/app_image.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/assets.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/view/home/homeview.dart';

class CompletedOrder extends StatelessWidget {
  const CompletedOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage(AppImages.completedOrder, height: 196.h, width: 362.w),
              CustomTextWidget(
                label: "Order num: 258635",
                style: TextStyleTheme.textStyle16regular,
              ),
              verticalSpace(30),
              AppButton(
                icon: const Icon(Icons.done),
                text: "Done",
                textStyle: TextStyleTheme.textStyle16SemiBold.copyWith(
                  color: AppColor.white,
                ),
                onPress: () async {
                  navigateTo(toPage: HomeView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
