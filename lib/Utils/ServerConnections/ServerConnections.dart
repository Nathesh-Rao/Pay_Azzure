import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/Utils/ServerConnections/InternetConnectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ModelPages/LandingPage/Controller/LandingPageController.dart';
import '../LogServices/LogService.dart';

class ServerConnections {
  static var client = http.Client();
  InternetConnectivity internetConnectivity = Get.find();
  static const String API_GET_USERGROUPS = "api/v1/ARMUserGroups";
  static const String API_GET_SIGNINDETAILS = "api/v1/ARMSigninDetails";
  static const String API_SIGNIN = "api/v1/Signin";//"api/v1/ARMSignIn";
  static const String API_GET_LOGINUSER_DETAILS = "api/v1/GetLoginUserDetails";
  static const String API_VALIDATE_OTP = "api/v1/ValidateOTP";
  static const String API_RESEND_OTP = "api/v1/ResendOTP";
  static const String API_AX_START_SESSION = "api/v1/AxStartSession";

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

//-------------------->
  //NOTE AXPERT 11.4
  static const String API_GET_CARDS_WITH_DATA = "api/v1/GetCardsWithData";

  static const SAMPLE_GET_CARDS_WITH_DATA_GLOBAL_PARAMS = {
    "m_constants": "MyConstant",
    "axpdbdirectorypath": "",
    "vdim1": "",
    "vdim2": "",
    "vdim3": "",
    "vdim4": "",
    "AxMailFrom": "agilebiz.support@agile-labs.com",
    "APPLogo": "\\\\172.16.0.85\\AgileBizDocs\\Attachments\\Agileerpdemo\\agcloud-biz.png",
    "axpegemailactionurl": "https://demo.agilecloud.biz/demoarm/api/v1/ARMMailTaskAction",
    "AxSingnalRapiURL": "https://dev.agilecloud.biz/devarm/api/v1/SendSignalR",
    "AxRMQAPIURL": "https://dev.agilecloud.biz/devarm11.4/api/v1/ARMPushToQueue",
    "axdecimal": "4",
    "tor_dashboard_logdate_from": "ALL",
    "tor_dashboard_logdate_to": "ALL",
    "tortimetaken_from": "ALL",
    "tortimetaken_to": "ALL",
    "torservicename": "ALL",
    "custom_dashboard_cardids": "1453220000002,1457330000002",
    "custom_dashboard_params": "custom_dashboard_params json here",
    "torusername": "ALL",
    "AxDisallowCreate": "instk,stock",
    "AxpDbDirPath": "\\\\172.16.93.4\\Attachment_QA\\import\\AxImportDbDir",
    "AxSignalRapiURL": "https://dev.agilecloud.biz/devarm11.4/api/v1/SendSignalR",
    "AxScriptsAPIURL": "https://dev.agilecloud.biz/devarmscripts/ASBScriptRest.dll/datasnap/rest/TASBScriptRest/scriptsapi",
    "AxFCMSendMsgURL": "https://dev.agilecloud.biz/devarmtest/api/v1/SendFCMNotification",
    "AxPEGMailFrom": "agilebiz.support@agile-labs.com",
    "AxRapidSaveURL": "https://dev.agilecloud.biz/devarmscripts/ASBRapidSaveRest.dll/datasnap/rest/TASBRapidSaveRest/RapidSave",
    "axglo_recordid": "1970880000000",
    "m_company": "AGILE ERP DEMO",
    "m_branch": "HEAD OFFICE",
    "m_finyr": "2024",
    "m_location": "HEAD OFFICE",
    "m_fystartdate": "01/04/2024",
    "m_bridentifier": "09HQ",
    "m_companycode": "09",
    "m_currency": "INR",
    "m_spinterval": "",
    "fromuserlogin": "F",
    "axp_displaytext": "For the User:admin,Company:AGILE ERP DEMO,Branch:HEAD OFFICE,Financial Year:2024",
    "axglo_hide": "T",
    "m_fyenddate": "31/03/2025",
    "axpimageserver": "",
    "m_taxtype": "GST",
    "m_cursymbol": "₹",
    "m_curdecimals": "2",
    "axglo_user": "admin",
    "m_companyid": "1775550000001",
    "m_currencyid": "1119010000000",
    "m_branchid": "1775550000003",
    "m_branchlists": "ALL",
    "m_accesstobranches": "T",
    "m_accesstolocations": "T",
    "m_locationlists": "ALL",
    "m_opbaldate": "01/04/2024",
    "m_today": "22/01/2025",
    "m_enablecostcentre": "",
    "dac_branch": "HEAD OFFICE,Mumbai Branch",
    "lockindate": "24/10/2024",
    "millions": "T",
    "username": "admin",
    "responsibilies": "default",
    "rolename": "default",
    "ax_evalcopy": "F",
    "sesid": "jbxqzz5tie2y3yujshe3k1x5",
    "usergroup": "default",
    "project": "agileerpdemo",
    "axp_connectionname": "agileerpdemo",
    "groupno": "2",
    "userroles": "default",
    "pageaccess": "",
    "axp_apipath": "http://localhost/AxpertWebScripts113/",
    "axp_devschema": "agileerpdemoaxdef",
    "axp_appschema": "agileerpdemo",
    "axp_clientlocale": "en-US*Asia/Calcutta^english*1/24/2025 11:20:53 AM*1443",
    "transidlist": "0D000000B950DB15186FFB53D708363D7251C798",
    "appvartypes": "cccccccccccccccccccccccccccnccccdcccccccdcccccnnnccccddccd",
    "auth_path": "D:\\Codeset\\11\\Axpert11.3\\AxpertWebScripts"
  };

