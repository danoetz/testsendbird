import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  // light theme
  static final lightTheme = ThemeData(
    primaryColor: lightThemeColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: white,
    useMaterial3: true,
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) => lightThemeColor),
    ),
    fontFamily: 'Pretendard',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: white,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: dark7,
        fontSize: 15,
      ),
      iconTheme: IconThemeData(color: lightThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: lightThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  // dark theme
  static final darkTheme = ThemeData(
    primaryColor: darkThemeColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: dark7,
    useMaterial3: true,
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith<Color>((states) => darkThemeColor),
    ),
    fontFamily: 'Pretendard',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: dark7,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: white,
        fontSize: 15,
      ),
      iconTheme: IconThemeData(color: darkThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: darkThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: dark7,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );

  // colors
  static Color lightThemeColor = const Color(0xFF00CC95);
  static Color white = Colors.white;
  static Color darkThemeColor = const Color(0xFFFFFFFF);

  static Color typingColor = const Color(0xFFFCFCFC);
  static Color typingDisabled = const Color(0xFF666666);

  static Color dark7 = const Color(0xFF0E0D0D);
  static Color dark6 = const Color(0xFF131313);
  static Color dark5 = const Color(0xFF1A1A1A);
  static Color dark4 = const Color(0xFF323232);
  static Color dark3 = const Color(0xFF3A3A3A);
  static Color dark2 = const Color(0xFFADADAD);
  static Color dark1 = const Color(0xFF9C9CA3);
  static Color dark0 = const Color(0xFFF5F5F5);

  static Color statusActive = const Color(0xFF46F9F5);
  static Color bgChatReciver = const Color(0xFF1A1A1A);
  static LinearGradient bgChatSender = chatSenderGradient();
  static LinearGradient statusInactive = userInactive();

  static Color generateColor() {
    List<Color> colors = [
      const Color(0xFF46F9F5),
      const Color(0xFFFF006A),
      const Color(0xFF00CC95),
      const Color(0xFF2B53E1),
    ];
    Random random = Random();
    int cindex = random.nextInt(colors.length);
    return colors[cindex];
  }
}

LinearGradient chatSenderGradient() {
  return const LinearGradient(
    colors: [Color(0xFFFF006B), Color(0xFFFF4593)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

LinearGradient userInactive() {
  return const LinearGradient(
    begin: Alignment(0.44, -0.90),
    end: Alignment(-0.44, 0.9),
    colors: [Color(0xFF0F0F0F), Color(0xFF2E2E2E)],
  );
}
