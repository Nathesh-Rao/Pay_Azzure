import 'dart:convert';
import 'dart:math';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/CardModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/CardOptionModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/GridDashboardModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/ExecuteApi.dart';
import 'package:axpertflutter/Utils/ServerConnections/InternetConnectivity.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:material_icons_named/material_icons_named.dart';

import '../../../../Constants/Routes.dart';
import '../../../../Utils/LogServices/LogService.dart';
import '../../UpdatedHomePage/Models/UpdatedHomeCardDataModel.dart';
import '../../UpdatedHomePage/Widgets/WidgetMenuFolderPanelItem.dart';
import '../Models/MenuFolderModel.dart';

class MenuHomePageController extends GetxController {
  // final AttendanceController c = Get.put(AttendanceController());
  InternetConnectivity internetConnectivity = Get.find();
  var colorList = ["#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF"];

  // var colorList = ["#EEF2FF", "#FFF9E7", "#F5EBFF", "#FFECF6", "#E5F5FA", "#E6FAF4", "#F7F7F7", "#E8F5F8"];
  var listOfOptionCards = [].obs;
  var list_menuFolderData = {}.obs;
  var listOfshortcutCardItems = [].obs;
  var actionData = {};
  Set setOfDatasource = {};
  var map_dataSource = {};
  var switchPage = false.obs;
  var webUrl = "";
  var isShowPunchIn = false.obs;
  var isShowPunchOut = false.obs;
  var recordId = '';
  var punchInResp = '';
  var shift_start_time = "Loading..".obs;
  var shift_end_time = "Loading..".obs;
  var last_login_date = "Loading..".obs;
  var last_login_time = "Loading..".obs;
  var last_login_location = "Loading..".obs;
  var attendanceVisibility = false.obs;

  //Client Info
  var client_info_companyTitle = "".obs;
  var client_info_userNickname = "".obs;
  var client_info_logo_base64String = "".obs;

  var isLoading = true.obs;
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  var body, header;

  MenuHomePageController() {
    body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    getClientInfo();
    //---------------------->
    //NOTE Axpert 11.4-------->
    _getCardsWithData();
    //NOTE---------------------->
    //getCardDetails();
    getPunchINData();
    getShorcutMenuDashboardDetails();
    getAttendanceDetails();
  }

//------------------------------------------------------------------------------------->
  //NOTE Axpert 11.4 API calls and methods
  var bannerIndex = 0.obs;
  var bannerCardData = [].obs;

  var taskListData = [].obs;
  List<RxBool> taskListDataSwitches = [];
  var newsCardData = [].obs;
  List<RxBool> newsCardDataSwitches = [];
  var kpiListCardData = [].obs;
  List<RxBool> kpiListCardDataSwitches = [];
  var kpiSliderCardData = [].obs;
  var menuIconsData = [].obs;
  List<RxBool> menuIconsDataSwitches = [];
  var activityListData = [].obs;
  List<RxBool> activityListDataSwitches = [];

//---------------------------------
  pseudoCallGet() {
    _getCardsWithData();
  }

  pseudoCallClear() {
    _clearDataLists();
  }

  updateBannerIndex(int index) {
    bannerIndex.value = index;
  }

  _sortDataByPluginName({required List<UpdatedHomeCardDataModel> dataList}) {
    for (var data in dataList) {
      switch (data.pluginname?.toUpperCase()) {
        case "BANNER CARD":
          bannerCardData.add(data);

          break;
        case "TASK LIST":
          taskListData.add(data);
          break;
        case "NEWS CARD":
          newsCardData.add(data);
          break;
        case "KPI LIST":
          if (data.carddata is! String) {
            if (data.cardname?.toUpperCase() == "KPI LIST") {
              kpiSliderCardData.add(data);
            } else {
              kpiListCardData.add(data);
            }
          }
          break;
        case "MENU ICONS":
          menuIconsData.add(data);
          break;
        case "ACTIVITY LIST":
          activityListData.add(data);
          break;
        default:
      }
    }
    _initializeListSwitches();
  }

