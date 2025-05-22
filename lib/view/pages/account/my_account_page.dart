import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import 'package:workshop_app/auth/reset%20password%20account/reset_password_account.dart';
import 'package:workshop_app/auth/sign_up/sign_up_screen.dart';
import 'package:workshop_app/core/design/app_button.dart';
import 'package:workshop_app/core/design/app_image.dart';
import 'package:workshop_app/core/logic/helper_methods.dart';
import 'package:workshop_app/core/utils/spacing.dart';
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
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline, size: 70, color: AppColor.primary),
                  SizedBox(height: 20),
                  Text(
                    "You are in Guest Mode",
                    style: TextStyleTheme.textStyle18SemiBold,
                  ),
                  verticalSpace(10),
                  Text(
                    "Please sign in to access your account.",
                    style: TextStyleTheme.textStyle15medium,
                  ),
                  verticalSpace(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppButton(
                          text: "Go to Login",
                          textStyle: TextStyle(color: AppColor.white),
                          icon: Icon(Icons.login, color: AppColor.white),
                          onPress: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('isGuest');
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: "Sign Up",
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.white,
                            side: BorderSide(color: AppColor.primary),
                          ),
                          textStyle: TextStyle(color: AppColor.primary),
                          icon: Icon(Icons.person_add, color: AppColor.primary),
                          onPress: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('isGuest');
                            navigateTo(toPage: const SignUpScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: CustomAppBar(
        height: 110.h,
        padding: EdgeInsets.only(left: 20.w),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100.r),
          bottomRight: Radius.circular(100.r),
        ),
        hideBack: true,
        title: Padding(
          padding: EdgeInsets.only(bottom: 60.h),
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
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                // Profile Header
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: AppColor.primary.withOpacity(0.15),
                          child: Icon(Icons.person, size: 60, color: AppColor.primary),
                        ),
                        SizedBox(height: 12),
                        Text(userName, style: TextStyleTheme.textStyle18SemiBold),
                        SizedBox(height: 4),
                        Text(userEmail, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                // Account Items
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    children: [
                      _buildAccountItem(
                        title: "Edit Profile",
                        icon: AppImages.edit,
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      _buildAccountItem(
                        title: "Change Password",
                        icon: AppImages.lock,
                        onTap: () {
                          navigateTo(toPage: ResetPasswordAccount(email: userEmail));
                        },
                      ),
                      Divider(height: 1),
                      _buildAccountItem(
                        title: "Support",
                        icon: AppImages.help,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                // Log Out Button
                AppButton(
                  text: "Log Out",
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    fixedSize: Size(double.infinity, 44.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  textStyle: TextStyleTheme.textStyle15SemiBold.copyWith(
                    color: AppColor.white,
                  ),
                  onPress: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  icon: Icon(Icons.logout, color: Colors.white),
                ),
                SizedBox(height: 16.h),
                // Delete Account Button
                AppButton(
                  text: "Delete Account",
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffBB0B31),
                    fixedSize: Size(double.infinity, 40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  textStyle: TextStyleTheme.textStyle15SemiBold.copyWith(
                    color: AppColor.white,
                  ),
                  onPress: () async {
                    if (userId != 0) {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Delete Account"),
                          content: Text("Are you sure you want to delete your account? This action cannot be undone."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await deleteAccount(userId, context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("User not found, please log in again"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountItem({required String title, required String icon, required VoidCallback onTap}) {
    return ListTile(
      leading: AppImage(icon, height: 28, width: 28),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.grey[100],
    );
  }
}
