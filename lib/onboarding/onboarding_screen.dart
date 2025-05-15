import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/auth/sign_up/sign_up_screen.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/design/app_image.dart';
import 'package:workshop_app/core/design/title_text.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/app_strings.dart';
import 'package:workshop_app/core/utils/assets.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/core/utils/text_style_theme.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import 'package:workshop_app/view/home/homeview.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // *للاختبار فقط*: مسح بيانات SharedPreferences عشان الـ OnboardingScreen تظهر
    await prefs.clear();

    final userId = prefs.getInt('userId');
    final isGuest = prefs.getBool('isGuest') ?? false;

    if (userId != null && userId != 0 && !isGuest) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppImage(
                  fit: BoxFit.scaleDown,
                  AppImages.onboarding,
                  height: 460.h,
                  width: 340.w,
                ),
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
                  navigateTo(toPage: const SignUpScreen());
                },
              ),
              verticalSpace(16),
              AppButton(
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    side: BorderSide(color: AppColor.primary),
                  ),
                ),
                textStyle: TextStyle(color: AppColor.primary),
                text: AppStrings.login,
                onPress: () async {
                  navigateTo(toPage: const LoginScreen());
                },
              ),
              verticalSpace(4),
              GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isGuest', true);
                  navigateTo(toPage: const HomeView());
                },
                child: AnimatedScale(
                  scale: _scale,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // هنا يتم استخدام أيقونة لوجو بدلاً من الصورة
                      Icon(
                        Icons.gesture, // اختر أيقونة تعبر عن اللوجو الخاص بك
                        color: AppColor.primary,
                        size: 24.sp, // حجم الأيقونة
                      ),
                      horizontalSpace(8), // المسافة بين الأيقونة والنص
                      Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color: AppColor.darkGray,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          // ignore: deprecated_member_use
                          decorationColor: AppColor.darkGray.withOpacity(0.8),
                          decorationThickness: 1,
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}























// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workshop_app/auth/sign_up/sign_up_screen.dart';
// import 'package:workshop_app/core/design/app_button.dart';
// import 'package:workshop_app/core/design/app_image.dart';
// import 'package:workshop_app/core/design/title_text.dart';
// import 'package:workshop_app/core/logic/helper_methods.dart';
// import 'package:workshop_app/core/utils/app_color.dart';
// import 'package:workshop_app/core/utils/app_strings.dart';
// import 'package:workshop_app/core/utils/assets.dart';
// import 'package:workshop_app/core/utils/spacing.dart';
// import 'package:workshop_app/core/utils/text_style_theme.dart';
// import 'package:workshop_app/auth/login/login_screen.dart';

// import 'package:workshop_app/view/home/homeview.dart';


// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkUserStatus();
//   }

//   Future<void> _checkUserStatus() async {
//     final prefs = await SharedPreferences.getInstance();

//     // *للاختبار فقط*: مسح بيانات SharedPreferences عشان الـ OnboardingScreen تظهر
//     // بعد ما تتأكد إن المشكلة اتحلت، اعمل comment للسطر ده
//     await prefs.clear(); // يمسح كل البيانات (userId, isGuest, إلخ)

//     final userId = prefs.getInt('userId');
//     final isGuest = prefs.getBool('isGuest') ?? false;

//     // لو فيه userId ومش ضيف، يروح لـ HomeView
//     if (userId != null && userId != 0 && !isGuest) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeView()),
//       );
//     }
//     // لو مفيش userId أو هو ضيف، هيفضل في OnboardingScreen
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.h),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: AppImage(
//                   fit: BoxFit.scaleDown,
//                   AppImages.onboarding,
//                   height: 460.h,
//                   width: 340.w,
//                 ),
//               ),
//               CustomTextWidget(
//                 label: AppStrings.welcome,
//                 style: TextStyleTheme.textStyle32SemiBold,
//               ),
//               verticalSpace(30),
//               AppButton(
//                 textStyle: TextStyle(color: AppColor.white),
//                 text: AppStrings.signUp,
//                 onPress: () async {
//                   navigateTo(toPage: const SignUpScreen());
//                 },
//               ),
//               verticalSpace(16),
//               AppButton(
//                 buttonStyle: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                     side: BorderSide(color: AppColor.primary),
//                   ),
//                 ),
//                 textStyle: TextStyle(color: AppColor.primary),
//                 text: AppStrings.login,
//                 onPress: () async {
//                   navigateTo(toPage: const LoginScreen());
//                 },
//               ),
//               verticalSpace(4),
//               TextButton(
//                 onPressed: () async {
//                   final prefs = await SharedPreferences.getInstance();
//                   await prefs.setBool('isGuest', true);
//                   navigateTo(toPage: const HomeView());
//                 },
//                 child: Text(
//                   'Continue as Guest',
//                   style: TextStyle(
//                     color: AppColor.darkGray,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     decoration: TextDecoration.underline,
//                     decorationColor: const Color.fromARGB(255, 134, 134, 139),
//                     decorationThickness: 1,
//                     decorationStyle: TextDecorationStyle.solid,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//     ),
// );
// }
// }

//========================================
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:workshop_app/auth/login/login_screen.dart';
// import 'package:workshop_app/auth/sign_up/sign_up_screen.dart';
// import 'package:workshop_app/core/design/app_button.dart';
// import 'package:workshop_app/core/design/title_text.dart';
// import 'package:workshop_app/core/logic/helper_methods.dart';
// import 'package:workshop_app/core/utils/app_color.dart';
// import 'package:workshop_app/core/utils/app_strings.dart';
// import 'package:workshop_app/core/utils/spacing.dart';
// import 'package:workshop_app/core/utils/text_style_theme.dart';
// import '../core/design/app_image.dart';
// import '../core/utils/assets.dart';

// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.h),
//           child: Column(
//             children: [
//               AppImage(
//                 fit: BoxFit.scaleDown,
//                 AppImages.onboarding,
//                 height: 460.h,
//                 width: 340.w,
//               ),
//               CustomTextWidget(
//                 label: AppStrings.welcome,
//                 style: TextStyleTheme.textStyle32SemiBold,
//               ),
//               verticalSpace(30),
//               AppButton(
//                 textStyle: TextStyle(color: AppColor.white),
//                 text: AppStrings.signUp,
//                 onPress: () async {
//                   navigateTo(toPage: SignUpScreen());
//                 },
//               ),
//               verticalSpace(16),
//               AppButton(
//                 buttonStyle: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                     side: BorderSide(
//                       color: AppColor.primary,
//                     ),
//                   ),
//                 ),
//                 textStyle: TextStyle(color: AppColor.primary),
//                 text: AppStrings.login,
//                 onPress: () async {
//                   navigateTo(toPage: LoginScreen());
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
