import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static bool isAuth() {
    String? token = prefs.getString("token");
    return token != null || (token ?? "").isNotEmpty;
  }

  static String getUserToken() {
    return prefs.getString("token") ?? "";
  }

  static Future<bool> clearUserData() async {
    return prefs.clear();
  }

  static Future<bool> userLoggedIn(bool value) async {
    return prefs.setBool("remember_me", value);
  }

  // static Future<void> saveUserData(LoginModel model) async {
  //
  //   await prefs.setString("token", model.token);
  //   await prefs.setString("fullname", model.name);
  //   await prefs.setString("email", model.message);
  //   await prefs.setBool("isActive", model.status);
  //   await prefs.setInt("isBan", model.statusCode);
  // }
}
