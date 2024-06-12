import 'dart:convert';
import 'dart:math';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/CardModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/CardOptionModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/InternetConnectivity.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MenuHomePageController extends GetxController {
  InternetConnectivity internetConnectivity = Get.find();
  // var colorList = ["#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF"];
  var colorList = ["#EEF2FF", "#FFF9E7", "#F5EBFF", "#FFECF6", "#E5F5FA", "#E6FAF4", "#F7F7F7", "#E8F5F8"];
  var listOfCards = [].obs;
  var actionData = {};
  Set setOfDatasource = {};
  var switchPage = false.obs;
  var webUrl = "";
  var isShowPunchIn = false.obs;
  var isShowPunchOut = false.obs;
  var recordId = '';

  var isLoading = true.obs;
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  var body, header;

  MenuHomePageController() {
    body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    getCardDetails();
  }

  showMenuDialog(CardModel cardModel) {
    Get.dialog(Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
              child: Center(
                child: Text(
                  cardModel.caption,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  getCardDetails() async {
    isLoading.value = true;
    LoadingScreen.show();
    var url = Const.getFullARMUrl(ServerConnections.API_GET_HOMEPAGE_CARDS);
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    // print(resp);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString() == "true") {
        listOfCards.clear();
        var dataList = jsonResp['result']['data'];
        for (var item in dataList) {
          CardModel cardModel = CardModel.fromJson(item);
          listOfCards.add(cardModel);
          setOfDatasource.add(item['datasource'].toString());
        }
      } else {
        //error
      }
    }
    // if (listOfCards.length == 0) {
    //   print("Length:   0");
    //   Get.defaultDialog(
    //       title: "Alert!",
    //       middleText: "Session Timed Out",
    //       confirm: ElevatedButton(
    //           onPressed: () {
    //             Get.back();
    //           },
    //           child: Text("Ok")));
    // }
    await getCardDataSources();
    listOfCards..sort((a, b) => a.caption.toString().toLowerCase().compareTo(b.caption.toString().toLowerCase()));
    isLoading.value = false;
    LoadingScreen.dismiss();
    return listOfCards;
  }

  getCardDataSources() async {
    if (actionData.length > 1) {
      return actionData;
    } else {
      // var dataSourceUrl = baseUrl + GlobalConfiguration().get("HomeCardDataResponse").toString();
      var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_GET_HOMEPAGE_CARDSDATASOURCE);
      var dataSourceBody = body;
      dataSourceBody["sqlParams"] = {"param": "value", "username": appStorage.retrieveValue(AppStorage.USER_NAME)};

      actionData.clear();
      for (var items in setOfDatasource) {
        if (items.toString() != "") {
          dataSourceBody["datasource"] = items;
          // setOfDatasource.remove(items);
          var dsResp = await serverConnections.postToServer(url: dataSourceUrl, isBearer: true, body: jsonEncode(dataSourceBody));
          if (dsResp != "") {
            var jsonDSResp = jsonDecode(dsResp);
            // print(jsonDSResp);
            if (jsonDSResp['result']['success'].toString() == "true") {
              var dsDataList = jsonDSResp['result']['data'];
              for (var item in dsDataList) {
                var list = [];
                list = actionData[item['cardname']] != null ? actionData[item['cardname']] : [];
                CardOptionModel cardOptionModel = CardOptionModel.fromJson(item);

                if (list.indexOf(cardOptionModel) < 0) list.add(cardOptionModel);
                actionData[item['cardname']] = list;
              }
            }
          }
        }
      }
    }
  }

  void openBtnAction(String btnType, String btnOpen) async {
    if (await internetConnectivity.connectionStatus) {
      print("hit $btnType");
      print("pname: $btnOpen");
      if (btnType.toLowerCase() == "button" && btnOpen != "") {
        webUrl = Const.getFullProjectUrl("aspx/AxMain.aspx?authKey=AXPERT-") +
            appStorage.retrieveValue(AppStorage.SESSIONID) +
            "&pname=" +
            btnOpen;
        switchPage.toggle();
      } else {}
    }
  }

  String getCardBackgroundColor(String colorCode) {
    final _random = new Random();
    return !["", null, "null"].contains(colorCode) ? colorCode : colorList[_random.nextInt(colorList.length)];
  }

  getEncryptedSecretKey(String key) async {
    var url = Const.getFullARMUrl(ServerConnections.API_GET_ENCRYPTED_SECRET_KEY);
    Map<String, dynamic> body = {"secretkey": key};
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    print("Resp: $resp");
    if (resp != "" && !resp.toString().contains("error")) {
      return resp;
    }
  }

  getPunchINData() async {
    var secretEncryptedKey = '';
    LoadingScreen.show();
    secretEncryptedKey = await getEncryptedSecretKey(ServerConnections.API_SECRETKEY_GET_PUNCHIN_DATA);
    if (secretEncryptedKey != "") {
      var url = Const.getFullARMUrl(ServerConnections.API_ARM_EXECUTE);
      var body = {
        "SecretKey": secretEncryptedKey,
        "publickey": "AXPKEY000000010003",
        "username": appStorage.retrieveValue(AppStorage.USER_NAME),
        "Project": "hcmuat", //Const.PROJECT_NAME,
        "getsqldata": {"username": appStorage.retrieveValue(AppStorage.USER_NAME), "trace": "false"},
        "sqlparams": {}
      };
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
      print(resp);
      if (resp != "" && !resp.toString().contains("error")) {
        var jsonResp = jsonDecode(resp);
        if (jsonResp['success'].toString() == "true") {
          var rows = jsonResp['punchin_out_status']['rows'];
          if (rows.length == 0) {
            isShowPunchIn.value = true;
            isShowPunchOut.value = false;
          } else {
            var firstRowVal = rows[0];
            isShowPunchIn.value = false;
            isShowPunchOut.value = true;
            recordId = firstRowVal['recordid'] ?? '';
          }
        }
      }
    }
    LoadingScreen.dismiss();
  }

  onClick_PunchIn() async {
    LoadingScreen.show();
    var secretEncryptedKey = await getEncryptedSecretKey(ServerConnections.API_SECRETKEY_GET_DO_PUNCHIN);
    Position? currentLocation = await CommonMethods.getCurrentLocation();
    var latitude = currentLocation?.latitude ?? "";
    var longitude = currentLocation?.longitude ?? "";
    String address = await CommonMethods.getAddressFromLatLng(
        currentLocation!); //currentLocation != null ? await CommonMethods.getAddressFromLatLng(currentLocation) : "";
    print("address: ${address.toString()}");
    var url = Const.getFullARMUrl(ServerConnections.API_ARM_EXECUTE);
    var body = {
      "SecretKey": secretEncryptedKey, //1408279244140740
      "publickey": "AXPKEY000000010002",
      "project": appStorage.retrieveValue(AppStorage.PROJECT_NAME),
      "submitdata": {
        "username": appStorage.retrieveValue(AppStorage.USER_NAME),
        "trace": "false",
        "dataarray": {
          "data": {
            "mode": "new",
            "recordid": "0",
            "dc1": {
              "row1": {"latitude": latitude, "longitude": longitude, "status": "IN", "inloc": address}
            }
          }
        }
      }
    };
    // print("punch_IN_Body: ${jsonEncode(body)}");
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);

    //print("PunchIN_resp: $resp");
    print(resp);
    var jsonResp = jsonDecode(resp);
    LoadingScreen.dismiss();

    if (jsonResp['success'].toString() == "true") {
      Get.back();
      // var result = jsonResp['result'].toString();
      Get.snackbar("Punch-In success", "",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
      actionData.clear();
      await getCardDataSources();
    } else {
      // var errMessage = jsonResp['message'].toString();
      Get.snackbar("Error", jsonResp['message'].toString(),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
    }
  }

  onClick_PunchOut() async {
    LoadingScreen.show();
    var secretEncryptedKey = await getEncryptedSecretKey(ServerConnections.API_SECRETKEY_GET_DO_PUNCHOUT);
    Position? currentLocation = await CommonMethods.getCurrentLocation();
    var latitude = currentLocation?.latitude ?? "";
    var longitude = currentLocation?.longitude ?? "";
    String address = await CommonMethods.getAddressFromLatLng(
        currentLocation!); //currentLocation != null ? await CommonMethods.getAddressFromLatLng(currentLocation) : "";
    print("address: ${address.toString()}");

    var url = Const.getFullARMUrl(ServerConnections.API_ARM_EXECUTE);
    var body = {
      "SecretKey": secretEncryptedKey, //1408279244140740
      "publickey": "AXPKEY000000010002",
      "project": appStorage.retrieveValue(AppStorage.PROJECT_NAME),
      "submitdata": {
        "username": appStorage.retrieveValue(AppStorage.USER_NAME),
        "trace": "false",
        "dataarray": {
          "data": {
            "mode": "edit",
            "recordid": recordId,
            "dc1": {
              "row1": {"olatitude": latitude, "olongitude": longitude, "status": "OUT", "outloc": address}
            }
          }
        }
      }
    };
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);

    print(resp);
    var jsonResp = jsonDecode(resp);

    if (jsonResp['success'].toString() == "true") {
      Get.back();
      // var result = jsonResp['result'].toString();
      Get.snackbar("Punch-Out success", "",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
      actionData.clear();
      await getCardDataSources();
    } else {
      // var errMessage = jsonResp['message'].toString();
      Get.snackbar("Error", jsonResp['message'].toString(),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
    }
    LoadingScreen.dismiss();
  }
}
