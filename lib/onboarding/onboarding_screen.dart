import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import 'package:workshop_app/auth/sign_up/sign_up_screen.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/app_strings.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import '../core/design/app_image.dart';
import '../core/utils/assets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.h),
          child: Column(
            children: [
              AppImage(
                fit: BoxFit.scaleDown,
                AppImages.onboarding,
                height: 460.h,
                width: 340.w,
              ),
              CustomTextWidget(
                label: AppStrings.welcome,
                style: TextStyleTheme.textStyle32SemiBold,
              ),
              verticalSpace(30),
              AppButton(
                textStyle: TextStyle(color: AppColor.white),
                text: AppStrings.signUp,
                onPress: () async {
                  navigateTo(toPage: SignUpScreen());
                },
              ),
              verticalSpace(16),
              AppButton(
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    side: BorderSide(
                      color: AppColor.primary,
                    ),
                  ),
                ),
                textStyle: TextStyle(color: AppColor.primary),
                text: AppStrings.login,
                onPress: () async {
                  navigateTo(toPage: LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
