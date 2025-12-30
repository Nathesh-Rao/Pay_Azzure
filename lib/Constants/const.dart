import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final globalVariableController = Get.find<GlobalVariableController>();

class Const {
  static const String SCRIPT_PUNCH_INN = 'script1';
  static const String SCRIPT_PUNCH_OUT = 'script2';
  static DateTime DEMO_END_DATE = DateTime(2025, 2, 8);
  static String APP_RELEASE_ID = "1";
  static String APP_RELEASE_DATE = "release170925";
  static String DEVICE_ID = "";
  static String GUID = "";
  static String APP_VERSION = "";
  static String FIREBASE_TOKEN = "";
  static const String CLOUD_PROJECT = "axpmobileclient";
  static const String CLOUD_URL = "";
  static final String SEED_V = "1983";
  static String DUMMY_USER = "admin";
  static const String DUMMYUSER_PWD = "a5ca360e803b868680e2b6f7805fcb9e";

  static final String URL_JSON_OBJECTGETCHOICE =
      "asbmenurest.dll/datasnap/rest/Tasbmenurest/getchoices";
  static final String SET_HYBRID_INFO = "/Webservice.asmx/SetHybridInfo";
  static final String SET_HYBRID_NOTIFICATION_INFO =
      "/Webservice.asmx/SetHybridNotifiInfo";
  static final String LOGOUT_LINK = "webservice.asmx/SignOut";

  //NOTE BottomBar Items urls
  static final String BOTTOMBAR_CALENDAR =
      'aspx/AxMain.aspx?pname=dcalendar&authKey=AXPERT-';
  static final String BOTTOMBAR_ANALYTICS =
      'aspx/AxMain.aspx?pname=danalytics&authKey=AXPERT-';
  static bool isLogEnabled = false;

  static String PAYAZZURE_PROJECT_NAME = "uat114";
  static String PAYAZZURE_WEB_URL = "https://client.payazzure.com/uat114";
  static String PAYAZZURE_ARM_URL = "https://client.payazzure.com/UAT114arm";

  static String getSQLforClientID(String clientID) =>
      "select * from tblclientMST where " + "clientid = '" + clientID + "'";

  static String getFullARMUrl(String Entrypoint) {
    print("getFullARMUrl => ${globalVariableController.ARM_URL.value}");
    if (globalVariableController.ARM_URL.value == "") {
      var data = AppStorage().retrieveValue(AppStorage.ARM_URL) ?? "";
      return data.endsWith("/") ? data + Entrypoint : data + "/" + Entrypoint;
    } else
      return globalVariableController.ARM_URL.value.endsWith("/")
          ? globalVariableController.ARM_URL.value + Entrypoint
          : globalVariableController.ARM_URL.value + "/" + Entrypoint;
  }

  // static String getFullARMUrl_HardCoded(String Entrypoint) {
  //   return "http://20.244.123.19/ARM113/" + Entrypoint;
  // }

  static String getFullWebUrl(String Entrypoint) {
    if (globalVariableController.WEB_URL.value == "") {
      var data = AppStorage().retrieveValue(AppStorage.PROJECT_URL) ?? "";
      return data.endsWith("/") ? data + Entrypoint : data + "/" + Entrypoint;
    } else
      // print("form const" + PROJECT_URL);
      return globalVariableController.WEB_URL.value.endsWith("/")
          ? globalVariableController.WEB_URL.value + Entrypoint
          : globalVariableController.WEB_URL.value + "/" + Entrypoint;
  }

  static String getAppBody() =>
      "{\"Appname\":\"" + globalVariableController.PROJECT_NAME.value + "\"}";

  // static String getSQLforClientID(String clientID) =>
  //     "select projectname, scripts_uri,dbtype, expirydate, notify_uri,web_url,arm_url from tblclientMST   where " +
  //         "clientid = '" + clientID + "'";

  static final THEMEDATA = ThemeData.light(useMaterial3: false).copyWith(
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
                (states) => MyColors.PayAzzureColor2),
            foregroundColor:
                WidgetStateColor.resolveWith((states) => Colors.white))),
    primaryColor: Color(0xff003AA5),
    scaffoldBackgroundColor: Colors.white,
    colorScheme:
        ThemeData().colorScheme.copyWith(primary: MyColors.PayAzzureColor2),
    // textButtonTheme:
    //     TextButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey)))
  );
}
