import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Utils/LogServices/LogService.dart';

class RequestLocationPage extends StatefulWidget {
  const RequestLocationPage({super.key});

  @override
  State<RequestLocationPage> createState() => _RequestLocationPageState();
}

class _RequestLocationPageState extends State<RequestLocationPage> with WidgetsBindingObserver {
  var isPermissionPDenied = false;

  @override
  void initState() {
    LogService.writeLog(message: "[>] RequestLocationPage");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && isPermissionPDenied) {
      var permission = await Geolocator.checkPermission();
      LogService.writeLog(message: "onResume => permission: $permission");

      if (permission == LocationPermission.always) {
        setState(() {
          isPermissionPDenied = false;
        });
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "This application needs Full location access so that we can"
                    " always track you where ever you go between the office hours.\n\n"
                    "Please allow location permission as \nAll The Time",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Image.asset(
                  "assets/images/circular_location.jpeg",
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isPermissionPDenied ? openSettingWidget() : permissionAllowWidget()
            ],
          ),
        ),
      )),
    );
  }

  permissionAllowWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          _locationPermission();
                        },
                        child: Text("Allow"))))
          ]),
          SizedBox(
            height: 20,
          ),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.grey.shade300,
                        )),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Not Now")))),
          ]),
        ],
      );
  openSettingWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "1. Tap Go to Settings in the prompt.In the App Info screen,\n2. select App(Axpert Flutter).\n3. Choose 'Allow all the time'.\n4. Press the back button to return to the app.",
            style: GoogleFonts.poppins(),
          ),
          SizedBox(
            height: 20,
          ),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          _openAppSettings();
                        },
                        child: Text("Go to Settings"))))
          ]),
        ],
      );
  _openAppSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  _locationPermission() async {
    // await Geolocator.requestPermission();

    if (Platform.isAndroid) {
      var permission = await Permission.locationAlways.request();

      LogService.writeLog(message: "[i] SplashPage \nScope: askLocationPermission() : $permission ");

      if (permission != PermissionStatus.granted) {
        LogService.writeLog(message: " _locationPermission()=> PermissionStatus => 2 $permission");
        setState(() {
          isPermissionPDenied = true;
        });
      } else {
        LogService.writeLog(message: " _locationPermission()=> PermissionStatus => 1 $permission");
        setState(() {
          isPermissionPDenied = false;
        });
        Get.back();
      }
    }

    var permission = await Geolocator.checkPermission();

    if (Platform.isIOS) {
      if (permission == LocationPermission.whileInUse) {
        LogService.writeLog(message: "[i] [IOS] RequestLocationPage\nScope: _locationPermission(): true");
        Navigator.of(context).pop();
      }
    }
    if (permission == LocationPermission.always) {
      LogService.writeLog(message: "[i] RequestLocationPage\nScope: _locationPermission(): true");
      LogService.writeLog(message: " _locationPermission()=> PermissionStatus => 3 $permission");
      Navigator.of(context).pop();
    }
  }
}
