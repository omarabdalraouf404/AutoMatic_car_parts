import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/core/utils/app_color.dart' as color;
import 'package:workshop_app/onboarding/onboarding_screen.dart';
//import 'package:workshop_app/view/Home/homeview.dart';
// عدل على حسب اسم الشاشة الرئيسية عندك

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final List<PageViewModel> pages = [
    PageViewModel(
      titleWidget: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            "Welcome to Auto Parts App",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color.AppColor.primary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "We help you find original car parts easily and securely",
          style: TextStyle(fontSize: 18, height: 1.5, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Image.asset('assets/images/intro1.png', height: 300),
      ),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(top: 40),
        bodyAlignment: Alignment.center,
        titlePadding: EdgeInsets.only(top: 20),
      ),
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            "Easy and Fast",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color.AppColor.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "Browse, select, and order parts in simple quick steps",
          style: TextStyle(fontSize: 18, height: 1.5, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Image.asset('assets/images/intro3.png', height: 300),
      ),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(top: 40),
        bodyAlignment: Alignment.center,
        titlePadding: EdgeInsets.only(top: 20),
      ),
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            "Guaranteed Quality",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color:color.AppColor.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "We provide original and certified parts to ensure your car's best performance",
          style: TextStyle(fontSize: 18, height: 1.5, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Image.asset('assets/images/intro2.png', height: 300),
      ),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(top: 40),
        bodyAlignment: Alignment.center,
        titlePadding: EdgeInsets.only(top: 20),
      ),
    ),
  ];

  Future<void> _onIntroEnd(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntro', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  //   Future<void> _onIntroEnd(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('seenIntro', true);  // تخزين قيمة أنه تم عرض الشاشة

  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (_) => const HomeView()),
  //   );
  // }

  // Future<void> _onIntroEnd(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('seenIntro', true);

  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (_) => const HomeView()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      showSkipButton: true,
      skip: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue[50],
        ),
        child: Text(
          "Skip",
          style: TextStyle(
            fontSize: 16,
            color: color.AppColor.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      next: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.AppColor.primary,
        ),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.AppColor.primary,
        ),
        child: const Text(
          "Start",
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onDone: () => _onIntroEnd(context),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey[300]!,
        activeSize: const Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        activeColor: color.AppColor.primary,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      globalBackgroundColor: Colors.white,
    );
  } 
}