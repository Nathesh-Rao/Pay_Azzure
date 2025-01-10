import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/Utils/ServerConnections/InternetConnectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../LogServices/LogService.dart';

class ServerConnections {
  static var client = http.Client();
  InternetConnectivity internetConnectivity = Get.find();
  static const String API_GET_USERGROUPS = "api/v1/ARMUserGroups";
  static const String API_GET_SIGNINDETAILS = "api/v1/ARMSigninDetails";
  static const String API_SIGNIN = "api/v1/ARMSignIn";
  static const String API_GET_APPSTATUS = "api/v1/ARMAppStatus";
  static const String API_ADDUSER = "api/v1/ARMAddUser";
  static const String API_OTP_VALIDATE_USER = "api/v1/ARMValidateAddUser";
  static const String API_FORGOTPASSWORD = "api/v1/ARMForgotPassword";
  static const String API_VALIDATE_FORGETPASSWORD = "api/v1/ARMValidateForgotPassword";
  static const String API_GOOGLESIGNIN_SSO = "api/v1/ARMSigninSSO";
  static const String API_CONNECTTOAXPERT = "api/v1/ARMConnectToAxpert";
  static const String API_GET_HOMEPAGE_CARDS = "api/v1/ARMGetHomePageCards";
  static const String API_GET_HOMEPAGE_CARDS_v2 = "api/v2/ARMGetHomePageCards";
  static const String API_GET_HOMEPAGE_CARDSDATASOURCE = "api/v1/ARMGetDataResponse";
  // static const String API_GET_PENDING_ACTIVELIST = "api/v1/ARMGetActiveTasks"; //OLD
  static const String API_MOBILE_NOTIFICATION = "api/v1/ARMMobileNotification";
  static const String API_GET_DASHBOARD_DATA = "api/v1/ARMGetCardsData";
  static const String API_CHANGE_PASSWORD = "api/v1/ARMChangePassword";

  static const String API_GET_MENU = "api/v1/ARMGetMenu";
  static const String API_GET_MENU_V2 = "api/v2/ARMGetMenu";
  static const String API_SIGNOUT = "api/v1/ARMSignOut";

  static const String API_GET_PENDING_ACTIVETASK = "api/v1/ARMGetPendingActiveTasks";
  static const String API_GET_PENDING_ACTIVETASK_COUNT = "api/v1/ARMGetPendingActiveTasksCount";
  static const String API_GET_ACTIVETASK_DETAILS = "api/v1/ARMPEGGetTaskDetails";
  static const String API_GET_FILTERED_PENDING_TASK = "api/v1/ARMGetFilteredActiveTasks";
  static const String API_GET_COMPLETED_ACTIVETASK = "api/v1/ARMGetCompletedTasks";
  static const String API_GET_COMPLETED_ACTIVETASK_COUNT = "api/v1/ARMGetCompletedTasksCount";
  static const String API_GET_FILTERED_COMPLETED_TASK = "api/v1/ARMGetFilteredCompletedTasks";
  static const String API_DO_TASK_ACTIONS = "api/v1/ARMDoTaskAction";
  static const String API_GET_BULK_APPROVAL_COUNT = "api/v1/ARMGetBulkApprovalCount";
  static const String API_GET_BULK_ACTIVETASKS = "api/v1/ARMGetBulkActiveTasks";
  static const String API_GET_SENDTOUSERS = "api/v1/ARMGetSendToUsers";
  static const String API_GET_FILE_BY_RECORDID = "api/v1/GetFileByRecordId";
  static const String BANNER_JSON_NAME = "mainpagebanner.json";

  AppStorage appStorage = AppStorage();

  ServerConnections() {
    client = http.Client();
  }

  var _baseBody = "";

  String _baseUrl = "http://demo.agile-labs.com/axmclientidscripts/asbmenurest.dll/datasnap/rest/Tasbmenurest/getchoices";

