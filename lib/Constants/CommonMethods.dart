import 'dart:async';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

isTablet() {
  return MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide < 600 ? true : false;
}

class CommonMethods {
  static String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  static String activeList_CreateURL_MAKE(activeList) {
    var url = "";
    if (activeList.recordid.toString().toLowerCase() == "" || activeList.recordid.toString().toLowerCase() == "null") {
      url = "aspx/AxMain.aspx?pname=t" +
          activeList.transid.toString() +
          "&authKey=AXPERT-" +
          AppStorage().retrieveValue(AppStorage.SESSIONID) +
          "&params=^act=open^" +
          activeList.keyfield.toString() +
          "=" +
          activeList.keyvalue.toString();
    } else {
      url = "aspx/AxMain.aspx?pname=t" +
          activeList.transid.toString() +
          "&authKey=AXPERT-" +
          AppStorage().retrieveValue(AppStorage.SESSIONID) +
          "&params=^act=load^recordid=" +
          activeList.recordid.toString();
    }
    return url;
  }

  static String activeList_CreateURL_MESSAGE(
    activeList,
  ) {
    var url = "";
    var msgType = activeList.msgtype.toString().toUpperCase().trim();
    if (msgType == "MESSAGE" ||
        msgType == "FORM NOTIFICATION" ||
        msgType == "PERIODIC NOTIFICATION" ||
        msgType == "CACHED SAVE") {
      var hlink_TRANID = activeList.hlink_transid.toString();
      var hlink_PARAMS = activeList.hlink_params.toString().startsWith("^")
          ? activeList.hlink_params.toString()
          : "^" + activeList.hlink_params.toString();
      url = "aspx/AxMain.aspx?pname=" +
          hlink_TRANID +
          "&authKey=AXPERT-" +
          AppStorage().retrieveValue(AppStorage.SESSIONID) +
          "&params=" +
          hlink_PARAMS;
    }
    return url;
  }

  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", 'Location services are disabled. Please enable the services',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", 'Location permissions are denied',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", 'Location permissions are permanently denied, we cannot request permissions.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (hasPermission)
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    else
      return null;
  }

  static Future<String> getAddressFromLatLng(Position position) async {
    var output = '';
    await placemarkFromCoordinates(position.latitude, position.longitude).then((placemarks) {
      output = placemarks[0].toString();
    });
    return output;
  }
}

class LoadingScreen {
  static const backName = "DisableBack";

  static show({status = "Please Wait...", maskType = EasyLoadingMaskType.black}) {
    BackButtonInterceptor.add(myInterceptor, zIndex: 2, name: backName);
    EasyLoading.show(status: status, maskType: maskType, dismissOnTap: false);
    Timer(Duration(seconds: 20), () {
      if (EasyLoading.isShow) {
        dismiss();
        // Get.snackbar("Error", "Unable to fetch data",
        //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
  }

  static dismiss() {
    BackButtonInterceptor.removeByName(backName);
    EasyLoading.dismiss();
  }

  static bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }
}

showErrorSnack({title = 'Error', message = 'Server busy, Please try again later.', show_errorSnackbar = true}) {
  if (show_errorSnackbar)
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.redAccent);
}

Future<bool> showBiometricDialog() async {
  try {
    final auth = LocalAuthentication();

    final isAuthenticated = await auth.authenticate(
      localizedReason: "Please use your touch ID to login",
      authMessages: const <AuthMessages>[
        AndroidAuthMessages(
          signInTitle: 'Biometric authentication required!',
          cancelButton: 'No thanks',
        ),
        IOSAuthMessages(
          cancelButton: 'No thanks',
        )
      ],
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: false,
        stickyAuth: false,
      ),
    );

    return isAuthenticated;
  } catch (e) {
    return false;
  }
}

showBiometricDialogOld() async {
  try {
    LocalAuthentication auth = LocalAuthentication();
    return await auth.authenticate(
        localizedReason: "Please use your touch id to login",
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          )
        ],
        options: AuthenticationOptions(biometricOnly: true, useErrorDialogs: false));
  } catch (e) {
    // print(e.toString());
    // if (e.toString().contains('NotAvailable') && e.toString().contains('Authentication failure'))
    //   showErrorSnack(title: "Oops!", message: "Only Biometric is allowed.");
  }
  return false;
}

willShowSetBiometricDialog(user) async {
  AppStorage appStorage = AppStorage();
  var data = await appStorage.retrieveValue(AppStorage.WILL_AUTHENTICATE_FOR_USER) ?? {};
  if (data.isEmpty) {
    return true;
  } else {
    var projectWise = data[Const.PROJECT_NAME] ?? {};
    var userWise = projectWise[user] ?? {};
    if (userWise.isEmpty)
      return true;
    else
      return true;
  }
}

setWillBiometricAuthenticateForThisUser(user, willAuthenticate) async {
  AppStorage appStorage = AppStorage();
  var data = await appStorage.retrieveValue(AppStorage.WILL_AUTHENTICATE_FOR_USER) ?? {};
  var projectWise = data[Const.PROJECT_NAME] ?? {};
  projectWise[user] = willAuthenticate;
  data[Const.PROJECT_NAME] = projectWise;
  await appStorage.storeValue(AppStorage.WILL_AUTHENTICATE_FOR_USER, data);
}

getWillBiometricAuthenticateForThisUser(user) async {
  AppStorage appStorage = AppStorage();
  if ((await appStorage.retrieveValue(AppStorage.CAN_AUTHENTICATE) ?? false) == false) return false;

  var data = await appStorage.retrieveValue(AppStorage.WILL_AUTHENTICATE_FOR_USER) ?? {};
  if (data.isEmpty) {
    return null;
  } else {
    var projectWise = data[Const.PROJECT_NAME] ?? {};
    var userWise = projectWise[user] ?? {};
    try {
      if (userWise.isEmpty) return null;
    } catch (e) {
      return userWise;
    }
  }
}
