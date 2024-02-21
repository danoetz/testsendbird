import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testsendbird/utils/app_prefs.dart';
import 'package:testsendbird/utils/user_prefs.dart';

class HomeController extends GetxController {
  // initializing theme using system theme
  Rx<ThemeMode> currentTheme = ThemeMode.dark.obs;
  final username = Rxn<String>();
  final controller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getDarkModeConfig();
    getUserName();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  // get saved theme
  getDarkModeConfig() {
    // set dark mode as deffault
    bool isDarkMode = AppPrefs().isDarkMode() ?? false;
    currentTheme.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // change theme
  void switchTheme() {
    currentTheme.value = (currentTheme.value == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    AppPrefs().setDarkMode(currentTheme.value == ThemeMode.dark);
  }

  Future<void> getUserName() async {
    username.value = await UserPrefs.getLoginUserId();
    controller.text = username.value ?? '';
  }

  void setUsername(String s) {
    username.value = s;
  }
}
