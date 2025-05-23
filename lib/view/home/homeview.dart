import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workshop_app/core/design/app_image.dart';
import 'package:workshop_app/core/utils/app_color.dart';
import 'package:workshop_app/core/utils/assets.dart';
import 'package:workshop_app/service/chat_boot/screen/dashboard_screen.dart';
import 'package:workshop_app/view/pages/account/my_account_page.dart';
import 'package:workshop_app/view/pages/main/main_page.dart';
import 'package:workshop_app/view/pages/notification/notification_page.dart';
import 'package:workshop_app/view/pages/order/order_page.dart';

//import 'package:workshop_app/view/pages/notification/notification_page.dart';
//import 'package:workshop_app/view/pages/order/order_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

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

  // المتغيرات الخاصة بمكان الزر العائم
  double posX = 100;
  double posY = 100;
  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
      body: Stack(
        children: [
          // الصفحة الحالية بناءً على currentIndex
          pages[currentIndex],

          // الزر العائم المتحرك
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: posX,
            top: posY,
            child: Draggable(
              feedback: _buildButton(),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                double newX = details.offset.dx;
                double newY = details.offset.dy - AppBar().preferredSize.height;

                // التأكد ان الزر ما يخرجش برا الشاشة
                if (newX < 0) newX = 0;
                if (newX > screenWidth - 45)
                  newX = screenWidth - 45; // 45 حجم الزر
                if (newY < 0) newY = 0;
                if (newY > screenHeight - 45) newY = screenHeight - 45;

                setState(() {
                  // يلزق ناحية اليمين أو الشمال حسب مكانه
                  if (newX + 28 > screenWidth / 2) {
                    posX = screenWidth - 45; // يلزق يمين
                  } else {
                    posX = 0; // يلزق شمال
                  }
                  posY = newY;
                });
              },
              child: _buildButton(),
            ),
          ),
        ],
      ),

      // BottomNavigationBar
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

  Widget _buildButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  DashboardScreen()),
        );
      },
      backgroundColor: AppColor.primary,
      child: Image.asset(
        'assets/icons/robot.png',
        height: 30,
        width: 30,
      ), // لو عايز تغير لون الخلفية
    );
  }
}

