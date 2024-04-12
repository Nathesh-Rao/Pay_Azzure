import 'package:axpertflutter/Constants/AppStorage.dart';

class VersionUpdateClearOldData {
  static clearAllOldData() {
    try {
      AppStorage().remove('NotificationList');
      AppStorage().remove('NotificationUnReadNo');
      AppStorage().remove('LastLoginData');
      AppStorage().remove('WillAuthenticate');
      AppStorage().remove('WillAuthenticateForUser');
    } catch (e) {}
  }
}