  //-------------------->
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
  static const String API_GET_ALL_ACTIVE_TASKS = "api/v1/ARMGetAllActiveTasks";
  static const String API_GET_BULK_APPROVAL_COUNT = "api/v1/ARMGetBulkApprovalCount";
  static const String API_GET_BULK_ACTIVETASKS = "api/v1/ARMGetBulkActiveTasks";
  static const String API_POST_BULK_DO_BULK_ACTION = "api/v1/ARMDoBulkAction";
  static const String API_GET_SENDTOUSERS = "api/v1/ARMGetSendToUsers";
  static const String API_GET_FILE_BY_RECORDID = "api/v1/GetFileByRecordId";
  static const String BANNER_JSON_NAME = "mainpagebanner.json";

  AppStorage appStorage = AppStorage();

  ServerConnections() {
    client = http.Client();
  }

  var _baseBody = "";

  String _baseUrl = "http://demo.agile-labs.com/axmclientidscripts/asbmenurest.dll/datasnap/rest/Tasbmenurest/getchoices";

  postToServer(
      {String url = '',
      var header = '',
      String body = '',
      String ClientID = '',
      bool isBearer = false,
      var show_errorSnackbar = true}) async {
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
        // print("Post header: $header");
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
          LogService.writeLog(
              message:
                  "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");

          Get.snackbar("Error " + response.statusCode.toString(), "Invalid Url",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
          showErrorSnack(title: "Error!", message: response.statusCode.toString(), show_errorSnackbar: show_errorSnackbar);
        } else {
          if (response.statusCode == 400) {
            LogService.writeLog(
                message:
                "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
            if (response.body.toString().toLowerCase().contains("sessionid is not valid")) {

              LandingPageController landingPageController = Get.find();
              landingPageController.showSignOutDialog_sessionExpired();

            } else
              return response.body;
          } else {
            print("API_ERROR: $API_NAME: ${response.body}");
            LogService.writeLog(
                message:
                    "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");

            // Get.snackbar("Error " + response.statusCode.toString(), "Internal server error",
            //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
            var msg = response.body.toString();
            if (response.body.toString().contains("message")) {
              try {
                var jsonResp = jsonDecode(response.body);
                // print(jsonResp);
                msg = jsonResp['result']['message'].toString();
              } catch (e) {
                print(e);
              }
            }
            showErrorSnack(
                title: "Error! ${response.statusCode.toString()}",
                message: API_NAME + ": " + msg,
                show_errorSnackbar: show_errorSnackbar);
          }
        }
      } catch (e) {
        print("API_ERROR: $API_NAME: ${e.toString()}");
        LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nBody: $body\nError: ${e.toString()}");

        // Get.snackbar("Error ", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        showErrorSnack(title: "Error!", message: e.toString(), show_errorSnackbar: show_errorSnackbar);
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
        var decodedBody = utf8.decode(response.bodyBytes);
        return decodedBody;
        // return response.body;
      }

      if (response.statusCode == 404) {
        if (API_NAME.toString().toLowerCase() == "ARMAppStatus".toLowerCase()) {
          showErrorSnack(title: "Error!", message: "Invalid ARM URL", show_errorSnackbar: show_errorSnackbar);
        } else {
          showErrorSnack(
              title: "Error " + response.statusCode.toString(), message: "Invalid Url", show_errorSnackbar: show_errorSnackbar);
        }
      } else {
        // LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nError: ${e.toString()}");
        showErrorSnack(
            title: "Error! " + response.statusCode.toString(),
            message: "Internal server error",
            show_errorSnackbar: show_errorSnackbar);
      }
    } catch (e) {
      LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nError: ${e.toString()}");
      if (e.toString().contains("ClientException with SocketException")) {
        await Future.delayed(Duration(seconds: 4));

        try {
          var reResponse = await client.get(Uri.parse(url), headers: header);

          if (reResponse.statusCode == 200) {
            var decodedBody = utf8.decode(reResponse.bodyBytes);
            return decodedBody;
            // return response.body;
          }

          if (reResponse.statusCode == 404) {
            if (API_NAME.toString().toLowerCase() == "ARMAppStatus".toLowerCase()) {
              showErrorSnack(title: "Error!", message: "Invalid ARM URL", show_errorSnackbar: show_errorSnackbar);
            } else {
              showErrorSnack(
                  title: "Error " + reResponse.statusCode.toString(),
                  message: "Invalid Url",
                  show_errorSnackbar: show_errorSnackbar);
            }
          } else {
            // LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nError: ${e.toString()}");
            showErrorSnack(
                title: "Error! " + reResponse.statusCode.toString(),
                message: "Internal server error",
                show_errorSnackbar: show_errorSnackbar);
          }
        } catch (err) {
          showErrorSnack(title: "Error!", message: err.toString(), show_errorSnackbar: show_errorSnackbar);
        }
      }

      showErrorSnack(title: "Error!", message: e.toString(), show_errorSnackbar: show_errorSnackbar);
      // LogService.writeLog(message: "getFromServer(): ${e.toString()}");

      // Get.snackbar("Error ", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
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

  Future<void> fetchDataWithRetry() async {
    try {
      final response = await http.get(Uri.parse("https://your.api.com"));
      // handle response
    } catch (e) {
      // Retry once after short delay
      await Future.delayed(Duration(seconds: 2));
      try {
        final retryResponse = await http.get(Uri.parse("https://your.api.com"));
        // handle retry response
      } catch (retryError) {
        print("Final failure: $retryError");
      }
    }
  }
}
