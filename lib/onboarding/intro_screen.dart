import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/view/Home/homeview.dart'; 
// عدل على حسب اسم الشاشة الرئيسية عندك

class IntroScreen extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "مرحباً بك",
      body: "تطبيقنا بيساعدك توصل لقطع غيار عربيتك بسهولة.",
      image: const Center(child: Icon(Icons.car_repair, size: 100)),
    ),
    PageViewModel(
      title: "سهل وسريع",
      body: "تصفح وابحث واشتري في خطوات بسيطة.",
      image: const Center(child: Icon(Icons.speed, size: 100)),
    ),
    PageViewModel(
      title: "دعم فني مستمر",
      body: "فريقنا جاهز لمساعدتك على مدار الساعة لأي استفسار أو مشكلة.",
      image: const Center(child: Icon(Icons.support_agent, size: 100)),
    ),
  ];

  Future<void> _onIntroEnd(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntro', true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

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
