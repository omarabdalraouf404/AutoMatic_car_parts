import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/core/utils/assets.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import '../../core/design/app_button.dart';
import '../../core/design/app_input.dart';
import '../../core/design/custom_app_bar.dart';
import '../../core/design/title_text.dart';
import '../../core/logic/helper_methods.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/spacing.dart';
import '../success_password_changed/success_password_changed_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otpCode;

  const ResetPasswordScreen(
      {super.key, required this.email, required this.otpCode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false; // متغير لتحديد حالة التحميل

  // ✅ دالة لإعادة تعيين كلمة المرور
  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return; // Ensure input validation

    setState(() {
      isLoading = true;
    });

    const String apiUrl =
        "http://192.168.1.5/car_api/reset_password.php"; // Ensure the correct API URL

    final response = await http.post(Uri.parse(apiUrl), body: {
      "email": widget.email, // Registered email
      "otp_code": widget.otpCode, // Verification code (OTP)
      "new_password": passwordController.text.trim(), // New password
    });

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 && result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                style: TextStyle(color: Colors.white),
                "Password updated successfully"),
            backgroundColor: Colors.green),
      );

      // ✅ Navigate to the SuccessPasswordChangedScreen page
      navigateTo(toPage: SuccessPasswordChangedScreen(), isRemove: true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(style: TextStyle(color: Colors.white), result['message']),
            backgroundColor: Colors.red),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          children: [
            CustomTextWidget(
              label: AppStrings.resetPassword,
              style: TextStyleTheme.textStyle30Bold,
            ),
            verticalSpace(10),
            CustomTextWidget(
              label: AppStrings.pleaseRemember,
              style: TextStyleTheme.textStyle16Regular,
            ),
            verticalSpace(30),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    label: AppStrings.password,
                    style: TextStyleTheme.textStyle14SemiBold,
                  ),
                  AppInput(
                    hintText: AppStrings.password,
                    controller: passwordController,
                    icon: AppImages.password,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى إدخال كلمة المرور";
                      }
                      if (value.length < 6) {
                        return "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل";
                      }
                      return null;
                    },
                  ),
                  CustomTextWidget(
                    label: AppStrings.confirmPassword,
                    style: TextStyleTheme.textStyle14SemiBold,
                  ),
                  AppInput(
                    hintText: AppStrings.confirmPassword,
                    controller: confirmPasswordController,
                    icon: AppImages.password,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى تأكيد كلمة المرور";
                      }
                      if (value != passwordController.text) {
                        return "كلمة المرور غير متطابقة";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            verticalSpace(20),
            AppButton(
              textStyle: TextStyle(color: AppColor.white),
              text: isLoading ? "جاري التحديث..." : AppStrings.resetPassword,
              isLoading: isLoading, // عرض مؤشر التحميل أثناء العملية
              onPress: resetPassword, // استدعاء API لتحديث كلمة المرور
            ),
          ],
        ),
      ),
    );
  }
}
