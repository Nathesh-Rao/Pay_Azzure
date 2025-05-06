import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/VersionUpdateClearOldData.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Model/ProjectModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  var _animationController;
  AppStorage appStorage = AppStorage();
  ProjectModel? projectModel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animationController.forward();
    VersionUpdateClearOldData.clearAllOldData();
    checkIfDeviceSupportBiometric();
    Future.delayed(Duration(milliseconds: 1800), () {
      _animationController.stop();
      configMainProject();
      var cached = appStorage.retrieveValue(AppStorage.CACHED);
      try {
        if (cached == null)
          Get.offAllNamed(Routes.ProjectListingPage);
        else {
          var jsonProject = appStorage.retrieveValue(cached);
          projectModel = ProjectModel.fromJson(jsonProject);
          Const.PROJECT_NAME = projectModel!.projectname;
          Const.PROJECT_URL = projectModel!.web_url;
          Const.ARM_URL = projectModel!.arm_url;
          Get.offAllNamed(Routes.Login);
        }
      } catch (e) {
        Get.offAllNamed(Routes.ProjectListingPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: Container(
                height: 80,
                width: 80,
                child: Image.asset(
                  'assets/images/axAppLogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Padding(
          //     padding: EdgeInsets.only(right: 20, bottom: 20),
          //     child: Text("Version: "),
          //   ),
          // )
        ],
      ),
    );
  }

  void checkIfDeviceSupportBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    print("canAuthenticate: $canAuthenticate");
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      print("List: $availableBiometrics");
      // if (availableBiometrics.contains(BiometricType.fingerprint) ||
      //     availableBiometrics.contains(BiometricType.weak) ||
      //     availableBiometrics.contains(BiometricType.strong))
      if (availableBiometrics.isNotEmpty) {
        AppStorage().storeValue(AppStorage.CAN_AUTHENTICATE, canAuthenticate);
      } else {
        AppStorage().remove(AppStorage.CAN_AUTHENTICATE);
      }
    }
  }

  void configMainProject() {
    var jsonList = appStorage.retrieveValue(AppStorage.PROJECT_LIST);
    if (jsonList == null) {
      appStorage.storeValue(AppStorage.PROJECT_LIST, jsonEncode(["payrolldev"]));
      var paProject = {
        "projectCaption": "payrolldev",
        "projectname": "payrolldev",
        "url": "",
        "scripts_uri": "",
        "dbtype": "",
        "expirydate": "",
        "notify_uri": "",
        "web_url": "https://dev.payazzure.com/run",
        "arm_url": "https://dev.payazzure.com/ArmMobile"
      };

      appStorage.storeValue("payrolldev", paProject);
    }
  }
}
/*
AnimatedSplashScreen(
      duration: 2000,
      splash: Image.asset(
        'assets/images/agilelabslogo.png',
        height: 200,
        width: 200,
      ),
      splashTransition: SplashTransition.rotationTransition,
      nextScreen: ProjectListingPage(),
      // nextRoute: Routes.SplashScreen,
    )
*
AnimatedBuilder(
              builder: (context, child) {
                var v = Transform.rotate(
                  angle: _animationController.value < 1 ? _animationController.value * 8 : 1,
                  child: child,
                );
                print(_animationController.value);
                return v;
              },
              animation: _animationController,
              child: Container(
                height: 150,
                width: 150,
                child: Image.asset(
                  'assets/images/agilelabslogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            )



*/
