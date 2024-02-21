import 'package:get/get.dart';
import 'package:testsendbird/views/chat_screen.dart';
import 'package:testsendbird/home_screen.dart';

final List<GetPage> routes = [
  GetPage(name: "/", page: () => const HomeScreen()),
  GetPage(name: "/Chat", page: () => const OpenChannelPage()),
];
