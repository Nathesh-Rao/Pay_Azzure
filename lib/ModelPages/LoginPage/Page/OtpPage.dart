import 'dart:async';

import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Widgets/WidgetCharts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/CommonMethods.dart';
import '../../../Constants/Const.dart';
import '../../../Constants/MyColors.dart';
import '../../../Constants/Routes.dart';
import '../Controller/LoginController.dart';
import '../Widgets/WidgetLoginButton.dart';
import '../Widgets/WidgetOtpTextField.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  LoginController loginController = Get.find();

  //Duration _remaining = const Duration(minutes: 2, seconds: 00);
  late Duration _remaining;
  Timer? _timer;
  bool _isTimerActive = true;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Clear navigation stack and go to login
          Get.offAllNamed(Routes.Login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Hero(
            tag: 'axpertImage',
            child: Image.asset(
              'assets/images/pay_azzure_text.png',
              // 'assets/images/buzzily-logo.png',
              // height: MediaQuery.of(context).size.height * 0.048,
              width: MediaQuery.of(context).size.width * 0.24,
              fit: BoxFit.fill,
            ),
          ),
          /*actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.ProjectListingPage);
              },
              icon: Icon(
                CupertinoIcons.plus_rectangle_fill_on_rectangle_fill,
                color: MyColors.AXMDark,
              ))
        ],*/
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      "OTP",
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        color: MyColors.AXMDark,
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        loginController.otpMsg.value,
                        //"Sign in to enjoy the best managing experience\nEnter Your Credentials",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MyColors.AXMGray,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    Obx(() => _projectNameWidget(projectName: loginController.currentProjectName.value)),
                    Obx(
                      () => WidgetOtpTextField(
                        label: "OTP",
                        controller: loginController.otpFieldController,
                        isLoading: loginController.isOtpLoading.value,
                        otpLength: int.parse(loginController.otpChars.value),
                        errorText: loginController.otpErrorText.value,
                        onCompleted: loginController.callVerifyOTP,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(_formattedTime,
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: MyColors.PayAzzureColor2,
                                  ))
                            ],
                          ),
                          Spacer(),
                          Text("Didn't receive any code? ",
                              style: GoogleFonts.manrope(
                                // decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: MyColors.AXMGray,
                              )),
                          InkWell(
                            onTap: _isTimerActive
                                ? null // Disable tap
                                : () {
                                    // Handle resend OTP logic
                                    _startCountdown();
                                    loginController.callResendOTP();
                                  },
                            child: Text("RESEND",
                                style: GoogleFonts.manrope(
                                  // decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _isTimerActive ? Colors.grey : MyColors.AXMDark,
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40),

                    WidgetLoginButton(
                      label: "Login",
                      onPressed: () {
                        loginController.callVerifyOTP();
                      },
                    ),
                    // Center(
                    //   child: Text("${MediaQuery.of(context).size.height * 0.065}"),
                    // ),
                    // SizedBox(height: 20),

                    SizedBox(height: 30),
                    FittedBox(
                      child: Text(
                        "By using the software, you agree to the",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 1, color: Colors.black)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text("Privacy Policy",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.blue,
                                    letterSpacing: 1),
                              )),
                        ),
                        FittedBox(
                          child: Text(" and the",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black, letterSpacing: 1),
                              )),
                        ),
                        FittedBox(
                          child: Text(" Terms of Use",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.blue,
                                    letterSpacing: 1),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Powered By",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black, letterSpacing: 1),
                        )),
                    Image.asset(
                      'assets/images/agilelabslogo.png',
                      height: MediaQuery.of(context).size.height * 0.04,
                      // width: MediaQuery.of(context).size.width * 0.075,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 25, 10),
                    child: FutureBuilder(
                        future: loginController.getVersionName(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              "Version:${snapshot.data}_${Const.APP_RELEASE_DATE}",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: MyColors.buzzilyblack,
                                      fontWeight: FontWeight.w700,
                                      fontSize: MediaQuery.of(context).size.height * 0.012)),
                            );
                          } else {
                            return Text("");
                          }
                        })),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _projectNameWidget({required String projectName}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xffD9D9D9).withAlpha(125),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(projectName,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: MyColors.AXMDark,
                )),
          ),
        ),
      ],
    );
  }

  void _startCountdown() {
    _isTimerActive = true;
    _remaining = Duration(minutes: int.parse(loginController.otpExpiryTime.value));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerActive = false; // Enable RESEND
        });
      }
    });
  }

  String get _formattedTime {
    final minutes = _remaining.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds min';
  }
}
