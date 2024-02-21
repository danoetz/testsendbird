import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testsendbird/utils/app_prefs.dart';

class HomeController extends GetxController {
  // initializing theme using system theme
  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    getDarkModeConfig();
  }

  // get saved theme
  getDarkModeConfig() {
    bool isDarkMode = AppPrefs().isDarkMode();
    currentTheme.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // change theme
  void switchTheme() {
    currentTheme.value = (currentTheme.value == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    debugPrint('Current Theme: ${currentTheme.value}');
  }
}
