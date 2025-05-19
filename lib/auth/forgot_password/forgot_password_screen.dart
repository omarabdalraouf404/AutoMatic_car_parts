import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:workshop_app/auth/verify/verify_screen.dart';
import 'package:workshop_app/service/api_service/api_urls.dart';
import '../../core/design/app_button.dart';
import '../../core/design/app_input.dart';
import '../../core/design/custom_app_bar.dart';
import '../../core/design/title_text.dart';
import '../../core/logic/helper_methods.dart';
import '../../core/regex/app_regex.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/assets.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/text_style_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  bool isLoading = false; // متغير لحالة التحميل

  Future<void> sendResetCode() async {
    // const String forgotPasswordUrl =
    //     "http://192.168.248.153/car_api/forgot_password.php"; // Ensure the correct API URL
    final body = {
      "email": emailController.text.trim(),
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.post(Uri.parse(ApiUrls.forgotPassword), body: body);
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                style: TextStyle(color: Colors.white),
                "Verification code has been sent to your email."),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the verification screen
        navigateTo(toPage: VerifyScreen(email: emailController.text));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(style: TextStyle(color: Colors.white), result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              style: TextStyle(color: Colors.white),
              "Failed to connect to the server. Please check your internet connection."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              label: AppStrings.forgotPassword,
              style: TextStyleTheme.textStyle30Bold,
            ),
            verticalSpace(10),
            CustomTextWidget(
              label: AppStrings.pleaseEnterTheEmail,
              style: TextStyleTheme.textStyle16Regular,
            ),
            verticalSpace(30),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    label: AppStrings.email,
                    style: TextStyleTheme.textStyle14SemiBold,
                  ),
                  AppInput(
                    hintText: AppStrings.email,
                    controller: emailController,
                    focusNode: emailFocusNode,
                    icon: AppImages.email,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !AppRegex.isEmailValid(value)) {
                        return "يرجى إدخال بريد إلكتروني صحيح.";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    type: TextInputType.emailAddress,
                    paddingBottom: 30.h,
                    paddingTop: 5.h,
                  ),
                ],
              ),
            ),
            AppButton(
              textStyle: TextStyle(color: AppColor.white),
              text: AppStrings.sendCode,
              onPress: () async {
                if (formKey.currentState!.validate()) {
                  await sendResetCode(); // استدعاء API لإرسال الكود
                }
              },
              isLoading: isLoading, // زر التحميل أثناء الإرسال
            ),
          ],
        ),
      ),
    );
  }
}
