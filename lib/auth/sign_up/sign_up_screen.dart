import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/auth/login/login_screen.dart';
import '../../core/design/app_button.dart';
import '../../core/design/app_input.dart';
import '../../core/design/custom_app_bar.dart';
import '../../core/design/custom_rich_text.dart';
import '../../core/design/title_text.dart';
import '../../core/logic/helper_methods.dart';
import '../../core/utils/app_color.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/assets.dart';
import '../../core/utils/spacing.dart';
import '../../core/utils/text_style_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  Future<void> registerUser() async {
    const String registerUrl = "http://192.168.248.153/car_api/register.php";
    final body = {
      "name": userNameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    try {
      final response = await http.post(Uri.parse(registerUrl), body: body);

      // ✅ Print the response to monitor errors
      print("Response body: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  style: TextStyle(color: Colors.white),
                  "Registration successful!"),
              backgroundColor: Colors.green),
        );

        // *Store user data only if registration is successful*
        await saveUserData(result['user']);

        // *Navigate to the login screen*
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (result['message'] == "Email already exists") {
        // *Do not attempt to store data if the email is already registered*
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  style: TextStyle(color: Colors.white),
                  "This email is already registered. Please use a different email."),
              backgroundColor: Colors.orange),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("Registration Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                style: TextStyle(color: Colors.white),
                "Failed to connect to the server."),
            backgroundColor: Colors.red),
      );
    }
  }

// دالة لحفظ بيانات المستخدم
  Future<void> saveUserData(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ✅ التأكد من أن userId موجود قبل تحويله إلى int
      if (user.containsKey('userId') && user['userId'] != null) {
        await prefs.setInt('userId', int.parse(user['userId'].toString()));
      } else {
        throw Exception("userId is missing or invalid");
      }

      await prefs.setString('userName', user['name']);
      await prefs.setString('email', user['email']);

      print("✅ User data saved successfully");
    } catch (e) {
      print("❌ Error saving user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          children: [
            CustomTextWidget(
              label: AppStrings.signUp,
              style: TextStyleTheme.textStyle30Bold,
            ),
            verticalSpace(30),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    label: AppStrings.email,
                    style: TextStyleTheme.textStyle14SemiBold,
                  ),
                  AppInput(
                    hintText: AppStrings.email,
                    controller: emailController,
                    focusNode: emailFocusNode,
                    icon: AppImages.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى إدخال بريدك الإلكتروني";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return "البريد الإلكتروني غير صالح";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(userNameFocusNode);
                    },
                    textInputAction: TextInputAction.next,
                    type: TextInputType.emailAddress,
                    paddingBottom: 16.h,
                    paddingTop: 5.h,
                  ),
                  CustomTextWidget(
                    label: AppStrings.userName,
                    style: TextStyleTheme.textStyle14SemiBold,
                  ),
                  AppInput(
                    hintText: AppStrings.userName,
                    controller: userNameController,
                    focusNode: userNameFocusNode,
                    icon: AppImages.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى إدخال اسمك";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z\u0621-\u064A]{2,}(?:\s[a-zA-Z\u0621-\u064A]+)+$")
                          .hasMatch(value)) {
                        return "يرجى إدخال اسمك الثنائي (الاسم واللقب)";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                    textInputAction: TextInputAction.next,
                    type: TextInputType.name,
                    paddingBottom: 16.h,
                    paddingTop: 5.h,
                  ),
                  CustomTextWidget(
                    label: AppStrings.password,
                    style: TextStyleTheme.textStyle14SemiBold,
                  ),
                  AppInput(
                    hintText: AppStrings.password,
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    icon: AppImages.password,
                    onFieldSubmitted: (value) {
                      FocusScope.of(
                        context,
                      ).requestFocus(confirmPasswordFocusNode);
                    },
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى إدخال كلمة المرور";
                      }
                      if (value.length < 6) {
                        return "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    type: TextInputType.visiblePassword,
                    paddingBottom: 16.h,
                    paddingTop: 5.h,
                  ),
                  CustomTextWidget(
                    label: AppStrings.confirmPassword,
                    style: TextStyleTheme.textStyle14SemiBold,
                  ),
                  AppInput(
                    hintText: AppStrings.confirmPassword,
                    icon: AppImages.password,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى تأكيد كلمة المرور";
                      }
                      if (value != passwordController.text) {
                        return "كلمة المرور غير متطابقة";
                      }
                      return null;
                    },
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    textInputAction: TextInputAction.done,
                    type: TextInputType.visiblePassword,
                    paddingBottom: 38.h,
                    paddingTop: 5.h,
                  ),
                ],
              ),
            ),
            AppButton(
              textStyle: TextStyle(color: AppColor.white),
              text: AppStrings.signUp,
              onPress: () async {
                if (formKey.currentState!.validate()) {
                  registerUser();
                }
              },
            ),
            verticalSpace(40),
            CustomRichText(
              text: AppStrings.createAccount,
              subText: AppStrings.login,
              onTap: () {
                navigateTo(toPage: LoginScreen());
              },
            ),
          ],
        ),
     ),
);
}
}



