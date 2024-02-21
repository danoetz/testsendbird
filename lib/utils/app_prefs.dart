import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String prefNewOpenChannelUrl = 'prefNewOpenChannelUrl';

  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  factory AppPrefs() {
    return _instance;
  }

  late SharedPreferences prefs;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setNewOpenChannel(String value) async {
    return await prefs.setString(prefNewOpenChannelUrl, value);
  }

  String? getNewOpenChannel() {
    return prefs.getString(prefNewOpenChannelUrl);
  }
}