  postToServer({String url = '', var header = '', String body = '', String ClientID = '', bool isBearer = false}) async {
    var API_NAME = url.substring(url.lastIndexOf("/") + 1, url.length);
    if (await internetConnectivity.connectionStatus)
      try {
        if (ClientID != '') _baseBody = _generateBody(ClientID.toLowerCase());
        if (url == '') url = _baseUrl;
        if (header == '') header = {"Content-Type": "application/json"};
        if (body == '') body = _baseBody;
        if (isBearer)
          header = {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + appStorage.retrieveValue(AppStorage.TOKEN).toString() ?? "",
          };
        print("API_POST_URL: $url");
        //

        print("API_POST_BODY:" + body);
        var response = await client.post(Uri.parse(url), headers: header, body: body);
        // print("API_RESPONSE_DATA: $API_NAME: ${response.body}\n");
        // print("");
        if (response.statusCode == 200) {
          LogService.writeLog(
              message:
                  "[^] [POST] URL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
          return response.body;
        }
        ;
        if (response.statusCode == 404) {
          print("API_ERROR: $API_NAME: ${response.body}");
          Get.snackbar("Error " + response.statusCode.toString(), "Invalid Url",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        } else {
          LogService.writeLog(
              message:
                  "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
          if (response.statusCode == 400) {
            return response.body;
          } else {
            print("API_ERROR: $API_NAME: ${response.body}");

            Get.snackbar("Error " + response.statusCode.toString(), "Internal server error",
                snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        }
      } catch (e) {
        print("API_ERROR: $API_NAME: ${e.toString()}");
        LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nError: ${e.toString()}");

        Get.snackbar("Error ", e.toString(),
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }

    return "";
  }

  // parseData(http.Response response) async {
  //   try {
  //     if (response.statusCode == 200) return response.body;
  //     if (response.statusCode == 404) {
  //       Get.snackbar("Error " + response.statusCode.toString(), "Invalid Url",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white);
  //     } else {
  //       Get.snackbar(
  //           "Error " + response.statusCode.toString(), "Internal server error",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error ", e.toString(),
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent,
  //         colorText: Colors.white);
  //   }
  // }

  getFromServer({String url = '', var header = '', var show_errorSnackbar = true}) async {
    var API_NAME = url.substring(url.lastIndexOf("/") + 1, url.length);

    try {
      if (url == '') url = _baseUrl;
      if (header == '') header = {"Content-Type": "application/json"};
      print("Get Url: $url");
      var response = await client.get(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        LogService.writeLog(
            message: "[^] [GET] URL:$url\nAPI_NAME: $API_NAME\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
        return response.body;
      }
      ;
      if (response.statusCode == 404) {
        if (API_NAME.toString().toLowerCase() == "ARMAppStatus".toLowerCase()) {
          showErrorSnack(title: "Error!", message: "Invalid ARM URL", show_errorSnackbar: show_errorSnackbar);
        } else {
          showErrorSnack(
              title: "Error " + response.statusCode.toString(), message: "Invalid Url", show_errorSnackbar: show_errorSnackbar);
        }
      } else {
        LogService.writeLog(
            message:
                "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
        Get.snackbar("Error " + response.statusCode.toString(), "Internal server error",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nError: ${e.toString()}");
      Get.snackbar("Error ", e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
    LoadingScreen.dismiss();
  }

  _generateBody(String ClientId) {
    return "{\"_parameters\":[{\"getchoices\":"
        "{\"axpapp\":\"${Const.CLOUD_PROJECT}\","
        "\"username\":\"${Const.DUMMY_USER}\","
        "\"password\":\"${Const.DUMMYUSER_PWD}\","
        "\"seed\":\"${Const.SEED_V}\","
        "\"trace\":\"true\","
        "\"sql\":\"${Const.getSQLforClientID(ClientId)}\","
        "\"direct\":\"false\","
        "\"params\":\"\"}}]}";
  }
}
