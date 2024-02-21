import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const String prefLoginUserId = 'prefLoginUserId';

  static Future<bool> setLoginUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(prefLoginUserId, userId);
  }

  static Future<String?> getLoginUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefLoginUserId);
  }

  static Future<bool> removeLoginUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(prefLoginUserId);
  }
}
