import 'package:get_storage/get_storage.dart';

class AppStorage {
  static const String PROJECT_LIST = "ProjectList";
  static const String CACHED = "Cached";
  static const String TOKEN = "Token";
  static const String SESSIONID = "SessionID";
  static const String USERID = "userID";
  static const String USER_PASSWORD = "userPass";
  static const String USER_NAME = "UserName";
  static const String USER_GROUP = "UserGroup";
  static const String LAST_LOGIN_DATA = "LastLoginDataMap";

  static const String PROJECT_NAME = "ProjectName";
  static const String PROJECT_URL = "ProjectUrl";
  static const String ARM_URL = "ArmUrl";
  // static const String NOTIFICATION_LIST = "NotificationList";
  static const String NOTIFICATION_LIST = "NewNotificationList";
  static const String NOTIFICATION_UNREAD = "NewNotificationUnReadNo";
  static const String CAN_AUTHENTICATE = "CanAuthenticate";
  // static const String WILL_AUTHENTICATE = "WillAuthenticate";
  static const String WILL_AUTHENTICATE_FOR_USER = "WillAuthenticateForUser";
  static const String SHAREDPREF_NAME = "BackgroundMessages";
  late final box;

  AppStorage() {
    box = GetStorage();
  }
  storeValue(String key, var value) {
    box.write(key, value);
  }

  dynamic retrieveValue(String key) {
    return box.read(key);
  }

  remove(String key) {
    box.remove(key);
  }
}
