import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String prefNewOpenChannelUrl = 'prefNewOpenChannelUrl';
  static const String prefDarkMode = 'prefDarkMode';

  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  factory AppPrefs() {
    return _instance;
  }

  late SharedPreferences prefs;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setDarkMode(bool value) async {
    return await prefs.setBool(prefDarkMode, value);
  }

  bool? isDarkMode() {
    return prefs.getBool(prefDarkMode);
  }
}
