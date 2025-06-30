import 'dart:io';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Controller/LoginController.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = Get.put(LoginController());
  PullToRefreshController pullToRefreshController = PullToRefreshController();

  @override
  Widget build(BuildContext context) {
    // LogService.writeLog(message: "LoginPage => PROJECT_NAME => ${Const.PROJECT_NAME}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginController.onLoad();
    });
    return Obx(() => Scaffold(
          appBar: Platform.isIOS
              ? AppBar(
                  elevation: 0,
                  toolbarHeight: 1,
                  backgroundColor: Colors.white,
                )
              : null,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Get.toNamed(Routes.ProjectListingPage);
                                },
                                icon: Icon(Icons.settings),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Hero(
                                  tag: 'axpertImage',
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/pay_azzure_text.png',
                                      // 'assets/images/buzzily-logo.png',
                                      height: MediaQuery.of(context).size.height * 0.048,
                                      width: MediaQuery.of(context).size.width * 0.38,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                Text('Login',
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black))),
                                SizedBox(height: 10),
                                Text('Enter Your Credentials',
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black))),
                              ],
                            ),
                            // Align(
                            //   alignment: Alignment.topRight,
                            //   child: Padding(
                            //     padding: EdgeInsets.only(right: 30),
                            //     child: Image.asset(
                            //       'assets/images/buzzily.png',
                            //       height: MediaQuery.of(context).size.height * 0.13,
                            //       width: MediaQuery.of(context).size.width * 0.24,
                            //       fit: BoxFit.fill,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Obx(
                          () => Text(
                            loginController.currentProjectName.value,
                            // Const.PROJECT_NAME.toString().toUpperCase(),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.black)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: loginController.userNameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            // filled: true,
                            // fillColor: MyColors.blue2,
                            focusColor: MyColors.blue2,

                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2, color: MyColors.blue2)),
                            errorText: loginController.errMessage(loginController.errUserName),
                            labelText: "Username",
                            hintText: "Enter Username",
                            prefixIcon: Icon(Icons.person),
                            // border: OutlineInputBorder(
                            //   borderSide: BorderSide(width: 1),
                            //   borderRadius: BorderRadius.circular(10),
                            // )
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: loginController.userPasswordController,
                          obscureText: loginController.showPassword.value,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: loginController.errMessage(loginController.errPassword),
                            labelText: "Password",
                            hintText: "Enter Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  loginController.showPassword.toggle();
                                },
                                icon: loginController.showPassword.value
                                    ? Icon(
                                        Icons.visibility,
                                        color: MyColors.blue2,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: MyColors.blue2,
                                      )),
                            // border: OutlineInputBorder(
                            //   borderSide: BorderSide(width: 1),
                            //   borderRadius: BorderRadius.circular(10),
                            // )
                          ),
                        ),
                        SizedBox(height: 10),
                        // DropdownButtonHideUnderline(
                        //   child: ButtonTheme(
                        //     alignedDropdown: true,
                        //     child: DropdownButtonFormField(
                        //       value: loginController.ddSelectedValue.value,
                        //       items: loginController.dropdownMenuItem(),
                        //       onChanged: (value) => loginController.dropDownItemChanged(value),
                        //       decoration: InputDecoration(prefixIcon: Icon(Icons.group)),
                        //       // border: OutlineInputBorder(
                        //       //   borderRadius: BorderRadius.circular(10),
                        //       // )
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Row(
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
                                    fillColor: MaterialStateProperty.resolveWith(loginController.getColor),
                                  ),
                                  Text("Remember Me")
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.ForgetPassword);
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: HexColor("#3E4153"),
                                    fontWeight: FontWeight.w600,
                                    fontSize: MediaQuery.of(context).size.height * 0.016),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: InkWell(
                            onTap: () {
                              loginController.loginButtonClicked();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(color: MyColors.blue2, borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: MyColors.white1)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: loginController.googleSignInVisible.value,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  foregroundColor: MyColors.buzzilyblack,
                                  backgroundColor: MyColors.white1,
                                  minimumSize: Size(double.infinity, 48),
                                ),
                                icon: Icon(FontAwesomeIcons.google, color: MyColors.red),
                                label: Text('Sign In With Google',
                                    style: GoogleFonts.poppins(
                                        textStyle:
                                            TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: HexColor("#3E4153")))),
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
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 1, color: Colors.black)),
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
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black, letterSpacing: 1),
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
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black, letterSpacing: 1),
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
                                color: MyColors.blue2,
                                size: MediaQuery.of(context).size.height * 0.04,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
                                "Version:${snapshot.data}${Const.RELEASE_ID}",
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
        ));
  }
}