  _initializeListSwitches() {
    taskListDataSwitches = List.generate(taskListDataSwitches.length, (index) => false.obs);
    newsCardDataSwitches = List.generate(newsCardDataSwitches.length, (index) => false.obs);
    kpiListCardDataSwitches = List.generate(kpiListCardDataSwitches.length, (index) => false.obs);
    menuIconsDataSwitches = List.generate(menuIconsDataSwitches.length, (index) => false.obs);
    activityListDataSwitches = List.generate(activityListDataSwitches.length, (index) => false.obs);
  }

  _getCardsWithData() async {
    isLoading.value = true;
    LoadingScreen.show();
    LogService.writeLog(message: "_getCardsWithData: started");
    var url = Const.getFullARMUrl(ServerConnections.API_GET_CARDS_WITH_DATA);
    var getCardsBody = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "AxSessionId": "jbxqzz5tie2y3yujshe3k1x5",
      "Trace": "false",
      "AppName": appStorage.retrieveValue(AppStorage.PROJECT_NAME),
      "Roles": "default",
      "UserName": appStorage.retrieveValue(AppStorage.USER_NAME),
      "HomePageCards": true,
      "RefreshData": false,
      "GlobalParams": ServerConnections.SAMPLE_GET_CARDS_WITH_DATA_GLOBAL_PARAMS
    };
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(getCardsBody), isBearer: true);
    LogService.writeLog(message: "getcardswithdata : $resp");
    var response = jsonDecode(resp);
    // LogService.writeLog(message: "_getCardsWithData: resp:$response");
    List dataList = response["result"]["data"];
    // _clearDataLists();
    _UpdateDataLists(dataList);

    isLoading.value = false;
    LoadingScreen.dismiss();
    // _printDataCard();
  }

  _UpdateDataLists(List dataList) {
    _clearDataLists();
    List<UpdatedHomeCardDataModel> cardDataList = dataList.map((e) => UpdatedHomeCardDataModel.fromJson(e)).toList();

    for (var i in cardDataList) {
      if (i.carddata != null) {
        try {
          i.carddata = jsonDecode(i.carddata);
        } catch (e) {
          print(e);
        }
      }
    }

    _sortDataByPluginName(dataList: cardDataList);
  }

  _clearDataLists() {
    bannerCardData.clear();
    taskListData.clear();
    newsCardData.clear();
    kpiListCardData.clear();
    kpiSliderCardData.clear();
    menuIconsData.clear();
    activityListData.clear();
    //
    taskListDataSwitches.clear();
    newsCardDataSwitches.clear();
    kpiListCardDataSwitches.clear();
    menuIconsDataSwitches.clear();
    activityListDataSwitches.clear();
  }

  _printDataCard() {
    LogService.writeLog(message: "bannerCardData length => ${bannerCardData.length}");
    LogService.writeLog(message: "taskListData length => ${taskListData.length}");
    LogService.writeLog(message: "newsCardData length => ${newsCardData.length}");
    LogService.writeLog(message: "kpiListCardData length => ${kpiListCardData.length}");
    LogService.writeLog(message: "kpiListSliderCardData length => ${kpiSliderCardData.length}");
    LogService.writeLog(message: "menuIconsData length => ${menuIconsData.length}");
    LogService.writeLog(message: "activityListData length => ${activityListData.length}");
  }

