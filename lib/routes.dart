import 'package:get/get.dart';
import 'package:testsendbird/views/chat/chat_screen.dart';
import 'package:testsendbird/views/home/home_screen.dart';

final List<GetPage> routes = [
  GetPage(name: "/", page: () => const HomeScreen()),
  GetPage(name: "/Chat", page: () => const OpenChannelPage()),
];
