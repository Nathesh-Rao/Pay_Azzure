import 'package:axpertflutter/Constants/AppStorage.dart';

class VersionUpdateClearOldData {
  static clearAllOldData() async {
    try {
      AppStorage().remove('NotificationList');
      AppStorage().remove('NotificationUnReadNo');
      AppStorage().remove('LastLoginData');
      AppStorage().remove('WillAuthenticate');
      // AppStorage().remove('WillAuthenticateForUser');
      var nofi = AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled) ?? null;
      if (nofi == null) await AppStorage().storeValue(AppStorage.isShowNotifyEnabled, true);
      var log = AppStorage().retrieveValue(AppStorage.isLogEnabled) ?? null;
      if (log == null) await AppStorage().storeValue(AppStorage.isShowNotifyEnabled, false);
    } catch (e) {}
  }
}
