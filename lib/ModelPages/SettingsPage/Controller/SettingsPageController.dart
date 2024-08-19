import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPageController extends GetxController {
  var notificationOnOffValue = false.obs;
  var logOnOffValue = false.obs;
  AppStorage appStorage = AppStorage();

  SettingsPageController() {
    getNotifyStatusDetails();
    getLogStatusDetails();
  }
  getNotifyStatusDetails() async {
    notificationOnOffValue.value = await appStorage.retrieveValue(AppStorage.isShowNotifyEnabled);
  }

  void getLogStatusDetails() async {
    logOnOffValue.value = await appStorage.retrieveValue(AppStorage.isLogEnabled);
  }

  setNotifyValue(value) async {
    notificationOnOffValue.value = value;
    await appStorage.storeValue(AppStorage.isShowNotifyEnabled, value);
  }

  setLogValue(value) async {
    logOnOffValue.value = value;
    await appStorage.storeValue(AppStorage.isLogEnabled, value);
  }

  onChangeNotifyStatus() async {
    notificationOnOffValue.toggle();
    await setNotifyValue(notificationOnOffValue.value);
  }

  void onChangeLogStatus() async {
    if (logOnOffValue.isFalse) {
      await Get.defaultDialog(
          barrierDismissible: false,
          title: "Confirm",
          middleText: "Do you want to delete the previous logs?",
          confirm: ElevatedButton(
              onPressed: () async {
                await LogService.clearLog();
                Get.back();
              },
              child: Text("Yes")),
          cancel: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("No")));
    }
    logOnOffValue.toggle();
    await setLogValue(logOnOffValue.value);
  }
}
