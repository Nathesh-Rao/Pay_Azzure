import 'dart:convert';
import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/EmployeeData.dart';
import 'package:axpertflutter/Utils/ServerConnections/ExecuteApi.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Constants/Enums.dart';
import '../../../Utils/LogServices/LogService.dart';

import '../../../Utils/LogServices/LogService.dart';
import '../../location_permission.dart';
import '../Models/AuthUserDetailsModel.dart';
import '../Page/LoginPage.dart';

class LoginController extends GetxController {
  GlobalVariableController globalVariableController = Get.find();
  ServerConnections serverConnections = ServerConnections();
  // final googleLoginIn = GoogleSignIn();
  AppStorage appStorage = AppStorage();
  var rememberMe = false.obs;
  var googleSignInVisible = false.obs;
  var ddSelectedValue = "Power".obs;
  var userTypeList = [].obs;
  var showPassword = true.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController otpFieldController = TextEditingController();
  final passwordFocus = FocusNode();
  var errUserName = ''.obs;
  var errPassword = ''.obs;
  var fcmId;
  var willAuthenticate = false.obs;
  var currentProjectName = ''.obs;
  var isUserDataLoading = false.obs;
  var isOtpLoading = false.obs;
  var isOTP_auth = false.obs;
  var isPWD_auth = false.obs;
  var otpChars = '4'.obs;
  var otpExpiryTime = '2'.obs;
  var authType = AuthType.none.obs;
  var otpMsg = ''.obs;
  var otpLoginKey = ''.obs;
  var otpErrorText = ''.obs;
  bool isDuplicate_session = false;