//------------------------------------------------------------------------------------->
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
    var url = Const.getFullARMUrl(ServerConnections.API_GET_HOMEPAGE_CARDS_v2);
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    // print(resp);
    // LogService.writeLog(message: "[-] UpdatedHomePage => CardDetails > API_GET_HOMEPAGE_CARDS_v2 - body: $body ");
    // LogService.writeLog(message: "[-] UpdatedHomePage => CardDetails > API_GET_HOMEPAGE_CARDS_v2 - resp: $resp ");

    if (resp != "") {
      print("Home card ${resp}");
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString() == "true") {
        listOfOptionCards.clear();
        var dataList = jsonResp['result']['menu option'];
        for (var item in dataList) {
          CardModel cardModel = CardModel.fromJson(item);
          listOfOptionCards.add(cardModel);
          //setOfDatasource.add(item['datasource'].toString());
          if (cardModel.datasource != "") map_dataSource[cardModel.caption] = cardModel.datasource;
        }

        var menuFolderList = [];
        var data_menuFolder = jsonResp['result']['menu folder'];
        for (var item in data_menuFolder) {
          MenuFolderModel menuFolderModel = MenuFolderModel.fromJson(item);
          menuFolderList.add(menuFolderModel);
        }
        parseMenuFolderData(menuFolderList);
      } else {
        // LogService.writeLog(message: "[ERROR] UpdatedHomePage => CardDetails > API_GET_HOMEPAGE_CARDS_v2 - Response is empty ");
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
    // listOfCards..sort((a, b) => a.caption.toString().toLowerCase().compareTo(b.caption.toString().toLowerCase()));
    isLoading.value = false;
    LoadingScreen.dismiss();
    return listOfOptionCards;
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
      for (var cardDataSource in map_dataSource.entries) {
        if (cardDataSource.value != "") {
          dataSourceBody["datasource"] = cardDataSource.value;
          // setOfDatasource.remove(items);
          var dsResp = await serverConnections.postToServer(url: dataSourceUrl, isBearer: true, body: jsonEncode(dataSourceBody));
          // LogService.writeLog(
          //     message: "[-] UpdatedHomePage => getCardDataSources > API_GET_HOMEPAGE_CARDSDATASOURCE - Response : $dsResp ");

          if (dsResp != "") {
            var jsonDSResp = jsonDecode(dsResp);
            // print(jsonDSResp);
            if (jsonDSResp['result']['success'].toString() == "true") {
              var dsDataList = jsonDSResp['result']['data'];
              for (var item in dsDataList) {
                var list = [];
                list = actionData[cardDataSource.key] != null ? actionData[cardDataSource.key] : [];
                CardOptionModel cardOptionModel = CardOptionModel.fromJson(item);

                if (list.indexOf(cardOptionModel) < 0) list.add(cardOptionModel);
                actionData[cardDataSource.key] = list;
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
        print("URL : $webUrl");

        switchPage.toggle();
      } else {}
    }
  }

  String getCardBackgroundColor(String colorCode) {
    final _random = new Random();
    return !["", null, "null"].contains(colorCode) ? colorCode : colorList[_random.nextInt(colorList.length)];
  }

  getEncryptedSecretKey(String key) async {
    var url = Const.getFullARMUrl(ExecuteApi.API_GET_ENCRYPTED_SECRET_KEY);
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
    secretEncryptedKey = await getEncryptedSecretKey(ExecuteApi.API_SECRETKEY_GET_PUNCHIN_DATA);
    if (secretEncryptedKey != "") {
      var url = Const.getFullARMUrl(ExecuteApi.API_ARM_EXECUTE_PUBLISHED);
      var body = {
        // "SecretKey": secretEncryptedKey,
        "publickey": "AXPKEY000000010003",
        "username": appStorage.retrieveValue(AppStorage.USER_NAME),
        "Project": appStorage.retrieveValue(AppStorage.PROJECT_NAME),
        "getsqldata": {"username": appStorage.retrieveValue(AppStorage.USER_NAME), "trace": "false"},
        "sqlparams": {}
      };
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
      punchInResp = resp;
      print("ExecuteApi Resp: ${resp}");
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
        } else {
          isShowPunchIn.value = true;
        }
      }
    }
    LoadingScreen.dismiss();
  }

  onClick_PunchIn() async {
    print(punchInResp);
    LoadingScreen.show();
    var secretEncryptedKey = await getEncryptedSecretKey(ExecuteApi.API_SECRETKEY_GET_DO_PUNCHIN);
    Position? currentLocation = await CommonMethods.getCurrentLocation();
    var latitude = currentLocation?.latitude ?? "";
    var longitude = currentLocation?.longitude ?? "";
    String address = await CommonMethods.getAddressFromLatLng(
        currentLocation!); //currentLocation != null ? await CommonMethods.getAddressFromLatLng(currentLocation) : "";
    print("address: ${address.toString()}");
    var url = Const.getFullARMUrl(ExecuteApi.API_ARM_EXECUTE);
    var body = {
      // "SecretKey": secretEncryptedKey, //1408279244140740
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
      // var result = jsonResp['result'].toString();
      Get.snackbar("Punch-In success", "",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
      isShowPunchIn.value = false;
      isShowPunchOut.value = true;
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
    var secretEncryptedKey = await getEncryptedSecretKey(ExecuteApi.API_SECRETKEY_GET_DO_PUNCHOUT);
    Position? currentLocation = await CommonMethods.getCurrentLocation();
    var latitude = currentLocation?.latitude ?? "";
    var longitude = currentLocation?.longitude ?? "";
    String address = await CommonMethods.getAddressFromLatLng(
        currentLocation!); //currentLocation != null ? await CommonMethods.getAddressFromLatLng(currentLocation) : "";
    print("address: ${address.toString()}");

    var url = Const.getFullARMUrl(ExecuteApi.API_ARM_EXECUTE);
    var body = {
      // "SecretKey": secretEncryptedKey, //1408279244140740
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

  void getShorcutMenuDashboardDetails() async {
    var body = {
      // "SecretKey": await getEncryptedSecretKey(ExecuteApi.API_PrivateKey_DashBoard),
      "publickey": ExecuteApi.API_PUBLICKEY_DASHBOARD,
      "Project": Const.PROJECT_NAME,
      "getsqldata": {"trace": "false"}
    };
    var resp = await ExecuteApi().CallFetchData_ExecuteAPI(body: jsonEncode(body));
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp["success"].toString() == "true") {
        var listItems = jsonResp["axm_dashboard_shortcutmenu"]["rows"];
        listOfshortcutCardItems.clear();
        for (var items in listItems) {
          ShortcutMenuDashboardModel newModel = ShortcutMenuDashboardModel.fromJson(items);
          listOfshortcutCardItems.add(newModel);
        }
      }
    }
  }

  captionOnTapFunction(transid) {
    String link_id = transid;
    // String link_id = transid.replaceAll('(', '').replaceAll(')', '');

    LogService.writeLog(message: "captionOnTapFunction: transid => $link_id");
    var validity = false;
    if (link_id.toLowerCase().startsWith('h')) {
      if (link_id.toLowerCase().contains("hp")) {
        link_id = link_id.toLowerCase().replaceAll("hp", "h");
      }
      validity = true;
    } else {
      if (link_id.toLowerCase().startsWith('i')) {
        validity = true;
      } else {
        if (link_id.toLowerCase().startsWith('t')) {
          validity = true;
        } else
          validity = false;
      }
    }
    if (validity) {
      // LogService.writeLog(message: "[i] FolderPanel : Open in webview {$link_id}");

      openBtnAction("button", link_id);
    }
  }

  captionOnTapFunctionNew(transid) async {
    if (transid != null) {
      String link_id = getStringForWebViewParam(transid); //transid.replaceAll('(', '').replaceAll(')', '');

      LogService.writeLog(message: "captionOnTapFunction: transid => $link_id");
      var validity = false;
      if (link_id.toLowerCase().startsWith('h')) {
        if (link_id.toLowerCase().contains("hp")) {
          link_id = link_id.toLowerCase().replaceAll("hp", "h");
        }
        validity = true;
      } else {
        if (link_id.toLowerCase().startsWith('i') || link_id.toLowerCase().startsWith('l')) {
          validity = true;
        } else {
          if (link_id.toLowerCase().startsWith('t')) {
            validity = true;
          } else
            validity = false;
        }
      }
      if (validity) {
        // LogService.writeLog(message: "[i] FolderPanel : Open in webview {$link_id}");

        if (await internetConnectivity.connectionStatus) {
          webUrl = Const.getFullProjectUrl("aspx/AxMain.aspx?authKey=AXPERT-") +
              appStorage.retrieveValue(AppStorage.SESSIONID) +
              "&pname=" +
              link_id;
          print("Web_URL_card: $webUrl");
          // LogService.writeLog(message: "Web url => $webUrl");
          Get.toNamed(Routes.InApplicationWebViewer, arguments: [webUrl]);
        }
      }
    } /*else {
      Get.snackbar("Invalid Link", "The Link attached is invalid or empty",
          margin: EdgeInsets.all(10),
          backgroundColor: MyColors.blue9,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
    }*/
  }

  String getStringForWebViewParam(String input) {
    if (input.contains('(')) {
      final match = RegExp(r'(\w+)\((.*?)\)').firstMatch(input);
      if (match != null) {
        String base = match.group(1) ?? '';
        String params = match.group(2) ?? '';

        return params.isNotEmpty ? '$base&params=^$params' : base;
      }
    }
    return input;
  }

  generateIcon(model) {
    var iconName = model.icon;
    if (iconName.contains("material-icons")) {
      iconName = iconName.replaceAll("|material-icons", "");
      return materialIcons[iconName];
    } else {
      switch (model.type.trim().toUpperCase()[0]) {
        case "T":
          return Icons.assignment;
        case "I":
          return Icons.view_list;
        case "W":
        case "H":
          return Icons.code;
        default:
          return Icons.access_time;
      }
    }
  }

  void getAttendanceDetails() async {
    var body = {
      "SecretKey": await getEncryptedSecretKey(ExecuteApi.API_PRIVATEKEY_ATTENDANCE),
      "publickey": ExecuteApi.API_PUBLICKEY_ATTENDANCE,
      "Project": Const.PROJECT_NAME, //"agilepost113",
      "getsqldata": {"trace": "false"}
    };
    var resp = await ExecuteApi().CallFetchData_ExecuteAPI(body: jsonEncode(body));
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['success'].toString() == "true") {
        attendanceVisibility.value = true;
        shift_start_time.value = jsonResp['axm_shift_time']['rows'][0]["shift_start_time"].toString();
        shift_end_time.value = jsonResp['axm_shift_time']['rows'][0]["shift_end_time"].toString();
        last_login_date.value = jsonResp['axm_logindetails']['rows'][0]["last_login_date"].toString();
        last_login_time.value = jsonResp['axm_logindetails']['rows'][0]["last_login_time"].toString();
        last_login_location.value = jsonResp['axm_logindetails']['rows'][0]["last_login_location"].toString();
      } else {
        attendanceVisibility.value = false;
      }
    }
  }

  getClientInfo() async {
    var cl_recId = "";
    var cl_imagePath = "";
    // var dataSourceUrl = baseUrl + GlobalConfiguration().get("HomeCardDataResponse").toString();
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_GET_HOMEPAGE_CARDSDATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "username": appStorage.retrieveValue(AppStorage.USER_NAME),
      "appname": Const.PROJECT_NAME, //"agilepost113",
      "datasource": "Company_Logo",
      "sqlParams": {"username": appStorage.retrieveValue(AppStorage.USER_NAME)}
    };

    var dsResp = await serverConnections.postToServer(url: dataSourceUrl, isBearer: true, body: jsonEncode(body));
    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        for (var item in dsDataList) {
          try {
            cl_recId = item['recordid'].toInt().toString() ?? "";
            client_info_companyTitle.value = item['company_title'] ?? "";
            client_info_userNickname.value = item['user_nickname'] ?? "";
            cl_imagePath = item['imagepath'] ?? "";
          } catch (e) {
            print(e);
          }
        }
      }
    }
    if (!cl_recId.isEmpty && !cl_imagePath.isEmpty) getImageFlieByRecordId(cl_recId, cl_imagePath);
  }

  getImageFlieByRecordId(recID, filePath) async {
    var url = Const.getFullARMUrl(ServerConnections.API_GET_FILE_BY_RECORDID);
    var body = {
      // "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "RecordId": recID,
      "FilePath": filePath
    };

    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body));
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['success'].toString() == "true") {
        client_info_logo_base64String.value = jsonResp['base64'] ?? "";
      }
    }
  }

  void parseMenuFolderData(List menuFolderList) {
    var map_folderList = {};
    for (var item in menuFolderList) {
      var folderName = item.groupfolder;
      List<MenuFolderModel> list = [];
      list = map_folderList[folderName] ?? [];
      list.add(item);
      map_folderList[folderName] = list;
    }
    list_menuFolderData.value = map_folderList;
    print("list_menuFolderData: ${list_menuFolderData.toString()}");
    LogService.writeLog(
        message:
            "[i] MenuHomePageController\nScope: parseMenuFolderData()\nlist_menuFolderData: ${list_menuFolderData.toString()}");
  }

  getMenuFolderPanelWidgetList() {
    var panelModel = list_menuFolderData;
    var keys = panelModel.keys.toList();
    List<Widget> panelWidgets = List.generate(
        keys.length,
        (index) => WidgetMenuFolderPanelItem(
              keyname: keys[index],
              panelItems: panelModel[keys[index]]!,
            ));

    return panelWidgets;
  }
}
