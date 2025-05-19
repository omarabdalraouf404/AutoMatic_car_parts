import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import 'package:workshop_app/auth/reset%20password%20account/reset_password_account.dart';
import 'package:workshop_app/auth/sign_up/sign_up_screen.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:workshop_app/core/utils/spacing.dart';
import 'package:workshop_app/view/widget/account_item.dart';
import '../../../core/design/custom_app_bar.dart';
import '../../../core/design/title_text.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/utils/assets.dart';
import '../../../core/utils/text_style_theme.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  String userName = '';
  String userEmail = '';
  int userId = 0;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuest = prefs.getBool('isGuest') ?? false;
      if (!isGuest) {
        userId = prefs.getInt('userId') ?? 0;
        userName = prefs.getString('userName') ?? 'مستخدم غير معرف';
        userEmail = prefs.getString('email') ?? 'بريد غير معرف';
        // لو مفيش userId بس مش ضيف، نعامله زي الضيف
        if (userId == 0) {
          isGuest = true;
        }
      }
    });

    if (userId == 0 && !isGuest) {
      print("User not found, please log in.");
    }
  }

  Future<void> _updatePasswordInPrefs(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', newPassword);
    print("Password updated in SharedPreferences");
  }

  Future<void> deleteAccount(int userId, BuildContext context) async {
    final url = Uri.parse('http://192.168.1.5/car_api/delete_account.php');
    final response = await http.post(url, body: {'userId': userId.toString()});

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        print("Account deleted successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              style: TextStyle(color: Colors.white),
              "Account deleted successfully!",
            ),
            backgroundColor: Colors.green,
          ),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // مسح كل البيانات

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        print("Failed to delete account: ${responseData['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to delete account: ${responseData['message']}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("Failed to connect to the server");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to connect to the server"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return Scaffold(
        appBar: CustomAppBar(
          height: 100.h,
          hideBack: true,
          title: CustomTextWidget(
            label: "Profile",
            style: TextStyleTheme.textStyle20Bold,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You are in Guest Mode",
                style: TextStyleTheme.textStyle18SemiBold,
              ),
              verticalSpace(20),
              Text(
                "Please sign in to access your account.",
                style: TextStyleTheme.textStyle15medium,
              ),
              verticalSpace(30),
              AppButton(
                text: "Go to Login",
                textStyle: TextStyle(
                  color: AppColor.white,
                ), // إضافة لون النص أبيض
                onPress: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isGuest'); // إزالة حالة الضيف
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              verticalSpace(20),
              AppButton(
                text: "Sign Up",
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.white,
                  side: BorderSide(color: AppColor.primary),
                ),
                textStyle: TextStyle(color: AppColor.primary),
                onPress: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isGuest'); // إزالة حالة الضيف
                  navigateTo(toPage: const SignUpScreen());
                },
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: CustomAppBar(
        height: 150.h,
        padding: EdgeInsets.only(left: 20.w),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100.r),
          bottomRight: Radius.circular(100.r),
        ),
        hideBack: true,
        action: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.h, right: 110.w, bottom: 16.h),
              child: CustomTextWidget(
                label: "Welcome",
                style: TextStyleTheme.textStyle32SemiBold.copyWith(
                  color: AppColor.white,
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.account_circle, color: Colors.white, size: 28.h),
                horizontalSpace(5),
                Padding(
                  padding: EdgeInsets.only(right: 110.w),
                  child: CustomTextWidget(
                    label: userName,
                    style: TextStyleTheme.textStyle15Bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 100.h),
          child: CustomTextWidget(
            label: "Profile",
            style: TextStyleTheme.textStyle20Bold,
          ),
        ),
        gradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            AppColor.primary.withOpacity(.86),
            Color.fromARGB(255, 29, 196, 99),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            child: Column(
              children: [
                verticalSpace(66),
                AccountItem(
                  title: "Edit Profile",
                  icon: AppImages.edit,
                  onTap: () {},
                ),
                verticalSpace(56),
                AccountItem(
                  title: "Change Password",
                  icon: AppImages.lock,
                  onTap: () {
                    navigateTo(toPage: ResetPasswordAccount(email: userEmail));
                  },
                ),
                verticalSpace(56),
                AccountItem(
                  title: "Support",
                  icon: AppImages.help,
                  onTap: () {},
                ),
                verticalSpace(56),
                AccountItem(
                  title: "Log Out",
                  icon: AppImages.logOut,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                verticalSpace(70),
                AppButton(
                  text: "Delete Account",
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffBB0B31),
                    fixedSize: Size(245.w, 36.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  textStyle: TextStyleTheme.textStyle15SemiBold.copyWith(
                    color: AppColor.white,
                  ),
                  onPress: () async {
                    if (userId != 0) {
                      await deleteAccount(userId, context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("User not found, please log in again"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
    ),
);
}
}
