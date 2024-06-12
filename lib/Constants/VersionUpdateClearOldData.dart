import 'package:axpertflutter/Constants/AppStorage.dart';

class VersionUpdateClearOldData {
  static clearAllOldData() async {
    try {
      AppStorage().remove('NotificationList');
      AppStorage().remove('NotificationUnReadNo');
      AppStorage().remove('LastLoginData');
      AppStorage().remove('WillAuthenticate');
      // AppStorage().remove('WillAuthenticateForUser');
      var value = AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled) ?? null;
      if (value == null) await AppStorage().storeValue(AppStorage.isShowNotifyEnabled, true);
    } catch (e) {}
  }
}
