import 'dart:io';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Controller/LoginController.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Widgets/WidgetLoginTextField.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Constants/CommonMethods.dart';
import '../../../Constants/Enums.dart';
import '../Widgets/WidgetLoginButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();

    /*SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );*/
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginController.onLoad();
    });
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.ProjectListingPage);
              },
              icon: Icon(
                CupertinoIcons.plus_rectangle_fill_on_rectangle_fill,
                color: MyColors.AXMDark,
              ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    "SignIn",
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: MyColors.AXMDark,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Sign in to enjoy the best managing experience\nEnter Your Credentials",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: MyColors.AXMGray,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Obx(() => _projectNameWidget(projectName: loginController.currentProjectName.value)),
                  Obx(
                        () => WidgetLoginTextField(
                      label: "Username",
                      isLoading: loginController.isUserDataLoading.value,
                      controller: loginController.userNameController,
                    ),
                  ),

                  Obx(
                        () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        final fade = FadeTransition(opacity: animation, child: child);
                        return SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.vertical,
                          child: fade,
                        );
                      },
                      child: loginController.isPWD_auth.value
                          ? WidgetLoginTextField(
                        key: const ValueKey("rotating"),
                        label: "Password",
                        hintText: "Enter Password",
                        focusNode: loginController.passwordFocus,
                        obscureText: loginController.showPassword.value,
                        controller: loginController.userPasswordController,
                      )
                          : const SizedBox.shrink(key: ValueKey("empty")),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                        () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              loginController.rememberMe.toggle();
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: loginController.rememberMe.value,
                                  onChanged: (value) => {loginController.rememberMe.toggle()},
                                  checkColor: Colors.white,
                                  side: BorderSide(
                                    color: MyColors.PayAzzureColor2,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  activeColor: MyColors.PayAzzureColor2,
                                ),
                                Text("Remember Me",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ))
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.ForgetPassword);
                            },
                            child: Text("Forgot Password?",
                                style: GoogleFonts.manrope(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.blueAccent,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),

                  Obx(
                        () => WidgetLoginButton(
                      label: "Next",
                      visible: loginController.authType.value == AuthType.none || loginController.authType.value == AuthType.otpOnly,
                      onPressed: () {
                        loginController.startLoginProcess();
                      },
                    ),
                  ),
                  Obx(
                        () => WidgetLoginButton(
                      label: _getLoginButtonLabel(),
                      visible: loginController.authType.value == AuthType.both || loginController.authType.value == AuthType.passwordOnly,
                      onPressed: () {
                        loginController.callSignInAPI();
                      },
                    ),
                  ),
                  // Center(
                  //   child: Text("${MediaQuery.of(context).size.height * 0.065}"),
                  // ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: loginController.googleSignInVisible.value,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            foregroundColor: MyColors.buzzilyblack,
                            backgroundColor: MyColors.white1,
                            minimumSize: Size(double.infinity, 60),
                          ),
                          icon: Icon(FontAwesomeIcons.google, color: MyColors.red),
                          label: Text('Sign In With Google',
                              style:
                              GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: HexColor("#3E4153")))),
                          onPressed: () {
                            loginController.googleSignInClicked();
                          }),
                    ),
                  ),
                  SizedBox(height: 10),
                  // InkWell(
                  //   onTap: () {
                  //     Get.toNamed(Routes.SignUp);
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 70, right: 70),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text("New user?  ",
                  //             style: GoogleFonts.poppins(
                  //                 textStyle:
                  //                     TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: HexColor("#3E4153")))),
                  //         Text(
                  //           "Sign up",
                  //           style: GoogleFonts.poppins(
                  //               textStyle: TextStyle(
                  //                   decoration: TextDecoration.underline,
                  //                   fontWeight: FontWeight.w600,
                  //                   fontSize: 12,
                  //                   color: HexColor("#4E9AF5"))),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20),
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

                  Visibility(
                    visible: loginController.willAuthenticate.value,
                    child: GestureDetector(
                      onTap: () {
                        loginController.displayAuthenticationDialog();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.fingerprint_outlined,
                          color: MyColors.PayAzzureColor2,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                    ),
                  )
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

  _getLoginButtonLabel() {
    if (loginController.authType.value == AuthType.passwordOnly) return "Login";
    if (loginController.authType.value == AuthType.both) return "Get OTP";
    return "Login";
  }
}
