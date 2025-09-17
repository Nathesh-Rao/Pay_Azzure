import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Controller/SignUpController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class SignUpUser extends StatefulWidget {
  const SignUpUser({super.key});

  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  void dispose() {
    signUpController.otpSent.value = false;
    signUpController.reSendOtpCount = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios)),
            title: Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: HexColor("#000000"), fontFamily: 'redhatsmbold'),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              elevation: 40,
              color: MyColors.white1,
              shadowColor: MyColors.buzzilyblack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: signUpController.otpSent.value
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome ' + signUpController.userNameController.text.trim(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height * 0.02,
                                color: MyColors.PayAzzureColor2,
                                fontFamily: 'opensansbold'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Enter OTP',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height * 0.02,
                                color: MyColors.blue1,
                                fontFamily: 'poppinssemibold'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "OTP Sent Successfully",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.height * 0.02,
                                color: MyColors.PayAzzureColor2,
                                fontFamily: 'opensansbold'),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: 350,
                            child: OTPTextField(
                              spaceBetween: 0,
                              length: 6,
                              fieldWidth: 50,
                              style: const TextStyle(fontSize: 20),
                              hasError: signUpController.otpHasError.value,
                              obscureText: true,
                              otpFieldStyle: OtpFieldStyle(
                                backgroundColor: MyColors.white2,
                                borderColor: MyColors.PayAzzureColor2,
                              ),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.box,
                              onCompleted: (pin) {
                                signUpController.enteredPin.value = pin;
                                signUpController.verifyOtp();
                              },
                              onChanged: (value) {
                                if (value.length != signUpController.otpLength)
                                  signUpController.otpHasError.value = true;
                                else {
                                  signUpController.otpHasError.value = false;
                                  signUpController.enteredPin.value = value;
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            signUpController.errOtp.value,
                            style: const TextStyle(color: MyColors.red, fontSize: 12, fontFamily: 'opensansbold'),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              signUpController.verifyOtp();
                            },
                            child: Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  'Verify OTP',
                                  style: TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          signUpController.showTimer.value
                              ? Text(
                                  "Resend OTP in " + signUpController.timerText.value.toString(),
                                  style: const TextStyle(color: MyColors.PayAzzureColor2, fontSize: 15, fontWeight: FontWeight.w700),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    signUpController.reSendOTP();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(width: 2, color: MyColors.PayAzzureColor2)),
                                    child: Text(
                                      "Resend OTP",
                                      style: TextStyle(
                                          color: MyColors.PayAzzureColor2,
                                          fontFamily: 'redhabold',
                                          fontSize: MediaQuery.of(context).size.height * 0.02),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 30),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/buzzily-logo.png',
                              width: 90,
                              height: 35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField(
                              value: signUpController.ddSelectedValue.value,
                              isExpanded: true,
                              items: signUpController.dropdownMenuItem().toList(),
                              onChanged: signUpController.dropDownItemChanged),
                          SizedBox(height: 10),
                          Visibility(
                            visible: signUpController.userIdVisible.value,
                            child: TextField(
                              controller: signUpController.userIdController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              //  enabled: false,
                              decoration: InputDecoration(
                                errorText: signUpController.evaluteError(signUpController.errUserId),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                hintText: 'User Id',
                                hintStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: HexColor("#3E4153"))),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: HexColor("#5C5C5D"),
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.only(top: 15, left: 10),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: signUpController.userNameVisible.value,
                            child: TextField(
                              controller: signUpController.userNameController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,

                              //  enabled: false,
                              decoration: InputDecoration(
                                errorText: signUpController.evaluteError(signUpController.errUserName),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                hintText: 'Username',
                                hintStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: HexColor("#3E4153"))),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: HexColor("#5C5C5D"),
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.only(top: 15, left: 10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: signUpController.userPassController,
                            obscureText: !signUpController.showPass.value,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              errorText: signUpController.evaluteError(signUpController.errUserPass),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#E2E1E6")),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#E2E1E6")),
                              ),
                              hintText: 'Password',
                              hintStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: HexColor("#3E4153"))),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: HexColor("#5C5C5D"),
                                size: 20,
                              ),
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  signUpController.showPass.value ? Icons.visibility_off : Icons.visibility,
                                  color: HexColor("#4E9AF5"),
                                ),
                                onTap: () {
                                  signUpController.showPass.toggle();
                                },
                              ),
                              filled: true,
                              fillColor: MyColors.white1,
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                fontSize: 22,
                              )),
                              contentPadding: const EdgeInsets.only(top: 15, left: 10),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: signUpController.userConfirmPassController,
                            obscureText: !signUpController.showConPass.value,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              errorText: signUpController.evaluteError(signUpController.errUserConPass),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#E2E1E6")),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#E2E1E6")),
                              ),
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins', color: HexColor("#3E4153")),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: HexColor("#5C5C5D"),
                                size: 20,
                              ),
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  signUpController.showConPass.value ? Icons.visibility_off : Icons.visibility,
                                  color: HexColor("#4E9AF5"),
                                ),
                                onTap: () {
                                  signUpController.showConPass.toggle();
                                },
                              ),
                              filled: true,
                              fillColor: MyColors.white1,
                              labelStyle: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Poppins',
                              ),
                              contentPadding: const EdgeInsets.only(top: 15, left: 10),
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: signUpController.userEmaiVisible.value,
                            child: TextField(
                              controller: signUpController.userEmailController,
                              textInputAction: TextInputAction.next,
                              //  enabled: false,
                              decoration: InputDecoration(
                                errorText: signUpController.evaluteError(signUpController.errUserEmail),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins', color: HexColor("#3E4153")),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: HexColor("#5C5C5D"),
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.only(top: 15, left: 10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: signUpController.userMobileVisible.value,
                            child: TextField(
                              controller: signUpController.userMobileController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ],
                              /* inputFormatters: [
                                                          LengthLimitingTextInputFormatter(10),
                                                          FilteringTextInputFormatter.deny(RegExp("[-.,' ']"))
                                                        ],*/
                              decoration: InputDecoration(
                                errorText: signUpController.evaluteError(signUpController.errUserMobile),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#E2E1E6")),
                                ),
                                hintText: 'Mobile No',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins', color: HexColor("#3E4153")),
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: HexColor("#5C5C5D"),
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.only(top: 15, left: 10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: InkWell(
                              onTap: () {
                                signUpController.registerButtonCalled();
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text('Register',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          color: MyColors.white1)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 70, right: 70),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Existing User ?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: HexColor("#3E4153"))),
                                  Text(
                                    "Sign In",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        color: HexColor("#4E9AF5")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          FittedBox(
                            child: Text(
                              "By using the software, you agree to the",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1,
                                  color: Colors.black),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Colors.blue,
                                      letterSpacing: 1),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  " and the",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      letterSpacing: 1),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  " Terms of Use",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Colors.blue,
                                      letterSpacing: 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Powered By",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                letterSpacing: 1),
                          ),
                          Image.asset(
                            'assets/images/agilelabslogo.png',
                            height: MediaQuery.of(context).size.height * 0.035,
                            width: MediaQuery.of(context).size.width * 0.075,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ));
  }
}
