import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/core/design/app_image.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:workshop_app/onboarding/intro_screen.dart';
import 'package:workshop_app/view/Home/homeview.dart';
import '../core/logic/cache_helper.dart';
import '../core/utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String welcomeText = "";
  final String fullText = "جاهز تلاقي قطعة غيارك بسهولة؟ 🚗";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    typeWriterEffect();
    navigate();
  }

  void typeWriterEffect() {
    int index = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (index < fullText.length) {
        setState(() {
          welcomeText += fullText[index];
        });
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  void navigate() async {
    Timer(
      const Duration(seconds: 4),
      () {
        if (CacheHelper.isAuth()) {
          navigateTo(toPage: const HomeView(), isRemove: true);
        } else {
          navigateTo(toPage: IntroScreen(), isRemove: true);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء ثابتة
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeIn(
              duration: const Duration(milliseconds: 1500),
              child: ScaleTransition(
                scale: _animation,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: AppImage(
                    AppImages.appLogo,
                    height: 310.h,
                    width: 310.h,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Text(
                welcomeText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:async';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_particles/flutter_particles.dart'; // ضفنا مكتبة النجوم
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:workshop_app/onboarding/onboarding_screen.dart';
// import 'package:workshop_app/view/Home/homeview.dart';
// import '../core/design/app_image.dart';
// import '../core/logic/cache_helper.dart';
// import '../core/logic/helper_methods.dart';
// import '../core/utils/assets.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => SplashScreenState();
// }

// class SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   String welcomeText = "";
//   final String fullText = "جاهز تلاقي قطعة غيارك بسهولة؟ 🚗";

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _animation = Tween<double>(begin: 0.9, end: 1.1)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     typeWriterEffect();
//     navigate();
//   }

//   void typeWriterEffect() {
//     int index = 0;
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (index < fullText.length) {
//         setState(() {
//           welcomeText += fullText[index];
//         });
//         index++;
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   void navigate() async {
//     Timer(
//       const Duration(seconds: 4),
//       () => navigateTo(
//         toPage:
//             CacheHelper.isAuth() ? const HomeView() : const OnboardingScreen(),
//         isRemove: true,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // خلفية النجوم
//           Particl(
//             30, // عدد النجوم
//             Colors.blueAccent.withOpacity(0.4), // لون النجوم
//           ),

//           // المحتوى الرئيسي فوق النجوم
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FadeIn(
//                   duration: const Duration(milliseconds: 1500),
//                   child: ScaleTransition(
//                     scale: _animation,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.3),
//                             blurRadius: 25,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: AppImage(
//                         AppImages.appLogo,
//                         height: 310.h,
//                         width: 310.h,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 FadeInUp(
//                   duration: const Duration(milliseconds: 2000),
//                   child: Text(
//                     welcomeText,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



//==========================

// import 'dart:async';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:workshop_app/onboarding/onboarding_screen.dart';
// import 'package:workshop_app/view/Home/homeview.dart';
// import '../core/design/app_image.dart';
// import '../core/logic/cache_helper.dart';
// import '../core/logic/helper_methods.dart';
// import '../core/utils/assets.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..forward();

//     _animation = Tween<double>(begin: 0.8, end: 1.2)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     navigate();
//   }

//   void navigate() async {
//     Timer(
//       const Duration(seconds: 3),
//       () => navigateTo(
//         toPage:
//             CacheHelper.isAuth() ? const HomeView() : const OnboardingScreen(),
//         isRemove: true,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FadeIn(
//           duration: const Duration(milliseconds: 1500),
//           child: ScaleTransition(
//             scale: _animation,
//             child: AppImage(
//               AppImages.appLogo,
//               height: 310.h,
//               width: 310.h,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }









//------------------------------------------
//ده الاصل والاسااسسسسييي
// import 'dart:async';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:workshop_app/onboarding/onboarding_screen.dart';
// import 'package:workshop_app/view/Home/homeview.dart';
// import '../core/design/app_image.dart';
// import '../core/logic/cache_helper.dart';
// import '../core/logic/helper_methods.dart';
// import '../core/utils/assets.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     navigate();
//   }

//   void navigate() async {
//     Timer(
//       Duration(seconds: 3),
//       () => navigateTo(
//         //toPage: OnboardingScreen(),
//         toPage:
//             CacheHelper.isAuth() ? const HomeView() : const OnboardingScreen(),
//         isRemove: true,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FadeInDown(
//           child: AppImage(AppImages.appLogo, height: 310.h, width: 310.h),
//         ),
//       ),
//     );
//   }
// }
