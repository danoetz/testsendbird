import 'package:fluttertoast/fluttertoast.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:testsendbird/utils/user_prefs.dart';

class SendbirdService {
  static OpenChannel? openChannel;

  static String appId = 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF';
  static String openChannelUrl = 'sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211';

  static init() async {
    return await SendbirdChat.init(appId: appId);
  }

  static Future<User?> connectToServer({required String userId}) async {
    try {
      await init();

      final loginUserId = await UserPrefs.getLoginUserId();

      if (userId != loginUserId || loginUserId != null) {
        await UserPrefs.removeLoginUserId();
      }
      await SendbirdChat.connect(userId);

      final currentUser = SendbirdChat.currentUser;
      var userName = currentUser?.userId;

      if (userName != null) {
        await UserPrefs.setLoginUserId(userName);
      }

      return currentUser;
    } catch (e) {
      showToast(e.toString());
    }
    return null;
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
