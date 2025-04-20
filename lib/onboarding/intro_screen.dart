import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/onboarding/onboarding_screen.dart';
//import 'package:workshop_app/view/Home/homeview.dart'; 
// عدل على حسب اسم الشاشة الرئيسية عندك

class IntroScreen extends StatelessWidget {
  final List<PageViewModel> pages = [
      PageViewModel(
    titleWidget: Text(
      "Welcome",
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    ),
    bodyWidget: Text(
      "Our app helps you easily find your car spare parts.",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
    ),
    image:  Center(
      child: Icon(
      Icons.car_repair, // ايقونة عربية قطع غيار
      size: 120,
      color: Colors.blueAccent,
      ),
    ),
  ),
  PageViewModel(
    titleWidget: Text(
      "Easy and Fast",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    ),
    bodyWidget: Text(
      "Browse, search, and purchase in simple steps.",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
    ),
    image:  Center(
      child: Image.asset(
        'assets/images/intro3.png',
        width: 200,
      ),
    ),
  ),
  PageViewModel(
    titleWidget: Text(
      "Guaranteed Quality",
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    ),
    bodyWidget: Text(
      "We provide original and certified spare parts to ensure your car's best performance.",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
    ),
    image: Center(
      child: Image.asset(
        'assets/images/intro2.png',
        width: 200,
      ),
    ),
  ),
];
  Future<void> _onIntroEnd(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('seenIntro', true); // حفظ انه خلص الانترو

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
      skip: const Text("تخطي"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("ابدأ", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => _onIntroEnd(context),
    );
  }
}
