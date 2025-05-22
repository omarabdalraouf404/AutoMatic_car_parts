import 'package:flutter/material.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import '../../core/design/app_button.dart';
import '../../core/logic/helper_methods.dart';
import '../../core/utils/app_color.dart';

class SuccessPasswordChangedScreen extends StatelessWidget {
  const SuccessPasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWidget(
                label: "Password changed",
                style: TextStyleTheme.textStyle30Bold,
              ),
              verticalSpace(10),
              CustomTextWidget(
                textAlign: TextAlign.center,
                label: "Your password has been changed\n succesfully",
                style: TextStyleTheme.textStyle16Regular,
              ),
              verticalSpace(40),
              AppButton(
                textStyle: TextStyle(color: AppColor.white),
                text: "Back to login",
                icon: Icon(Icons.login, color: AppColor.white),
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