  LoginController() {
    _askLocationPermission();
    // fetchUserTypeList();
    fetchRememberedData();
    dropDownItemChanged(ddSelectedValue);
    if (userNameController.text.toString().trim() != "")
      rememberMe.value = true;

    setWillAuthenticate();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) => fcmId = value);

    // 16_KB_AMR
    _initializeGoogleSignIn();
  }

  _askLocationPermission() async {
    if (Platform.isAndroid) {
      var permission = await Permission.locationAlways.request();

      // print("Location Permission: ${permission}");
      LogService.writeLog(
          message:
              "[i] SplashPage \nScope: askLocationPermission() : $permission ");
      if (permission != PermissionStatus.granted) {
        await Get.to(RequestLocationPage());
      }
    }
    if (Platform.isIOS) {
      await Geolocator.requestPermission();
    }
  }

  setWillAuthenticate() async {
    var willAuth = await getWillBiometricAuthenticateForThisUser(
        userNameController.text.toString().trim());
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

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return MyColors.PayAzzureColor2;
    }
    return MyColors.PayAzzureColor2;
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
    if (isPWD_auth.value) {
      if (userPasswordController.text.toString().trim() == "") {
        errPassword.value = "Enter Password";
        return false;
      }
    }
    return true;
  }

  bool validateOTPField() {
    otpErrorText.value = "";
    print("OTP text length: ${otpFieldController.text.length}");
    if (otpFieldController.text.length < int.parse(otpChars.value)) {
      otpErrorText.value = "Enter full ${int.parse(otpChars.value)}-digit OTP'";
      print("Enter full ");
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

    LogService.writeOnConsole(
        message:
            "loginButtonClicked\nBody=> $_body\nurl=> $_url\narm_url=> $_armUrl");
  }

  void loginButtonClicked({bodyArgs = ''}) async {
    LogService.writeLog(
        message: "[i] LoginController\nSelected UserGroup : power");
    if (validateForm()) {
      FocusManager.instance.primaryFocus?.unfocus();
      LoadingScreen.show();
      var _body = bodyArgs == '' ? await getSignInBody() : bodyArgs;
      //var url = Const.getFullARMUrl(ServerConnections.API_SIGNIN);
      var _url = Const.getFullARMUrl(ServerConnections.API_AX_START_SESSION);

      var response =
          await serverConnections.postToServer(url: _url, body: _body);
      // LogService.writeLog(message: "[-] LoginController => loginButtonClicked() => LoginResponse : $response");

      if (response != "") {
        var json = jsonDecode(response);
        // print(json["result"]["sessionid"].toString());
        if (json["result"]["success"].toString().toLowerCase() == "true") {
          await appStorage.storeValue(
              AppStorage.TOKEN, json["result"]["token"].toString());
          await appStorage.storeValue(
              AppStorage.SESSIONID, json["result"]["sessionid"].toString());
          await appStorage.storeValue(
              AppStorage.USER_NAME, userNameController.text.trim());
          await appStorage.storeValue(AppStorage.USER_CHANGE_PASSWORD,
              json["result"]["ChangePassword"].toString());
          await appStorage.storeValue(
              AppStorage.NICK_NAME,
              json["result"]["NickName"].toString() ??
                  userNameController.text.trim());
          storeLastLoginData(_body);
          print(
              "User_change_password: ${appStorage.retrieveValue(AppStorage.USER_CHANGE_PASSWORD)}");
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
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        }
      }
      LoadingScreen.dismiss();
    }
  }

  _initializeGoogleSignIn() async {
    await GoogleSignIn.instance.initialize();
    // GoogleSignIn.instance.authenticationEvents.listen((event) async {
    //   if (event is GoogleSignInAuthenticationEventSignIn) {
    //     // googleUser = event.user;

    //     // LoadingScreen.show();

    //     // LoadingScreen.dismiss();
    //   }

    //   if (event is GoogleSignInAuthenticationEventSignOut) {
    //     await FirebaseAuth.instance.signOut();
    //     update(['google_signin']);
    //   }
    // });
  }

  void googleSignInClicked() async {
    try {
      // final googleUser = await googleLoginIn.signIn();
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        LoadingScreen.show();

        final googleUser =
            await GoogleSignIn.instance.authenticate(scopeHint: ['email']);
        final googleAuth = await googleUser.authentication;
        final googleAuthorization = await googleUser.authorizationClient
            .authorizationForScopes(["email"]);
        final accessToken = await googleAuthorization?.accessToken;
        final idToken = googleAuth.idToken;

        final credential = GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        Map body = {
          'appname': globalVariableController.PROJECT_NAME.value,
          'userid': googleUser.email.toString(),
          'userGroup': ddSelectedValue.value.toString(),
          'ssoType': 'Google',
          'ssodetails': {
            'id': googleUser.id,
            'token': googleAuthorization?.accessToken.toString(),
          },
        };

        var url = Const.getFullARMUrl(ServerConnections.API_GOOGLESIGNIN_SSO);
        var resp = await serverConnections.postToServer(
            url: url, body: jsonEncode(body));
        if (resp != "") {
          var jsonResp = jsonDecode(resp);
          // print(jsonResp);
          if (jsonResp['result']['success'].toString() == "false") {
            Get.snackbar("Alert!", jsonResp['result']['message'].toString(),
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                backgroundColor: Colors.red);
          } else {
            await appStorage.storeValue(
                AppStorage.TOKEN, jsonResp["result"]["token"].toString());
            await appStorage.storeValue(AppStorage.SESSIONID,
                jsonResp["result"]["sessionid"].toString());
            await appStorage.storeValue(
                AppStorage.USER_NAME, googleUser.email.toString());
            //remove rememberer data
            // appStorage.remove(AppStorage.USERID);
            // appStorage.remove(AppStorage.USER_PASSWORD);
            // appStorage.remove(AppStorage.USER_GROUP);
            dontRememberCredentials();
            await _processLoginAndGoToHomePage();
          }
        } else {
          Get.snackbar("Error", "Some Error occured",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
        }
        LoadingScreen.dismiss();
        // print(resp);
        // print(googleUser);
      }
    } catch (e) {
      Get.snackbar("Error", "User is not Registered!",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  _processLoginAndGoToHomePage() async {
    //mobile Notification
    await _callApiForMobileNotification();

    try {
      //connect to Axpert
      var connectBody = {
        'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)
      };
      var cUrl = Const.getFullARMUrl(ServerConnections.API_CONNECTTOAXPERT);
      var connectResp = await serverConnections.postToServer(
          url: cUrl, body: jsonEncode(connectBody), isBearer: true);
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

    try {
      await getEmployeeDetails();
    } catch (e) {
      LogService.writeLog(message: "Employee details failed $e");
    }

    Get.offAllNamed(Routes.LandingPage);
  }

  getEmployeeDetails() async {
    String secretKey = await getEncryptedSecretKey("1979902755375700");

    LogService.writeLog(message: "getEmployeeDetails secret key: $secretKey");

    var url = ServerConnections.API_PAYAZZURE_GLOBAL_ENDPOINT;
    var body = {
      "SecretKey": secretKey,
      "PublicKey": "AXPKEY000000010013",
      "Project": appStorage.retrieveValue(AppStorage.PROJECT_NAME),
      "getsqldata": {"trace": true},
      "sqlparams": {"pusername": appStorage.retrieveValue(AppStorage.USER_NAME)}
    };

    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: false);
    // LogService.writeLog(message: "getEmployeeDetails : $resp");
    LogService.writeOnConsole(message: "getEmployeeDetails : $resp");
    var response = jsonDecode(resp);
    String jsonString =
        response["ds_get_employee_global_details"]["rows"][0]["jsondata"];
    List<EmployeeData> employees = parseEmployeeJsonData(jsonString);
    final emp = employees.first;
    globalVariableController.currentEmployeeData = emp;
    print(emp.arvCompanyc);
    LogService.writeOnConsole(
        message: "getEmployeeDetails emp.arvCompanyc: ${emp.arvCompanyc}");
  }

  List<EmployeeData> parseEmployeeJsonData(String jsonDataString) {
    final List<dynamic> list = jsonDecode(jsonDataString);
    return list.map((e) => EmployeeData.fromJson(e)).toList();
  }

  getEncryptedSecretKey(String key) async {
    var url = Const.getFullARMUrl(ExecuteApi.API_GET_ENCRYPTED_SECRET_KEY);
    Map<String, dynamic> body = {"secretkey": key};
    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);
    print("Resp: $resp");
    if (resp != "" && !resp.toString().contains("error")) {
      return resp;
    }
  }

  _callApiForMobileNotification() async {
    var imei = '';
    // var imei = await PlatformDeviceId.getDeviceId ?? '0';

    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = defaultTargetPlatform == TargetPlatform.android
        ? await deviceInfoPlugin.androidInfo
        : defaultTargetPlatform == TargetPlatform.iOS
            ? await deviceInfoPlugin.iosInfo
            : null;
    if (deviceInfo == null) {
      Const.DEVICE_ID = '';
    } else {
      final allInfo = deviceInfo.data;
      imei = allInfo['id'];
    }
    var connectBody = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      'firebaseId': fcmId ?? "0",
      'ImeiNo': imei,
    };
    var cUrl = Const.getFullARMUrl(ServerConnections.API_MOBILE_NOTIFICATION);
    var connectResp = await serverConnections.postToServer(
        url: cUrl, body: jsonEncode(connectBody), isBearer: true);
    print("Mobile: " + connectResp);
  }

  getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    var version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    Const.APP_VERSION = version + "." + Const.APP_RELEASE_ID;
    return Const.APP_VERSION;
  }

  void rememberCredentials() {
    int count = 1;
    try {
      count++;
      var users = appStorage.retrieveValue(AppStorage.USERID) ?? {};
      users[globalVariableController.PROJECT_NAME.value] =
          userNameController.text.trim();
      appStorage.storeValue(AppStorage.USERID, users);

      var passes = appStorage.retrieveValue(AppStorage.USER_PASSWORD) ?? {};
      passes[globalVariableController.PROJECT_NAME.value] =
          userPasswordController.text;
      appStorage.storeValue(AppStorage.USER_PASSWORD, passes);

      var groups = appStorage.retrieveValue(AppStorage.USER_GROUP) ?? {};
      groups[globalVariableController.PROJECT_NAME.value] =
          ddSelectedValue.value;
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
    currentProjectName.value =
        await appStorage.retrieveValue(AppStorage.PROJECT_NAME) ?? '';
  }

  Future<void> fetchRememberedData() async {
    try {
      var users = appStorage.retrieveValue(AppStorage.USERID) ?? {};
      print(users);
      userNameController.text =
          users[globalVariableController.PROJECT_NAME.value].trim() ?? "";

      var passes = appStorage.retrieveValue(AppStorage.USER_PASSWORD) ?? {};
      userPasswordController.text =
          passes[globalVariableController.PROJECT_NAME.value] ?? "";

      var groups = appStorage.retrieveValue(AppStorage.USER_GROUP) ?? {};
      ddSelectedValue.value =
          groups[globalVariableController.PROJECT_NAME.value] ?? "Power";
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
        if (e.toString().contains('NotAvailable') &&
            e.toString().contains('Authentication failure'))
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

  //// New Login Flow Methods and vars

  startLoginProcess() async {
    authType.value = await getLoginUserDetailsAndAuthType();

    if (authType.value == AuthType.otpOnly) {
      await callSignInAPI();
    }

    if (isPWD_auth.value) {
      FocusScope.of(Get.context!).requestFocus(passwordFocus);
    }

    switch (authType.value) {
      case AuthType.both:
        print("✅ Both Password and OTP authentication are required.");
        break;
      case AuthType.passwordOnly:
        print("🔐 Only Password authentication is required.");
        break;
      case AuthType.otpOnly:
        print("📲 Only OTP authentication is required.");
        break;
      case AuthType.none:
        print("❌ No authentication required.");
        break;
    }
  }

  getLoginUserDetailsAndAuthType() async {
    isUserDataLoading.value = true;
    var _url = Const.getFullARMUrl(ServerConnections.API_GET_LOGINUSER_DETAILS);
    var body = {
      "appname": globalVariableController.PROJECT_NAME.value,
      "UserName": userNameController.text.toString().trim(),
    };

    var response =
        await serverConnections.postToServer(url: _url, body: jsonEncode(body));
    isUserDataLoading.value = false;
    if (response != "") {
      var json = jsonDecode(response);
      if (json["result"]["success"].toString().toLowerCase() == "true") {
        FocusManager.instance.primaryFocus?.unfocus();
        final authUserdetails = AuthUserDetailsModel.fromJson(json["result"]);
        isPWD_auth.value = authUserdetails.pwdauth!;
        if (authUserdetails.otpauth!) {
          isOTP_auth.value = authUserdetails.otpauth!;
          otpChars.value = authUserdetails.otpsettings!.otpchars!;
          otpExpiryTime.value = authUserdetails.otpsettings!.otpexpiry!;
        }

        if (isPWD_auth.value && isOTP_auth.value) return AuthType.both;
        if (isPWD_auth.value) return AuthType.passwordOnly;
        if (isOTP_auth.value) return AuthType.otpOnly;
      } else {
        Get.snackbar("Error ", json["result"]["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    }

    return AuthType.none;
  }

  callSignInAPI() async {
    if (validateForm()) {
      var signInBody = {
        "appname": globalVariableController.PROJECT_NAME.value,
        "username": userNameController.text.toString().trim(),
        "password": generateMd5(userPasswordController.text.toString().trim()),
        "Language": "English",
        "SessionId": getGUID(), //GUID
        "Globalvars": false
      };

      signInBody.addIf(isDuplicate_session, "ClearPreviousSession", true);

      // signInBody.addIf(isPWD_auth.value, "password", generateMd5(userPasswordController.text.toString().trim()));
      signInBody.addIf(isOTP_auth.value, "OtpAuth", "T");
      FocusManager.instance.primaryFocus?.unfocus();
      LoadingScreen.show();
      var _url = Const.getFullARMUrl(ServerConnections.API_SIGNIN);

      var response = await serverConnections.postToServer(
          url: _url, body: jsonEncode(signInBody));
      // LogService.writeLog(message: "[-] LoginController => loginButtonClicked() => LoginResponse : $response");

      if (response != "") {
        var json = jsonDecode(response);
        if (json["result"]["success"].toString().toLowerCase() == "true") {
          if (json["result"]["message"].toString() == "Login Successful.") {
            await processSignInDataResponse(json["result"]);
          } else if (json["result"]?.containsKey("OTPLoginKey")) {
            // OTPPage
            otpMsg.value = json["result"]["message"].toString();
            otpLoginKey.value = json["result"]["OTPLoginKey"].toString();
            print("Otpmsg: ${otpMsg.value} \nOtpkey: ${otpLoginKey.value}");
            Get.toNamed(Routes.OtpPage);
          }
        } else if (json["result"]["success"].toString().toLowerCase() ==
                "false" &&
            json["result"].containsKey('duplicate_session')) {
          isDuplicate_session = true;
          showDialog_duplicateSession(json["result"]["message"].toString());
        } else {
          if (Get.isDialogOpen ?? false) {
            Get.back(); // closes the dialog
          }
          Get.snackbar("Error ", json["result"]["message"],
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        }
      }
      LoadingScreen.dismiss();
    }
  }

  callVerifyOTP() async {
    if (validateOTPField()) {
      LoadingScreen.show();
      isOtpLoading.value = true;
      var _url = Const.getFullARMUrl(ServerConnections.API_VALIDATE_OTP);
      var body = {
        "OtpLoginKey": otpLoginKey.value,
        "OTP": otpFieldController.text.toString().trim(),
      };

      var response = await serverConnections.postToServer(
          url: _url, body: jsonEncode(body));
      isOtpLoading.value = false;
      if (response != "") {
        var json = jsonDecode(response);
        if (json["result"]["success"].toString().toLowerCase() == "true") {
          await processSignInDataResponse(json["result"]);
        } else {
          otpErrorText.value = json["result"]["message"].toString();
          /* Get.snackbar("Error ", json["result"]["message"],
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);*/
        }
      }
    }
    LoadingScreen.dismiss();
  }

  processSignInDataResponse(json) async {
    await appStorage.storeValue(AppStorage.TOKEN, json["token"].toString());
    await appStorage.storeValue(
        AppStorage.SESSIONID, json["ARMSessionId"].toString());
    await appStorage.storeValue(
        AppStorage.USER_NAME, userNameController.text.trim());
    //await appStorage.storeValue(AppStorage.USER_CHANGE_PASSWORD, json["result"]["ChangePassword"].toString());
    await appStorage.storeValue(AppStorage.NICK_NAME,
        json["nickname"].toString() ?? userNameController.text.trim());

    globalVariableController.NICK_NAME.value = json["nickname"].toString();
    globalVariableController.USER_NAME.value = json["username"].toString();
    globalVariableController.USER_EMAIL.value = json["email_id"].toString();
    //storeLastLoginData(_body);
    //print("User_change_password: ${appStorage.retrieveValue(AppStorage.USER_CHANGE_PASSWORD)}");
    LogService.writeLog(
        message:
            "[-] LoginController\nScope:SignInResponse()\nUser_change_password: ${appStorage.retrieveValue(AppStorage.USER_CHANGE_PASSWORD)}");

    //Save Data
    if (rememberMe.value) {
      rememberCredentials();
    } else {
      dontRememberCredentials();
    }
    await _processLoginAndGoToHomePage();
  }

  callResendOTP() async {
    otpErrorText.value = '';
    otpFieldController.clear();
    isOtpLoading.value = true;
    var _url = Const.getFullARMUrl(ServerConnections.API_RESEND_OTP);
    var body = {"OtpLoginKey": otpLoginKey.value};

    var response =
        await serverConnections.postToServer(url: _url, body: jsonEncode(body));
    isOtpLoading.value = false;
    if (response != "") {
      var json = jsonDecode(response);
      if (json["result"]["success"].toString().toLowerCase() == "true") {
        Get.snackbar("Success", json["result"]["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        otpErrorText.value = json["result"]["message"].toString();
        /* Get.snackbar("Error ", json["result"]["message"],
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);*/
      }
    }
  }

  void showDialog_duplicateSession(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                "Duplicate Session",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.PayAzzureColor2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      //foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(LoginPage());
                    },
                    child: const Text("No"),
                  ),

                  // Confirm button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.PayAzzureColor2,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () async {
                      callSignInAPI();
                    },
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    /* Get.defaultDialog(
              barrierDismissible: false,
              titleStyle: TextStyle(color: MyColors.blue2),
              titlePadding: EdgeInsets.only(top: 20,),
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              title: "Duplicate Session",
              middleText: json["result"]["message"].toString(),
              confirm: ElevatedButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: Text("Yes")),
              cancel: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.grey)),
                  onPressed: () {
                    Get.offAll(LoginPage());
                    Get.back();
                  },
                  child: Text("No")));*/
  }
}
