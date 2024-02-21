import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testsendbird/sendbird_service.dart';
import 'package:testsendbird/utils/app_prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String testingOpenChannelUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text('TestSendbird!'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SendbirdService().isUseNewOpenChannel() ? Colors.green[300] : Colors.green[900],
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () async {
                    debugPrint('HOME_testingOpenChannelUrl: $testingOpenChannelUrl');
                    final newOpenChannelUrl = await SendbirdService().createOpenChannel();
                    debugPrint('HOME_testOpenChannelUrl: $newOpenChannelUrl');
                    setState(() {
                      testingOpenChannelUrl = newOpenChannelUrl ?? '';
                    });
                  },
                  child: Text(testingOpenChannelUrl.isNotEmpty ? 'Disable Testing' : 'Enable Testing',
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(alignment: Alignment.centerLeft, child: Text('Created Open Channel Url:')),
                        Text(AppPrefs().getNewOpenChannel() ?? ''),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Base Open Channel Url:'),
                        Text(SendbirdService.openChannelUrl),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Used Open Channel Url:'),
                        SendbirdService().isUseNewOpenChannel()
                            ? Text(AppPrefs().getNewOpenChannel() ?? '')
                            : Text(SendbirdService.openChannelUrl),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () async {
                    await SendbirdService.connectToServer(userId: 'danoetz').then((user) {
                      if (user != null) {
                        Get.toNamed('/Chat', parameters: {'channel_url': SendbirdService.getUsedOpenChannel()});
                      } else {
                        // SendbirdService.showToast('Something went wrong! Try again in a few minutes...');
                      }
                    });
                  },
                  child: const Text('Chat as Danoetz', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () async {
                    await SendbirdService.connectToServer(userId: 'test').then((user) {
                      if (user != null) {
                        Get.toNamed('/Chat', parameters: {'channel_url': SendbirdService.getUsedOpenChannel()});
                      } else {
                        // SendbirdService.showToast('Something went wrong! Try again in a few minutes...');
                      }
                    });
                  },
                  child: const Text('Chat as Test', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
