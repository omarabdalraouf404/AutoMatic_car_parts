import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/splash/splash_screen.dart';
import 'core/logic/helper_methods.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/app_strings.dart';

class WorkShopApp extends StatelessWidget {
  const WorkShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            navigatorKey: navigatorKey,
            theme: AppTheme.appTheme,
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            home: child,
          ),
      child: const SplashScreen(),
    );
  }
}
