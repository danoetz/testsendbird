import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testsendbird/services/sendbird_service.dart';
import 'package:testsendbird/utils/theme.dart';
import 'package:testsendbird/views/home/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());

  String testingOpenChannelUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Switch.adaptive(
                    value: (_controller.currentTheme.value == ThemeMode.dark),
                    onChanged: (v) {
                      _controller.switchTheme();
                      Get.changeThemeMode(_controller.currentTheme.value);
                    }),
              );
            }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _controller.controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 34),
                  autofillHints: const ['enter username'],
                  decoration: InputDecoration(
                    hintText: 'username',
                    hintStyle: TextStyle(
                      color: CustomTheme.typingDisabled,
                    ),
                    suffixIcon: _controller.controller.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _controller.controller.clear();
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                  onChanged: (s) => _controller.setUsername(s),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.lightThemeColor,
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: () async {
                  await SendbirdService.connectToServer(userId: _controller.controller.text).then((user) {
                    if (user != null) {
                      Get.toNamed('/Chat', parameters: {'channel_url': SendbirdService.openChannelUrl});
                    } else {
                      SendbirdService.showToast('Something went wrong! Try again in a few minutes...');
                    }
                  });
                },
                child: const Text('Enter Chat Room', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