//=================================
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workshop_app/auth/login/login_screen.dart';
// import '../../core/design/app_button.dart';
// import '../../core/design/app_input.dart';
// import '../../core/design/custom_app_bar.dart';
// import '../../core/design/custom_rich_text.dart';
// import '../../core/design/title_text.dart';
// import '../../core/logic/helper_methods.dart';
// import '../../core/utils/app_color.dart';
// import '../../core/utils/app_strings.dart';
// import '../../core/utils/assets.dart';
// import '../../core/utils/spacing.dart';
// import '../../core/utils/text_style_theme.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final userNameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final emailFocusNode = FocusNode();
//   final userNameFocusNode = FocusNode();
//   final passwordFocusNode = FocusNode();
//   final confirmPasswordFocusNode = FocusNode();

//   Future<void> registerUser() async {
//     const String registerUrl = "http://192.168.1.10/car_api/register.php";
//     final body = {
//       "name": userNameController.text.trim(),
//       "email": emailController.text.trim(),
//       "password": passwordController.text.trim(),
//     };

//     try {
//       final response = await http.post(Uri.parse(registerUrl), body: body);

//       // ✅ Print the response to monitor errors
//       print("Response body: ${response.body}");

//       final result = jsonDecode(response.body);

//       if (response.statusCode == 200 && result['status'] == 'success') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   style: TextStyle(color: Colors.white),
//                   "Registration successful!"),
//               backgroundColor: Colors.green),
//         );

//         // **Store user data only if registration is successful**
//         await saveUserData(result['user']);

