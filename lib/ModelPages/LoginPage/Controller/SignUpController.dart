import 'dart:async';
import 'dart:convert';

import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var userTypeList = [].obs;
  var ddSelectedValue = ''.obs;
  var userIdVisible = false.obs;
  var userNameVisible = false.obs;
  var userEmaiVisible = false.obs;
  var userMobileVisible = false.obs;
  TextEditingController userIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPassController = TextEditingController();
  TextEditingController userConfirmPassController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userMobileController = TextEditingController();
  var errUserId = ''.obs;
  var errUserName = ''.obs;
  var errUserPass = ''.obs;
  var errUserConPass = ''.obs;
  var errUserEmail = ''.obs;
  var errUserMobile = ''.obs;
  var errOtp = ''.obs;
  var showPass = false.obs;
  var showConPass = false.obs;
  var otpSent = false.obs;
  var otpHasError = true.obs;
  var showTimer = true.obs;
  var otpLength = ''.obs;
  var otpAttempts = ''.obs;
  var regID = ''.obs;
  var reSendOtpCount = 0;
  var enteredPin = ''.obs;
  ServerConnections serverConnections = ServerConnections();

  int timerMaxSeconds = 60;
  int currentSeconds = 0;
  var timerText = '00:00'.obs;

  SignUpController() {
    fetchUserTypeList();

    print(userTypeList);
  }

  fetchUserTypeList() async {
    LoadingScreen.show();

    var url = Const.getFullARMUrl(ServerConnections.API_GET_USERGROUPS);
    var body = Const.getAppBody();
    var data = await serverConnections.postToServer(url: url, body: body);
    LoadingScreen.dismiss();

    data = data.toString().replaceAll("null", "\"\"");

    var jsopnData = jsonDecode(data)['result']['data'] as List;
    userTypeList.clear();
    for (var item in jsopnData) {
      String val = item["usergroup"].toString();
      userTypeList.add(CommonMethods.capitalize(val));
    }
    userTypeList..sort((a, b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
    userTypeList.remove("Power");
    ddSelectedValue.value = userTypeList[0];
    dropDownItemChanged(ddSelectedValue);
  }

  startTimer() {
    showTimer.value = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      currentSeconds = timer.tick;
      timerText.value =
          '${(((timerMaxSeconds - currentSeconds) ~/ 60) % 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

      if (timer.tick >= timerMaxSeconds) {
        showTimer.value = false;
        timer.cancel();
      }
    });
  }

  dropdownMenuItem() {
    List<DropdownMenuItem<String>> myList = [];
    for (var item in userTypeList) {
      DropdownMenuItem<String> dditem = DropdownMenuItem(
        value: item.toString(),
        child: Text(item),
      );
      myList.add(dditem);
    }
    // print(myList);
    return myList;
  }

  dropDownItemChanged(Object? value) {
    ddSelectedValue.value = value.toString();
    if (ddSelectedValue.value.toString().toLowerCase() == "internal") {
      userIdVisible.value = true;
      userNameVisible.value = false;
      userMobileVisible.value = false;
      userEmaiVisible.value = false;
    }

    if (ddSelectedValue.value.toString().toLowerCase() == "external") {
      userIdVisible.value = false;
      userNameVisible.value = true;
      userMobileVisible.value = true;
      userEmaiVisible.value = true;
    }
    clearFieldValues();
  }

  evaluteError(errMsg) {
    return errMsg.value == '' ? null : errMsg.value;
  }

  validateForm() {
    errUserId.value =
        errUserName.value = errUserPass.value = errUserConPass.value = errUserEmail.value = errUserMobile.value = '';
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$';
    RegExp regex = RegExp(pattern.toString());

    if (ddSelectedValue.toLowerCase() == "internal") {
      if (userIdController.text.trim() == "") {
        errUserId.value = "Enter valid UserID";
        return false;
      }
      if (userPassController.text.trim() == "") {
        errUserPass.value = "Enter Password";
        return false;
      }
      if (!regex.hasMatch(userPassController.text)) {
        errUserPass.value = "Password should contain upper,lower,digit and Special character";
        return false;
      }
      if (userPassController.text.length <= 7) {
        errUserPass.value = "Password is Weak Must be more than 8 characters";
        return false;
      }
      if (userConfirmPassController.text.trim() == "") {
        errUserConPass.value = "Enter Confirm Password";
        return false;
      }
      if (userConfirmPassController.text.trim() != userPassController.text.trim()) {
        errUserConPass.value = "Password and Confirm Password should match";
        return false;
      }
    } else {
      if (userNameController.text.trim() == "") {
        errUserName.value = "Enter valid Username";
        return false;
      }
      if (userPassController.text.trim() == "") {
        errUserPass.value = "Enter Password";
        return false;
      }
      if (!regex.hasMatch(userPassController.text)) {
        errUserPass.value = "Password should contain upper,lower,digit and Special character";
        return false;
      }
      if (userPassController.text.length <= 7) {
        errUserPass.value = "Password is Weak Must be more than 8 characters";
        return false;
      }
      if (userConfirmPassController.text.trim() == "") {
        errUserConPass.value = "Enter Confirm Password";
        return false;
      }
      if (userConfirmPassController.text.trim() != userPassController.text.trim()) {
        errUserConPass.value = "Password and Confirm Password should match";
        return false;
      }
      if (userEmailController.text.trim() == "") {
        errUserEmail.value = "Enter Email ID";
        return false;
      }
      if (!userEmailController.text.trim().isEmail) {
        errUserEmail.value = "Enter valid Email ID";
        return false;
      }
      if (userMobileController.text.trim() == "") {
        errUserMobile.value = "Enter Mobile Number";
        return false;
      }
      if (userMobileController.text.trim().length != 10) {
        errUserMobile.value = "Enter valid Mobile Number";
        return false;
      }
    }
    return true;
  }

  void registerButtonCalled() async {
    if (validateForm()) {
      LoadingScreen.show();
      var body = getJsonBody();
      var url = Const.getFullARMUrl(ServerConnections.API_ADDUSER);
      var responses = await serverConnections.postToServer(url: url, body: body);
      try {
        if (responses != "") {
          var jsonResponse = jsonDecode(responses);
          if (responses.toString().toLowerCase().contains("otp")) {
            otpAttempts.value = jsonResponse["result"]["otpattemptsleft"];
            regID.value = jsonResponse["result"]["regid"];
            otpLength.value = jsonResponse["result"]["otplength"];
            otpSent.value = true;
            startTimer();
          } else {
            Get.snackbar("Alert!", jsonResponse["result"]["message"],
                snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      } catch (e) {
        //error
      } finally {
        LoadingScreen.dismiss();
      }
    }
  }

  void reSendOTP() {
    try {
      if (reSendOtpCount < int.parse(otpAttempts.value)) {
        registerButtonCalled();
        reSendOtpCount++;
        errOtp.value = "";
      } else {
        errOtp.value = "You exceeds the maximum limit.\nPlease try again later";
      }
    } catch (e) {
      errOtp.value = "You exceeds the maximum limit.\nPlease try again later";
    }
    // startTimer();/
  }

  getJsonBody() {
    Map iBody = {
      "appname": Const.PROJECT_NAME,
      "userid": userIdController.text.trim(),
      "password": userPassController.text.trim(),
      "usergroup": ddSelectedValue.toLowerCase(),
    };
    Map eBody = {
      "appname": Const.PROJECT_NAME,
      "username": userNameController.text.trim(),
      "password": userPassController.text.trim(),
      "email": userEmailController.text.trim(),
      "mobile": userMobileController.text.trim(),
      "usergroup": ddSelectedValue.toLowerCase(),
    };
    return ddSelectedValue.toLowerCase() == "internal" ? jsonEncode(iBody) : jsonEncode(eBody);
  }

  void verifyOtp() async {
    LoadingScreen.show();
    Map otpBody = {
      'regid': regID.value,
      'otp': enteredPin.value,
    };
    var url = Const.getFullARMUrl(ServerConnections.API_OTP_VALIDATE_USER);
    var responses = await serverConnections.postToServer(url: url, body: jsonEncode(otpBody));

    if (responses != "") {
      var jsonResp = jsonDecode(responses);
      if (jsonResp['result']['success'].toString() == "false") {
        errOtp.value = jsonResp['result']['message'];
      } else {
        Get.defaultDialog(
            title: "Success",
            middleText: jsonResp['result']['message'].toString(),
            confirm: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text("Ok")));
      }
    } else {
      Get.snackbar("Alert!", "Some error occured",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
    reSendOtpCount++;
    LoadingScreen.dismiss();
  }

  clearFieldValues() {
    userIdController.clear();
    userNameController.clear();
    userPassController.clear();
    userConfirmPassController.clear();
    userEmailController.clear();
    userMobileController.clear();
  }
}
