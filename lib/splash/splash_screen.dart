import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/onboarding/onboarding_screen.dart';
import 'package:workshop_app/view/Home/homeview.dart';
import '../core/design/app_image.dart';
import '../core/logic/cache_helper.dart';
import '../core/logic/helper_methods.dart';
import '../core/utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    Timer(
      Duration(seconds: 3),
      () => navigateTo(
        //toPage: OnboardingScreen(),
        toPage:
            CacheHelper.isAuth() ? const HomeView() : const OnboardingScreen(),
        isRemove: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeInDown(
          child: AppImage(AppImages.appLogo, height: 310.h, width: 310.h),
        ),
      ),
    );
  }
}
