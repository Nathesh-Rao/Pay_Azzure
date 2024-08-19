import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/SettingsPage/Controller/SettingsPageController.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsPageController settingsPageController = Get.put(SettingsPageController());
  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      // backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            height: 330,
            decoration: BoxDecoration(
                gradient: MyColors.updatedUIBackgroundGradient, borderRadius: BorderRadius.vertical(bottom: Radius.circular(0))),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Stack(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        actions: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ))
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30, left: 20),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    minRadius: 50,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      "assets/images/avator.png",
                                      scale: 1.1,
                                    ),
                                    // child: Icon(
                                    //   Icons.person,
                                    //   color: Colors.white,
                                    //   size: 80,
                                    // ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CommonMethods.capitalize(landingPageController.userName.value),
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600)),
                                ),
                                Text(
                                  "Agile Labs Pvt. Ltd.",
                                  style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontSize: 15)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   height: AppBar().preferredSize.height,
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         Get.back();
                  //       },
                  //       child: Container(
                  //         width: 35,
                  //         height: 35,
                  //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                  //         child: Icon(
                  //           Icons.close_rounded,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          // image: DecorationImage(
                          //   image: AssetImage('assets/images/buzzily_flipped.png'),
                          //   alignment: Alignment.bottomRight,
                          //   opacity: 0.3,
                          // ),
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.white,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Image.asset(
                              'assets/images/pay_azzure_text.png',
                              // 'assets/images/buzzily-logo.png',
                              // height: MediaQuery.of(context).size.height * 0.06,
                              // width: MediaQuery.of(context).size.width * 0.38,
                              // fit: BoxFit.fill,
                            ),
                            SizedBox(height: 18),
                            ListTile(
                              onTap: () {
                                settingsPageController.onChangeNotifyStatus();
                              },
                              leading: Icon(Icons.notifications_active_outlined),
                              title: Text(
                                "Notification",
                                style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18)),
                              ),
                              trailing: Obx(() => SizedBox(
                                    width: 60,
                                    child: FlutterSwitch(
                                      height: 30,
                                      value: settingsPageController.notificationOnOffValue.value,
                                      showOnOff: true,
                                      activeColor: MyColors.blue2,
                                      onToggle: (bool values) {
                                        settingsPageController.onChangeNotifyStatus();
                                      },
                                    ),
                                  )),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () async {
                                await Get.defaultDialog(
                                  barrierDismissible: false,
                                  title: "Action",
                                  middleText: "Please select option",
                                  confirm: ElevatedButton(
                                      onPressed: () async {
                                        Get.back();
                                      },
                                      child: Text("Open File")),
                                  cancel: TextButton(
                                      onPressed: () async {
                                        Get.back();
                                      },
                                      child: Text("Cancel")),
                                );
                              },
                              leading: Icon(Icons.description_outlined),
                              title: Text(
                                "Trace",
                                style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18)),
                              ),
                              trailing: Obx(() => SizedBox(
                                    width: 60,
                                    child: FlutterSwitch(
                                      height: 30,
                                      value: settingsPageController.logOnOffValue.value,
                                      showOnOff: true,
                                      activeColor: MyColors.blue2,
                                      onToggle: (bool values) {
                                        settingsPageController.onChangeLogStatus();
                                      },
                                    ),
                                  )),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                landingPageController.showManageWindow(initialIndex: 1);
                              },
                              leading: Icon(Icons.lock_outline),
                              title: Text(
                                "Reset Password",
                                style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18)),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                landingPageController.signOut();
                              },
                              leading: Icon(Icons.power_settings_new),
                              title: Text(
                                "Sign out",
                                style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18)),
                              ),
                            ),
                            Divider(),

                            // TextButton(
                            //     onPressed: () {
                            //       Aes().encryptString(ExecuteApi.API_PrivateKey_DashBoard);
                            //       Aes().decryptString("G7H+G66Z+peBK7zJ3Rq1SA==", ExecuteApi.API_PrivateKey_DashBoard);
                            //       // Aes().encryptString(ExecuteApi.API_PrivateKey_DashBoard);
                            //     },
                            //     child: Text("Encrypt")),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("© agile-labs.com ${DateTime.now().year}"), Text("Version: " + Const.APP_VERSION)],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
