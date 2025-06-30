import 'dart:async';
import 'dart:convert';

import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final globalVariableController = Get.find<GlobalVariableController>();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  ServerConnections serverConnections = ServerConnections();
  var errUserName = ''.obs;
  var showPass = false.obs;
  var showConPass = false.obs;
  var showOTP = false.obs;
  var OTPSent = false.obs;
  var emailError = ''.obs;
  var otpError = ''.obs;
  var passError = ''.obs;
  var conPassError = ''.obs;
  var otpHasError = true.obs;
  var enteredPin = ''.obs;
  var otpLength = ''.obs;

  var otpAttempts = ''.obs;
  var regID = ''.obs;
  int timerMaxSeconds = 60;
  int currentSeconds = 0;
  var timerText = '00:00'.obs;
  var showTimer = true.obs;
  var reSendOtpCount = 0;

  bool vaidateForm() {
    emailError.value = '';
    if (userNameController.text.toString().trim() == "") {
      errUserName.value = "Enter User Name";
      return false;
    }
    if (emailController.text.trim() == "") {
      emailError.value = "Please Enter Email ID";
      return false;
    }
    if (!emailController.text.trim().isEmail) {
      emailError.value = "Please Enter a valid Email ID";
      return false;
    }
    return true;
  }

  bool validateOTPSubmittionForm() {
    otpError.value = passError.value = conPassError.value = '';
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$';
    RegExp regex = RegExp(pattern.toString());
    if (otpController.text.toString() == "") {
      otpError.value = "Enter OTP";
      return false;
    }
    if (otpController.text.length.toString() != otpLength.value.toString()) {
      otpError.value = "Please Enter valid OTP";
      return false;
    }
    if (passwordController.text.trim() == "") {
      passError.value = "Enter Password";
      return false;
    }
    if (!regex.hasMatch(passwordController.text)) {
      passError.value = "Password should contain upper,lower,digit and Special character";
      return false;
    }
    if (passwordController.text.length <= 7) {
      passError.value = "Password is Weak Must be more than 8 characters";
      return false;
    }
    if (confirmPasswordController.text.trim() == "") {
      conPassError.value = "Enter Confirm password";
      return false;
    }
    if (confirmPasswordController.text != passwordController.text.trim()) {
      conPassError.value = "Password does not match";
      return false;
    }
    return true;
  }

  /*void proceedButtonClicked() async {
    if (vaidateForm()) {
      LoadingScreen.show();
      Map body = {'email': emailController.text.trim().toString()};
      var url = Const.getFullARMUrl(ServerConnections.API_FORGOTPASSWORD);
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body));
      LoadingScreen.dismiss();
      if (resp.toString() != "") {
        var jsonMsg = jsonDecode(resp);
        print(jsonMsg);
        if (jsonMsg['result']['success'].toString() == "false") {
          Get.snackbar("Alert!", jsonMsg['result']['message'],
              snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.red);
        } else {
          otpAttempts.value = jsonMsg["result"]["otpattemptsleft"];
          regID.value = jsonMsg["result"]["regid"];
          otpLength.value = jsonMsg["result"]["otplength"];
          OTPSent.value = true;
          startTimer();
        }
      }
    }
  }*/

  void proceedButtonClicked() async {
    if (vaidateForm()) {
      LoadingScreen.show();
      Map body = {
        "appname": globalVariableController.PROJECT_NAME.value,
        "username": userNameController.text.toString().trim(),
        "usergroup": "Power",
        'email': emailController.text.trim().toString()
      };
      var url = Const.getFullARMUrl(ServerConnections.API_FORGOTPASSWORD);
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body));
      LoadingScreen.dismiss();
      if (resp.toString() != "") {
        var jsonMsg = jsonDecode(resp);
        print(jsonMsg);
        if (jsonMsg['result']['success'].toString() == "false") {
          Get.snackbar("Alert!", jsonMsg['result']['message'],
              snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.red);
        } else {
          Get.defaultDialog(
              title: "Success",
              middleText: "  Password is reset and sent to your email  ",
              confirm: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text("OK")));

          /*  otpAttempts.value = jsonMsg["result"]["otpattemptsleft"];
          regID.value = jsonMsg["result"]["regid"];
          otpLength.value = jsonMsg["result"]["otplength"];
          OTPSent.value = true;
          startTimer();*/
        }
      }
    }
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

  void verifyOtp() async {
    LoadingScreen.show();
    Map otpBody = {
      'regid': regID.value,
      'otp': enteredPin.value,
    };
    var url = Const.getFullARMUrl(ServerConnections.API_OTP_VALIDATE_USER);
    var responses = await serverConnections.postToServer(url: url, body: jsonEncode(otpBody));
    //print(responses);
    if (responses != "") {
      var jsonResp = jsonDecode(responses);
      if (jsonResp['result']['success'].toString() == "false") {
        otpError.value = jsonResp['result']['message'];
      }
    } else {
      Get.back();
    }
    reSendOtpCount++;
    LoadingScreen.dismiss();
  }

  void reSendOTP() {
    try {
      if (reSendOtpCount < int.parse(otpAttempts.value)) {
        proceedButtonClicked();
        reSendOtpCount++;
        otpError.value = "";
      } else {
        otpError.value = "You exceeds the maximum limit.\nPlease try again later";
      }
    } catch (e) {
      otpError.value = "You exceeds the maximum limit.\nPlease try again later";
    }
    // startTimer();/
  }

  void submitOTPClicked() async {
    if (validateOTPSubmittionForm()) {
      LoadingScreen.show();
      // {"appname": "hcmdev","email": "debasish@agile-labs.com","regid":
      // "4091b470-f0ea-4819-bf4e-a9dc3f457ce6","updatedPassword": "Qwer@123","otp": "334444"}
      Map body = {
        'appname': globalVariableController.PROJECT_NAME.value,
        'email': emailController.text.trim().toString(),
        'regid': regID.value,
        'updatedPassword': passwordController.text.trim().toString(),
        'otp': otpController.text.trim().toString(),
      };
      var url = Const.getFullARMUrl(ServerConnections.API_VALIDATE_FORGETPASSWORD);
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body));
      LoadingScreen.dismiss();
      if (resp != "" && !resp.toString().toLowerCase().contains(("error"))) {
        var jsonResp = jsonDecode(resp);
        if (jsonResp['result']['success'].toString() == "false") {
          Get.snackbar("Alert!", jsonResp['result']['message'],
              snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.red);
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
        // print(resp);
      }
    }
  }
}
