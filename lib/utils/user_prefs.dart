import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const String prefLoginUserId = 'prefLoginUserId';

  static Future<bool> setLoginUserId() async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    final currentUser = SendbirdChat.currentUser;
    if (currentUser != null) {
      result = await prefs.setString(prefLoginUserId, currentUser.userId);
    }
    return result;
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
