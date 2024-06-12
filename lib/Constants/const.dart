import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';

class Const {
  static String DEVICE_ID = "";
  static String PROJECT_URL = ""; //"https://app.buzzily.com/Run";
  static String PROJECT_NAME = "axpertqa11";
  static String ARM_URL = "";
  static String GUID = "";
  static String APP_VERSION = "";
  static String FIREBASE_TOKEN = "";
  static const String CLOUD_PROJECT = "axpmobileclient";
  static const String CLOUD_URL = "";
  static final String SEED_V = "1983";
  static String DUMMY_USER = "admin";
  static const String DUMMYUSER_PWD = "a5ca360e803b868680e2b6f7805fcb9e";

  static final String URL_JSON_OBJECTGETCHOICE = "asbmenurest.dll/datasnap/rest/Tasbmenurest/getchoices";
  static final String SET_HYBRID_INFO = "/Webservice.asmx/SetHybridInfo";
  static final String SET_HYBRID_NOTIFICATION_INFO = "/Webservice.asmx/SetHybridNotifiInfo";
  static final String LOGOUT_LINK = "webservice.asmx/SignOut";

  static String getSQLforClientID(String clientID) => "select * from tblclientMST where " + "clientid = '" + clientID + "'";

  static String getFullARMUrl(String Entrypoint) {
    if (ARM_URL == "") {
      var data = AppStorage().retrieveValue(AppStorage.ARM_URL) ?? "";
      return data.endsWith("/") ? data + Entrypoint : data + "/" + Entrypoint;
    } else
      return ARM_URL.endsWith("/") ? ARM_URL + Entrypoint : ARM_URL + "/" + Entrypoint;
  }

  // static String getFullARMUrl_HardCoded(String Entrypoint) {
  //   return "http://20.244.123.19/ARM113/" + Entrypoint;
  // }

  static String getFullProjectUrl(String Entrypoint) {
    if (PROJECT_URL == "") {
      var data = AppStorage().retrieveValue(AppStorage.PROJECT_URL) ?? "";
      return data.endsWith("/") ? data + Entrypoint : data + "/" + Entrypoint;
    } else
      // print("form const" + PROJECT_URL);
      return PROJECT_URL.endsWith("/") ? PROJECT_URL + Entrypoint : PROJECT_URL + "/" + Entrypoint;
  }

  static String getAppBody() => "{\"Appname\":\"" + PROJECT_NAME + "\"}";

  // static String getSQLforClientID(String clientID) =>
  //     "select projectname, scripts_uri,dbtype, expirydate, notify_uri,web_url,arm_url from tblclientMST   where " +
  //         "clientid = '" + clientID + "'";

  static final THEMEDATA = ThemeData.light(useMaterial3: false).copyWith(
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => MyColors.blue2),
            foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white))),
    primaryColor: Color(0xff003AA5),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ThemeData().colorScheme.copyWith(primary: MyColors.blue2),
  );
}
