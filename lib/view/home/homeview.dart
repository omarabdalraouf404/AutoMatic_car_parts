import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/core/design/app_image.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/assets.dart';
import 'package:workshop_app/view/pages/account/my_account_page.dart';
import 'package:workshop_app/view/pages/main/main_page.dart';
import 'package:workshop_app/view/pages/notification/notification_page.dart';
import 'package:workshop_app/view/pages/order/order_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({super.key});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int currentIndex = 0;

  List<Widget> pages = [
    MainPage(),
    NotificationPage(),
    MyOrdersPage(),
    MyAccountPage(),
  ];

  List<String> titles = ["Main", "Notification", "Order", "Account"];

  List<String> icons = [
    AppImages.home,
    AppImages.notification,
    AppImages.orders,
    AppImages.user,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.primary, width: 0.9)),
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          backgroundColor: AppColor.white,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: AppColor.black,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: List.generate(
            pages.length,
            (index) => BottomNavigationBarItem(
              icon: AppImage(
                icons[index],
                height: 28.h,
                width: 30.w,
                color:
                    currentIndex == index
                        ? Color.fromARGB(255, 29, 196, 99)
                        : AppColor.primary,
              ),
              label: titles[index],
            ),
          ),
        ),
      ),
    );
  }
}