//         // **Navigate to the login screen**
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       } else if (result['message'] == "Email already exists") {
//         // **Do not attempt to store data if the email is already registered**
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   style: TextStyle(color: Colors.white),
//                   "This email is already registered. Please use a different email."),
//               backgroundColor: Colors.orange),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(result['message']), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       print("Registration Error: $e");

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text(
//                 style: TextStyle(color: Colors.white),
//                 "Failed to connect to the server."),
//             backgroundColor: Colors.red),
//       );
//     }
//   }

// // دالة لحفظ بيانات المستخدم
//   Future<void> saveUserData(Map<String, dynamic> user) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // ✅ التأكد من أن userId موجود قبل تحويله إلى int
//       if (user.containsKey('userId') && user['userId'] != null) {
//         await prefs.setInt('userId', int.parse(user['userId'].toString()));
//       } else {
//         throw Exception("userId is missing or invalid");
//       }

//       await prefs.setString('userName', user['name']);
//       await prefs.setString('email', user['email']);

//       print("✅ User data saved successfully");
//     } catch (e) {
//       print("❌ Error saving user data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
//           children: [
//             CustomTextWidget(
//               label: AppStrings.signUp,
//               style: TextStyleTheme.textStyle30Bold,
//             ),
//             verticalSpace(30),
//             Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomTextWidget(
//                     label: AppStrings.email,
//                     style: TextStyleTheme.textStyle14SemiBold,
//                   ),
//                   AppInput(
//                     hintText: AppStrings.email,
//                     controller: emailController,
//                     focusNode: emailFocusNode,
//                     icon: AppImages.email,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "يرجى إدخال بريدك الإلكتروني";
//                       }
//                       if (!RegExp(
//                               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//                           .hasMatch(value)) {
//                         return "البريد الإلكتروني غير صالح";
//                       }
//                       return null;
//                     },
//                     onFieldSubmitted: (value) {
//                       FocusScope.of(context).requestFocus(userNameFocusNode);
//                     },
//                     textInputAction: TextInputAction.next,
//                     type: TextInputType.emailAddress,
//                     paddingBottom: 16.h,
//                     paddingTop: 5.h,
//                   ),
//                   CustomTextWidget(
//                     label: AppStrings.userName,
//                     style: TextStyleTheme.textStyle14SemiBold,
//                   ),
//                   AppInput(
//                     hintText: AppStrings.userName,
//                     controller: userNameController,
//                     focusNode: userNameFocusNode,
//                     icon: AppImages.name,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "يرجى إدخال اسمك";
//                       }
//                       if (!RegExp(
//                               r"^[a-zA-Z\u0621-\u064A]{2,}(?:\s[a-zA-Z\u0621-\u064A]+)+$")
//                           .hasMatch(value)) {
//                         return "يرجى إدخال اسمك الثنائي (الاسم واللقب)";
//                       }
//                       return null;
//                     },
//                     onFieldSubmitted: (value) {
//                       FocusScope.of(context).requestFocus(passwordFocusNode);
//                     },
//                     textInputAction: TextInputAction.next,
//                     type: TextInputType.name,
//                     paddingBottom: 16.h,
//                     paddingTop: 5.h,
//                   ),
//                   CustomTextWidget(
//                     label: AppStrings.password,
//                     style: TextStyleTheme.textStyle14SemiBold,
//                   ),
//                   AppInput(
//                     hintText: AppStrings.password,
//                     controller: passwordController,
//                     focusNode: passwordFocusNode,
//                     icon: AppImages.password,
//                     onFieldSubmitted: (value) {
//                       FocusScope.of(
//                         context,
//                       ).requestFocus(confirmPasswordFocusNode);
//                     },
//                     isPassword: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "يرجى إدخال كلمة المرور";
//                       }
//                       if (value.length < 6) {
//                         return "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل";
//                       }
//                       return null;
//                     },
//                     textInputAction: TextInputAction.next,
//                     type: TextInputType.visiblePassword,
//                     paddingBottom: 16.h,
//                     paddingTop: 5.h,
//                   ),
//                   CustomTextWidget(
//                     label: AppStrings.confirmPassword,
//                     style: TextStyleTheme.textStyle14SemiBold,
//                   ),
//                   AppInput(
//                     hintText: AppStrings.confirmPassword,
//                     icon: AppImages.password,
//                     isPassword: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "يرجى تأكيد كلمة المرور";
//                       }
//                       if (value != passwordController.text) {
//                         return "كلمة المرور غير متطابقة";
//                       }
//                       return null;
//                     },
//                     controller: confirmPasswordController,
//                     focusNode: confirmPasswordFocusNode,
//                     textInputAction: TextInputAction.done,
//                     type: TextInputType.visiblePassword,
//                     paddingBottom: 38.h,
//                     paddingTop: 5.h,
//                   ),
//                 ],
//               ),
//             ),
//             AppButton(
//               textStyle: TextStyle(color: AppColor.white),
//               text: AppStrings.signUp,
//               onPress: () async {
//                 if (formKey.currentState!.validate()) {
//                   registerUser();
//                 }
//               },
//             ),
//             verticalSpace(40),
//             CustomRichText(
//               text: AppStrings.createAccount,
//               subText: AppStrings.login,
//               onTap: () {
//                 navigateTo(toPage: LoginScreen());
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
