import 'dart:convert';
import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../../Utils/LogServices/LogService.dart';

import '../../../Utils/LogServices/LogService.dart';
import '../../location_permission.dart';

class LoginController extends GetxController {
  GlobalVariableController globalVariableController = Get.find();
  ServerConnections serverConnections = ServerConnections();
  final googleLoginIn = GoogleSignIn();
  AppStorage appStorage = AppStorage();
  var rememberMe = false.obs;
  var googleSignInVisible = false.obs;
  var ddSelectedValue = "Power".obs;
  var userTypeList = [].obs;
  var showPassword = true.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  var errUserName = ''.obs;
  var errPassword = ''.obs;
  var fcmId;
  var willAuthenticate = false.obs;
  var currentProjectName = ''.obs;
  LoginController() {
    _askLocationPermission();
    // fetchUserTypeList();
    fetchRememberedData();
    dropDownItemChanged(ddSelectedValue);
    if (userNameController.text.toString().trim() != "") rememberMe.value = true;

    setWillAuthenticate();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) => fcmId = value);
  }

  _askLocationPermission() async {
    if (Platform.isAndroid) {
      var permission = await Permission.locationAlways.request();

      // print("Location Permission: ${permission}");
      LogService.writeLog(message: "[i] SplashPage \nScope: askLocationPermission() : $permission ");
      if (permission != PermissionStatus.granted) {
        await Get.to(RequestLocationPage());
      }
    }
    if (Platform.isIOS) {
      await Geolocator.requestPermission();
    }
  }

  setWillAuthenticate() async {
    var willAuth = await getWillBiometricAuthenticateForThisUser(userNameController.text.toString().trim());
    print(("Login willAuth: $willAuth"));
    if (willAuth != null) {
      willAuthenticate.value = willAuth;
    }
    displayAuthenticationDialog();
  }

  // fetchUserTypeList() async {
  //   LoadingScreen.show();
  //
  //   // print(Const.ARM_URL);
  //   // userTypeList.clear();
  //   var url = Const.getFullARMUrl(ServerConnections.API_GET_USERGROUPS);
  //   var body = Const.getAppBody();
  //   var data = await serverConnections.postToServer(url: url, body: body);
  //   LoadingScreen.dismiss();
  //
  //   if (data != "") {
  //     data = data.toString().replaceAll("null", "\"\"");
  //
  //     // print(data);
  //
  //     var jsonData = jsonDecode(data)['result']['data'] as List;
  //     userTypeList.clear();
  //     for (var item in jsonData) {
  //       String val = item["usergroup"].toString();
  //       userTypeList.add(CommonMethods.capitalize(val));
  //     }
  //     userTypeList..sort((a, b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
  //     if (ddSelectedValue.value == "") {
  //       ddSelectedValue.value = userTypeList[0];
  //       dropDownItemChanged(ddSelectedValue);
  //     }
  //   }
  // }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return MyColors.blue2;
    }
    return MyColors.blue2;
  }

  // fetchSignInDetail() async {
  //   LoadingScreen.show();
  //   var url = Const.getFullARMUrl(ServerConnections.API_GET_SIGNINDETAILS);
  //   var body = Const.getAppBody();
  //   await serverConnections.postToServer(url: url, body: body);
  //   LoadingScreen.dismiss();
  // }

  dropdownMenuItem() {
    List<DropdownMenuItem<String>> myList = [];
    for (var item in userTypeList) {
      DropdownMenuItem<String> dditem = DropdownMenuItem(
        value: item.toString(),
        child: Text(item),
      );
      myList.add(dditem);
    }
    return myList;
  }

  dropDownItemChanged(Object? value) {
    ddSelectedValue.value = value.toString();
    if (ddSelectedValue.value.toLowerCase() == "external")
      googleSignInVisible.value = true;
    else
      googleSignInVisible.value = false;
    // print(value);
  }

  errMessage(rxMsg) {
    return rxMsg.value == "" ? null : rxMsg.value;
  }

  bool validateForm() {
    errPassword.value = errUserName.value = "";
    if (userNameController.text.toString().trim() == "") {
      errUserName.value = "Enter User Name";
      return false;
    }
    if (userPasswordController.text.toString().trim() == "") {
      errPassword.value = "Enter Password";
      return false;
    }
    return true;
  }

  // getSignInBody() async {
  //   Map body = {
  //     "deviceid": Const.DEVICE_ID,
  //     "appname": currentProjectName.value,
  //     "username": userNameController.text.toString().trim(),
  //     "userGroup": ddSelectedValue.value.toString().toLowerCase(),
  //     "biometricType": "LOGIN",
  //     "password": userPasswordController.text.toString().trim()
  //   };
  //   return jsonEncode(body);
  // }
  // static String getFullARMUrl(String Entrypoint) {
  //   if (ARM_URL == "") {
  //     var data = AppStorage().retrieveValue(AppStorage.ARM_URL) ?? "";
  //     return data.endsWith("/") ? data + Entrypoint : data + "/" + Entrypoint;
  //   } else
  //     return ARM_URL.endsWith("/") ? ARM_URL + Entrypoint : ARM_URL + "/" + Entrypoint;
  // }
  getSignInBody() async {
    Map body = {
      "appname": globalVariableController.PROJECT_NAME.value,
      "username": userNameController.text.toString().trim(),
      "password": userPasswordController.text.toString().trim(),
      "Language": "English"
      //"deviceid": Const.DEVICE_ID,
      //"userGroup": "power",
      // "userGroup": ddSelectedValue.value.toString().toLowerCase(),
      //"biometricType": "LOGIN",
    };
    return jsonEncode(body);
  }

  // void loginButtonClicked({bodyArgs = ''}) async {
  //   if (validateForm()) {
  //     FocusManager.instance.primaryFocus?.unfocus();
  //     LoadingScreen.show();
  //     var body = bodyArgs == '' ? await getSignInBody() : bodyArgs;
  //     var url = Const.getFullARMUrl(ServerConnections.API_SIGNIN);
  //     // print(body.toString());
  //     // var response = await http.post(Uri.parse(url),
  //     //     headers: {"Content-Type": "application/json"}, body: body);
  //     // var data = serverConnections.parseData(response);
  //     var response = await serverConnections.postToServer(url: url, body: body);
  //     if (response != "") {
  //       var json = jsonDecode(response);
  //       // print(json["result"]["sessionid"].toString());
  //       if (json["result"]["success"].toString().toLowerCase() == "true") {
  //         await appStorage.storeValue(AppStorage.TOKEN, json["result"]["token"].toString());
  //         await appStorage.storeValue(AppStorage.SESSIONID, json["result"]["sessionid"].toString());
  //         await appStorage.storeValue(AppStorage.USER_NAME, userNameController.text.trim());
  //         await appStorage.storeValue(AppStorage.USER_CHANGE_PASSWORD, json["result"]["ChangePassword"].toString());
  //         storeLastLoginData(body);
  //         print("User_change_password: ${appStorage.retrieveValue(AppStorage.USER_CHANGE_PASSWORD)}");
  //         //Save Data
  //         if (rememberMe.value) {
  //           rememberCredentials();
  //         } else {
  //           dontRememberCredentials();
  //         }
  //
  //         await _processLoginAndGoToHomePage();
  //       } else {
  //         Get.snackbar("Error ", json["result"]["message"],
  //             snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
  //       }
  //     }
  //     LoadingScreen.dismiss();
  //   }
  // }
  void loginButtonClicked_temp({bodyArgs = ''}) async {
    var _armUrl = globalVariableController.ARM_URL.value;
    var _body = bodyArgs == '' ? await getSignInBody() : bodyArgs;
    var _url = Const.getFullARMUrl(ServerConnections.API_AX_START_SESSION);

    LogService.writeOnConsole(message: "loginButtonClicked\nBody=> $_body\nurl=> $_url\narm_url=> $_armUrl");
  }

  void loginButtonClicked({bodyArgs = ''}) async {
    LogService.writeLog(message: "[i] LoginController\nSelected UserGroup : power");
    if (validateForm()) {
      FocusManager.instance.primaryFocus?.unfocus();
      LoadingScreen.show();
      var _body = bodyArgs == '' ? await getSignInBody() : bodyArgs;
      //var url = Const.getFullARMUrl(ServerConnections.API_SIGNIN);
      var _url = Const.getFullARMUrl(ServerConnections.API_AX_START_SESSION);

      var response = await serverConnections.postToServer(url: _url, body: _body);
      // LogService.writeLog(message: "[-] LoginController => loginButtonClicked() => LoginResponse : $response");

      if (response != "") {
        var json = jsonDecode(response);
        // print(json["result"]["sessionid"].toString());
        if (json["result"]["success"].toString().toLowerCase() == "true") {
          await appStorage.storeValue(AppStorage.TOKEN, json["result"]["token"].toString());
          await appStorage.storeValue(AppStorage.SESSIONID, json["result"]["sessionid"].toString());
          await appStorage.storeValue(AppStorage.USER_NAME, userNameController.text.trim());
          await appStorage.storeValue(AppStorage.USER_CHANGE_PASSWORD, json["result"]["ChangePassword"].toString());
          await appStorage.storeValue(
              AppStorage.NICK_NAME, json["result"]["NickName"].toString() ?? userNameController.text.trim());
          storeLastLoginData(_body);
          print("User_change_password: ${appStorage.retrieveValue(AppStorage.USER_CHANGE_PASSWORD)}");
          LogService.writeLog(
              message:
                  "[-] LoginController\nScope: loginButtonClicked()\nUser_change_password: ${appStorage.retrieveValue(AppStorage.USER_CHANGE_PASSWORD)}");

          //Save Data
          if (rememberMe.value) {
            rememberCredentials();
          } else {
            dontRememberCredentials();
          }

          await _processLoginAndGoToHomePage();
        } else {
          Get.snackbar("Error ", json["result"]["message"],
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      }
      LoadingScreen.dismiss();
    }
  }

  void googleSignInClicked() async {
    try {
      final googleUser = await googleLoginIn.signIn();
      if (googleUser != null) {
        LoadingScreen.show();
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        Map body = {
          'appname': globalVariableController.PROJECT_NAME.value,
          'userid': googleUser.email.toString(),
          'userGroup': ddSelectedValue.value.toString(),
          'ssoType': 'Google',
          'ssodetails': {
            'id': googleUser.id,
            'token': googleAuth.accessToken.toString(),
          },
        };

        var url = Const.getFullARMUrl(ServerConnections.API_GOOGLESIGNIN_SSO);
        var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body));
        if (resp != "") {
          var jsonResp = jsonDecode(resp);
          // print(jsonResp);
          if (jsonResp['result']['success'].toString() == "false") {
            Get.snackbar("Alert!", jsonResp['result']['message'].toString(),
                snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.red);
          } else {
            await appStorage.storeValue(AppStorage.TOKEN, jsonResp["result"]["token"].toString());
            await appStorage.storeValue(AppStorage.SESSIONID, jsonResp["result"]["sessionid"].toString());
            await appStorage.storeValue(AppStorage.USER_NAME, googleUser.email.toString());
            //remove rememberer data
            // appStorage.remove(AppStorage.USERID);
            // appStorage.remove(AppStorage.USER_PASSWORD);
            // appStorage.remove(AppStorage.USER_GROUP);
            dontRememberCredentials();
            await _processLoginAndGoToHomePage();
          }
        } else {
          Get.snackbar("Error", "Some Error occured",
              backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        }
        LoadingScreen.dismiss();
        // print(resp);
        // print(googleUser);
      }
    } catch (e) {
      Get.snackbar("Error", "User is not Registered!",
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  _processLoginAndGoToHomePage() async {
    //mobile Notification
    await _callApiForMobileNotification();

    try {
      //connect to Axpert
      var connectBody = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
      var cUrl = Const.getFullARMUrl(ServerConnections.API_CONNECTTOAXPERT);
      var connectResp = await serverConnections.postToServer(url: cUrl, body: jsonEncode(connectBody), isBearer: true);
      print(connectResp);
      // getArmMenu
      var jsonResp = jsonDecode(connectResp);
      if (jsonResp != "") {
        if (jsonResp['result']['success'].toString() == "true") {
          // Get.offAllNamed(Routes.LandingPage);
        } else {
          var message = jsonResp['result']['message'].toString();
          showErrorSnack(title: "Error - Connect To Axpert", message: message);
        }
      } else {
        showErrorSnack();
      }
    } catch (e) {
      print(e);
    }
    Get.offAllNamed(Routes.LandingPage);
  }

  _callApiForMobileNotification() async {
    var imei = await PlatformDeviceId.getDeviceId ?? '0';
    var connectBody = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      'firebaseId': fcmId ?? "0",
      'ImeiNo': imei,
    };
    var cUrl = Const.getFullARMUrl(ServerConnections.API_MOBILE_NOTIFICATION);
    var connectResp = await serverConnections.postToServer(url: cUrl, body: jsonEncode(connectBody), isBearer: true);
    print("Mobile: " + connectResp);
  }

  getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    var version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    Const.APP_VERSION = version;
    return version;
  }

  void rememberCredentials() {
    int count = 1;
    try {
      count++;
      var users = appStorage.retrieveValue(AppStorage.USERID) ?? {};
      users[globalVariableController.PROJECT_NAME.value] = userNameController.text.trim();
      appStorage.storeValue(AppStorage.USERID, users);

      var passes = appStorage.retrieveValue(AppStorage.USER_PASSWORD) ?? {};
      passes[globalVariableController.PROJECT_NAME.value] = userPasswordController.text;
      appStorage.storeValue(AppStorage.USER_PASSWORD, passes);

      var groups = appStorage.retrieveValue(AppStorage.USER_GROUP) ?? {};
      groups[globalVariableController.PROJECT_NAME.value] = ddSelectedValue.value;
      appStorage.storeValue(AppStorage.USER_GROUP, groups);
    } catch (e) {
      appStorage.remove(AppStorage.USERID);
      appStorage.remove(AppStorage.USER_PASSWORD);
      appStorage.remove(AppStorage.USER_GROUP);
      if (count < 10) rememberCredentials();
    }
  }

  void dontRememberCredentials() {
    Map users = appStorage.retrieveValue(AppStorage.USERID) ?? {};
    users.remove(globalVariableController.PROJECT_NAME.value);
    appStorage.storeValue(AppStorage.USERID, users);

    var passes = appStorage.retrieveValue(AppStorage.USER_PASSWORD) ?? {};
    passes.remove(globalVariableController.PROJECT_NAME.value);
    appStorage.storeValue(AppStorage.USER_PASSWORD, passes);

    var groups = appStorage.retrieveValue(AppStorage.USER_GROUP) ?? {};
    groups.remove(globalVariableController.PROJECT_NAME.value);
    appStorage.storeValue(AppStorage.USER_GROUP, groups);
  }

  onLoad() async {
    currentProjectName.value = await appStorage.retrieveValue(AppStorage.PROJECT_NAME) ?? '';
  }

  Future<void> fetchRememberedData() async {
    try {
      var users = appStorage.retrieveValue(AppStorage.USERID) ?? {};
      print(users);
      userNameController.text = users[globalVariableController.PROJECT_NAME.value].trim() ?? "";

      var passes = appStorage.retrieveValue(AppStorage.USER_PASSWORD) ?? {};
      userPasswordController.text = passes[globalVariableController.PROJECT_NAME.value] ?? "";

      var groups = appStorage.retrieveValue(AppStorage.USER_GROUP) ?? {};
      ddSelectedValue.value = groups[globalVariableController.PROJECT_NAME.value] ?? "Power";
    } catch (e) {
      // appStorage.remove(AppStorage.USERID);
      // appStorage.remove(AppStorage.USER_PASSWORD);
      // appStorage.remove(AppStorage.USER_GROUP);
    }
  }

  void displayAuthenticationDialog() async {
    if (willAuthenticate == true) {
      try {
        if (await showBiometricDialog()) {
          loginButtonClicked(bodyArgs: retrieveLastLoginData());
        }
      } catch (e) {
        print(e.toString());
        if (e.toString().contains('NotAvailable') && e.toString().contains('Authentication failure'))
          showErrorSnack(title: "Oops!", message: "Only Biometric is allowed.");
      }
    }
  }

  void storeLastLoginData(body) {
    AppStorage appStorage = AppStorage();
    var projectName = globalVariableController.PROJECT_NAME.value;
    Map lastData = appStorage.retrieveValue(AppStorage.LAST_LOGIN_DATA) ?? {};
    lastData[projectName] = body;
    appStorage.storeValue(AppStorage.LAST_LOGIN_DATA, lastData);
  }

  retrieveLastLoginData() {
    AppStorage appStorage = AppStorage();
    var projectName = globalVariableController.PROJECT_NAME.value;
    Map lastData = appStorage.retrieveValue(AppStorage.LAST_LOGIN_DATA) ?? {};
    return lastData[projectName] ?? '';
  }
}
