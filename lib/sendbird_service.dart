import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:testsendbird/utils/app_prefs.dart';
import 'package:testsendbird/utils/user_prefs.dart';

class SendbirdService extends OpenChannelHandler {
  static OpenChannel? openChannel;

  static String appId = 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF';
  static String openChannelUrl = 'sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211';
  static String apiUrl = 'https://api-BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF.sendbird.com';
  static String apiToken = 'f93b05ff359245af400aa805bafd2a091a173064';

  static init() async {
    return await SendbirdChat.init(appId: appId);
  }

  static Future<User?> connectToServer({required String userId}) async {
    try {
      await init();

      final loginUserId = await UserPrefs.getLoginUserId();
      debugPrint('loginUserId: $loginUserId');

      if (userId != loginUserId || loginUserId != null) {
        await UserPrefs.removeLoginUserId();
      }

      final user = await SendbirdChat.connect(userId);
      debugPrint('USER: ${user.toJson()}');
      await UserPrefs.setLoginUserId();
      return user;
    } catch (e) {
      showToast(e.toString());
    }
    return null;
  }

  bool isUseNewOpenChannel() {
    return AppPrefs().getNewOpenChannel()?.isNotEmpty ?? false;
  }

  static String getUsedOpenChannel() {
    return SendbirdService().isUseNewOpenChannel()
        ? (AppPrefs().getNewOpenChannel() ?? '')
        : SendbirdService.openChannelUrl;
  }

  Future<String?> createOpenChannel() async {
    try {
      final testOpenChannelUrl = AppPrefs().getNewOpenChannel();
      debugPrint('testOpenChannelUrl: $testOpenChannelUrl');

      if (testOpenChannelUrl == null || testOpenChannelUrl.isEmpty) {
        final openChannel = await OpenChannel.createChannel(OpenChannelCreateParams());
        debugPrint('newOpenChannelUrl: ${openChannel.channelUrl}');
        AppPrefs().setNewOpenChannel(openChannel.channelUrl);
      } else {
        AppPrefs().setNewOpenChannel('');
      }

      debugPrint('getNewOpenChannel: ${AppPrefs().getNewOpenChannel()}');
      return AppPrefs().getNewOpenChannel();
    } catch (e) {
      showToast(e.toString());
    }
    return null;
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    // Receive a new message.
  }

  static showToast(String message) {
    Fluttertoast.cancel();

    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
