import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/VersionUpdateClearOldData.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/ProjectListing/Model/ProjectModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Utils/LogServices/LogService.dart';
import '../../location_permission.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  var _animationController;
  AppStorage appStorage = AppStorage();
  ProjectModel? projectModel;
  final GlobalVariableController globalVariableController =
      Get.put(GlobalVariableController(), permanent: true);

  @override
  void initState() {
    LogService.writeLog(message: "[>] SplashPage");
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animationController.forward();
    VersionUpdateClearOldData.clearAllOldData();
    checkIfDeviceSupportBiometric();
    Future.delayed(Duration(milliseconds: 1800), () {
      globalVariableController.currentEmployeeData = null;
      _animationController.stop();
      var cached = appStorage.retrieveValue(AppStorage.CACHED);
      LogService.writeLog(message: "[i] SplashPage Cached => $cached");

      try {
        if (cached == null)
          Get.offAllNamed(Routes.ProjectListingPage);
        else {
          var jsonProject = appStorage.retrieveValue(cached);
          LogService.writeLog(
              message: "[i] SplashPage jsonProject => $jsonProject");

          projectModel = ProjectModel.fromJson(jsonProject);
          globalVariableController.PROJECT_NAME.value =
              projectModel!.projectname;
          globalVariableController.WEB_URL.value = projectModel!.web_url;
          globalVariableController.ARM_URL.value = projectModel!.arm_url;
          Get.offAllNamed(Routes.Login);
        }
      } catch (e) {
        LogService.writeLog(message: "[i] SplashPage jsonProject => $e");

        Get.offAllNamed(Routes.ProjectListingPage);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _askLocationPermission();
      // await ensureLocalNetworkPermission();
    });
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
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    LogService.writeLog(
        message:
            "[i] SplashPage\nScope:checkIfDeviceSupportBiometric()\nCanAuthenticate: $canAuthenticate");
    // LogService.writeOnConsole(message: "[i] SplashPage\nScope:checkIfDeviceSupportBiometric()\nCanAuthenticate: $canAuthenticate");
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      LogService.writeLog(
          message:
              "[i] SplashPage\nScope:checkIfDeviceSupportBiometric()\nAvailable Biometrics: $availableBiometrics");
      // LogService.writeOnConsole(message: "[i] SplashPage\nScope:checkIfDeviceSupportBiometric()\nAvailable Biometrics: $availableBiometrics");

      if (availableBiometrics.isNotEmpty) {
        AppStorage().storeValue(AppStorage.CAN_AUTHENTICATE, canAuthenticate);
      } else {
        AppStorage().remove(AppStorage.CAN_AUTHENTICATE);
      }
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
