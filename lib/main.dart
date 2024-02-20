import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testsendbird/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TestSendbird',
      initialRoute: '/',
      getPages: routes,
    );
  }
}
