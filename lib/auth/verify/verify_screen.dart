import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:circular_countdown_timer/countdown_text_format.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:workshop_app/service/api_service/api_urls.dart';
import '../../core/design/app_button.dart';
import '../../core/design/custom_app_bar.dart';
import '../../core/design/title_text.dart';
import '../../core/logic/helper_methods.dart';
import '../../core/regex/app_regex.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/text_style_theme.dart';
import '../reset_password/reset_password_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String email;
  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final formKey = GlobalKey<FormState>();
  final verifyCodeController = TextEditingController();
  final verifyCodeFocusNode = FocusNode();
  bool isTimerFinished = false;
  bool isLoading = false;

  // 🔹 دالة للتحقق من الكود
  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });

    // const String verifyUrl = "http://192.168.248.153/car_api/verify_code.php";
    final body = {
      "email": widget.email,
      "otp_code": verifyCodeController.text.trim(),
    };

    try {
      final response = await http.post(Uri.parse(ApiUrls.verifyCode), body: body);
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  style: TextStyle(color: Colors.white),
                  "Verification successful"),
              backgroundColor: Colors.green),
        );

        // Navigate to the password reset screen
        navigateTo(
            toPage: ResetPasswordScreen(
          email: widget.email, // تمرير البريد الإلكتروني الذي أدخله المستخدم
          otpCode: verifyCodeController.text
              .trim(), // تمرير رمز التحقق الذي أدخله المستخدم
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  style: TextStyle(color: Colors.white),
                  "Invalid verification code"),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                style: TextStyle(color: Colors.white),
                "Failed to connect to the server."),
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
              label: AppStrings.pleaseCheckYourEmail,
              style: TextStyleTheme.textStyle26Bold,
            ),
            verticalSpace(10),
            CustomTextWidget(
              label: "We’ve sent a code to ${widget.email}",
              style: TextStyleTheme.textStyle16Regular,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpace(30),
            Form(
              key: formKey,
              child: PinCodeTextField(
                controller: verifyCodeController,
                obscureText: true,
                textStyle: TextStyleTheme.textStyle32medium,
                cursorColor: AppColor.primary,
                focusNode: verifyCodeFocusNode,
                textInputAction: TextInputAction.done,
                obscuringCharacter: "*",
                appContext: context,
                length: 4,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !AppRegex.hasNumber(value)) {
                    return "يرجى إدخال الكود";
                  }
                  return null;
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(15.r),
                  fieldHeight: 64.h,
                  fieldWidth: 64.h,
                  inactiveColor: Color(0xffD8DADC),
                  selectedColor: AppColor.primary,
                  activeColor: AppColor.primary,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            verticalSpace(20),
            AppButton(
              textStyle: TextStyle(color: AppColor.white),
              text: AppStrings.verify,
              onPress: () async {
                if (formKey.currentState!.validate()) {
                  verifyOTP(); // ✅ استدعاء التحقق من الرمز
                }
              },
              isLoading: isLoading, icon: Icon(Icons.check), // زر تحميل أثناء الطلب
            ),
            verticalSpace(22),
            isTimerFinished
                ? const SizedBox.shrink()
                : CircularCountDownTimer(
                    duration: 60,
                    initialDuration: 0,
                    width: 66.w,
                    height: 70.h,
                    ringColor: AppColor.primary,
                    fillColor: const Color(0xffD8D8D8),
                    strokeWidth: 3,
                    onComplete: () {
                      setState(() {
                        isTimerFinished = true;
                      });
                    },
                    textStyle: TextStyleTheme.textStyle16SemiBold,
                    textFormat: CountdownTextFormat.MM_SS,
                    isReverseAnimation: true,
                  ),
            verticalSpace(19),
            isTimerFinished
                ? Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColor.primary, width: 2),
                      ),
                      onPressed: () {
                        setState(() {
                          isTimerFinished = false;
                        });
                      },
                      child: CustomTextWidget(
                        label: AppStrings.resendCode,
                        style: TextStyleTheme.textStyle16SemiBold,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
