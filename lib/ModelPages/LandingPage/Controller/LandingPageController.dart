import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/WebViewCalendar.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/MenuActiveListPage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Page/MenuDashboardPage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Page/MenuHomePage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Controllers/MenuMorePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Models/MenuItemModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Page/MenuMorePage.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Models/FirebaseMessageModel.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNotification.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetShakeableDialog.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';

class LandingPageController extends GetxController with WidgetsBindingObserver {
  TextEditingController userCtrl = TextEditingController();
  TextEditingController oPassCtrl = TextEditingController();
  TextEditingController nPassCtrl = TextEditingController();
  TextEditingController cnPassCtrl = TextEditingController();
  var errOPass = ''.obs;
  var errNPass = ''.obs;
  var errCNPass = ''.obs;
  var showOldPass = false.obs;
  var showNewPass = false.obs;
  var showConNewPass = false.obs;
  var userName = 'Demo'.obs; //update with user name
  var bottomIndex = 0.obs;
  var carouselIndex = 0.obs;
  var needRefreshNotification = false.obs;
  var notificationPageRefresh = false.obs;
  var showBadge = false.obs;
  var badgeCount = 0.obs;
  var fool = false.obs;
  var willAuth = false;
  var isAuthRequired = false;
  var unread;
  final CarouselController carouselController = CarouselController();

  DateTime currentBackPressTime = DateTime.now();

  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  var pageList = [
    MenuHomePage(),
    // WebViewActiveList(),
    MenuActiveListPage(),
    MenuDashboardPage(),
    // MenuCalendarPage(),
    WebViewCalendar(),
    MenuMorePage(),
  ];
  var list = [WidgetNotification(FirebaseMessageModel("Title 1", "Body 1"))];

  get getPage => pageList[bottomIndex.value];

  LandingPageController() {
    userName.value = appStorage.retrieveValue(AppStorage.USER_NAME) ?? userName.value;
    userCtrl.text = userName.value;
    getBiometricStatus();
  }

  getBiometricStatus() async {
    var willAuthLocal = await getWillBiometricAuthenticateForThisUser(userName.value);
    if (willAuthLocal == null) {
      Get.bottomSheet(
        PopScope(
          canPop: false,
          child: Container(
            margin: EdgeInsets.only(top: 150),
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(30)), color: Colors.grey.shade100),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 80,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(30)),
                ),
                Container(
                  height: 250,
                  child: Center(
                    child: Icon(
                      Icons.fingerprint_outlined,
                      color: MyColors.blue2,
                      size: 80,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Biometric Authentication in now Available!",
                  style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(height: 20),
                Text(
                  "Log in to your Buzzily account using your phone's biometric credentials.",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey.shade600)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    var willAuthenticate = await showBiometricDialog();
                    Get.back();
                    await setWillBiometricAuthenticateForThisUser(userName.value, willAuthenticate);
                    willAuth = willAuthenticate;
                  },
                  child: Container(
                    width: 300,
                    child: Center(child: Text("Enable biometric login")),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Get.back();
                      setWillBiometricAuthenticateForThisUser(userName.value, false);
                      willAuth = false;
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade300)),
                    child: Container(
                      width: 300,
                      child: Center(child: Text("Skip for now")),
                    )),
              ],
            ),
          ),
        ),
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.black.withOpacity(0.2),
        enterBottomSheetDuration: Duration(milliseconds: 500),
      );
      LoadingScreen.dismiss();
      // Get.defaultDialog(
      //     titlePadding: EdgeInsets.only(top: 20),
      //     contentPadding: EdgeInsets.all(20),
      //     title: "Biometric Available!",
      //     middleText: "Do you want to add fingerprint for login?",
      //     barrierDismissible: false,
      //     confirm: ElevatedButton(
      //         onPressed: () async {
      //           Get.back();
      //           var willAuthenticate = await showBiometricDialog();
      // setWillBiometricAuthenticateForThisUser(userName.value, willAuthenticate);
      // },
      // child: Text("Yes")),
      // cancel: TextButton(
      //     onPressed: () {
      // setWillBiometricAuthenticateForThisUser(userName.value, false);
      // Get.back();
      // },
      // child: Text("No")));
    } else
      willAuth = willAuthLocal;
  }

  indexChange(value) {
    MenuHomePageController menuHomePageController = Get.find();
    menuHomePageController.switchPage.value = false;
    bottomIndex.value = value;
  }

  showNotificationIconPressed() {}

  Future<bool> onWillPop() {
    try {
      MenuHomePageController menuHomePageController = Get.find();
      if (menuHomePageController.switchPage.value == true) {
        menuHomePageController.switchPage.toggle();
        return Future.value(false);
      }
    } catch (e) {}
    DateTime now = DateTime.now();
    if (bottomIndex.value != 0) {
      bottomIndex.value = 0;
      return Future.value(false);
    }
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.rawSnackbar(
          // message: "Press back again to exit",
          messageText: Center(
            child: Text(
              "Press back again to exit",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          margin: EdgeInsets.only(left: 10, right: 10),
          borderRadius: 10,
          backgroundColor: Colors.red,
          isDismissible: true,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM);
      return Future.value(false);
    } else {
      if (Get.isSnackbarOpen) Get.back();
      return Future.value(true);
    }
  }

  void showNotifications() {
    if (showBadge.value)
      unread = badgeCount.value;
    else
      unread = 0;

    showBadge.value = false;

    Map oldNotifyNum = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    var projectName = appStorage.retrieveValue(AppStorage.PROJECT_NAME) ?? "";
    Map projectWiseNum = oldNotifyNum[projectName] ?? {};
    var notNo = projectWiseNum[userName.value] ?? "0";
    notNo = "0";
    projectWiseNum[userName.value] = notNo;
    oldNotifyNum[projectName] = projectWiseNum;
    appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, oldNotifyNum);

    if (getNotificationList())
      Get.dialog(Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: 20, top: 50),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        "Messages",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.red,
                            size: 30,
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (context, index) {
                      return Container(height: 1, color: Colors.grey.shade300);
                    },
                    itemBuilder: (context, index) {
                      return list[index];
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 60,
                width: double.maxFinite,
                decoration: BoxDecoration(border: Border(top: BorderSide(width: 1))),
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(Routes.NotificationPage, arguments: [unread]);
                        },
                        child: Text("View All"),
                      )),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ));
    else
      Get.defaultDialog(
          title: "Alert!",
          middleText: "No new Notifications",
          confirm: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Ok")));
  }

  signOut() async {
    var body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var url = Const.getFullARMUrl(ServerConnections.API_SIGNOUT);
    Get.defaultDialog(
        title: "Log out",
        middleText: "Are you sure you want to log out?",
        confirm: ElevatedButton(
            onPressed: () async {
              Get.back();
              LoadingScreen.show();
              try {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                clearCacheData();
              } catch (e) {}
              appStorage.storeValue(AppStorage.USER_NAME, "");
              await serverConnections.postToServer(url: url, body: jsonEncode(body));
              LoadingScreen.dismiss();
              Get.offAllNamed(Routes.Login);
              // if (resp != "" && !resp.toString().contains("error")) {
              //   var jsonResp = jsonDecode(resp);
              //   if (jsonResp['result']['success'].toString() == "true") {
              //     appStorage.remove(AppStorage.SESSIONID);
              //     appStorage.remove(AppStorage.TOKEN);
              //
              //   } else {
              //     error(jsonResp['result']['message'].toString());
              //   }
              // } else {
              //   error("Some error occurred");
              // }
            },
            child: Text("Yes")),
        cancel: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
            onPressed: () {
              Get.back();
            },
            child: Text("No")));
  }

  clearCacheData() async {
    var tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  void changePasswordCalled() async {
    //change Password
    if (validForm()) {
      FocusManager.instance.primaryFocus!.unfocus();
      var passBody = {
        "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
        "CurrentPassword": oPassCtrl.text.trim(),
        "UpdatedPassword": nPassCtrl.text.trim(),
      };
      var url = Const.getFullARMUrl(ServerConnections.API_CHANGE_PASSWORD);
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(passBody), isBearer: true);
      if (resp.toString() != "") {
        var jsonResp = jsonDecode(resp);
        if (jsonResp['result']['success'].toString() == 'false') {
          error(jsonResp['result']['message'].toString());
        } else {
          Get.defaultDialog(
              title: "Success!",
              middleText: jsonResp['result']['message'].toString(),
              confirm: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text("Ok")));
        }
      }
      print(resp);
    }
    // if success
    // closeProfileDialog();
  }

  error(var msg) {
    Get.snackbar("Error!", msg, snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.red);
  }

  void closeProfileDialog() {
    cnPassCtrl.text = "";
    oPassCtrl.text = "";
    nPassCtrl.text = "";
    errOPass.value = errNPass.value = errCNPass.value = '';
    Get.back();
  }

  getBackValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var backList = (prefs.getStringList(AppStorage.SHAREDPREF_NAME) ?? []).toList();
    print('back pref list length:  ${backList.length}');
    await prefs.remove(AppStorage.SHAREDPREF_NAME);
    return backList;
  }

  // deleteBackValue(String msg) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.reload();
  //   var backList = (prefs.getStringList(AppStorage.SHAREDPREF_NAME) ?? []).toList();
  //   backList.removeWhere((element) => element == msg);
  //   await prefs.setStringList(AppStorage.SHAREDPREF_NAME, backList);
  // }

  doTheMergeProcess() async {
    var projectName = await AppStorage().retrieveValue(AppStorage.PROJECT_NAME) ?? "";
    var userName = await AppStorage().retrieveValue(AppStorage.USER_NAME) ?? "";
    Map oldMessages = await AppStorage().retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map projectWiseMessages = oldMessages[projectName] ?? {};
    List notList = projectWiseMessages[userName] ?? [];

    // Map oldNotifyNum = AppStorage().retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    // Map projectWiseNum = oldNotifyNum[projectName] ?? {};
    // var notNo = projectWiseNum[userName] ?? "0";

    // var backList = await getBackValue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var backList = await (prefs.getStringList(AppStorage.SHAREDPREF_NAME) ?? []).toList();
    print('back pref list length:  ${backList.length}');
    await prefs.remove(AppStorage.SHAREDPREF_NAME);
    await prefs.reload();
    var count = 0;
    for (var item in backList) {
      try {
        var jsonItem = jsonDecode(item);
        if (jsonItem['notify_to'].toString().contains(userName)) {
          var jsonProjDetails = jsonDecode(jsonItem['project_details']);
          if (jsonProjDetails['projectname'] == projectName) {
            //add
            notList.removeWhere((element) => element == item);
            notList.insert(0, item);
            count++;
            // deleteBackValue(item);
          }
        }

        // Map oldMessages = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
        // Map projectWiseMessages = oldMessages[notiProjectName] ?? {};
        // var userWiseMessages = projectWiseMessages[userName] ?? [];
        // var messageList = [];
        // messageList.add(jsonEncode(message.data));
        // if (!userWiseMessages.isEmpty) messageList.addAll(userWiseMessages);
        // projectWiseMessages[userName] = messageList;
        // oldMessages[notiProjectName] = projectWiseMessages;
        // appStorage.remove(AppStorage.NOTIFICATION_LIST);
        // appStorage.storeValue(AppStorage.NOTIFICATION_LIST, oldMessages);
      } catch (e) {}
    }
    if (count > 0) {
      projectWiseMessages[userName] = notList;
      oldMessages[projectName] = projectWiseMessages;
      await AppStorage().storeValue(AppStorage.NOTIFICATION_LIST, oldMessages);

      Map oldNotifyNum = await AppStorage().retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
      Map projectWiseNum = oldNotifyNum[projectName] ?? {};
      var notNo = projectWiseNum[userName] ?? "0";
      notNo = (int.parse(notNo) + count).toString();
      projectWiseNum[userName] = notNo;
      oldNotifyNum[projectName] = projectWiseNum;
      await AppStorage().storeValue(AppStorage.NOTIFICATION_UNREAD, oldNotifyNum);
    }
  }

  getNotificationList() {
    list.clear();
    //get Noti List
    //doTheMergeProcess();

    var projectName = AppStorage().retrieveValue(AppStorage.PROJECT_NAME) ?? "";
    var userName = AppStorage().retrieveValue(AppStorage.USER_NAME) ?? "";

    Map oldMessages = AppStorage().retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map projectWiseMessages = oldMessages[projectName] ?? {};
    List notList = projectWiseMessages[userName] ?? [];
    //get Noti Count
    Map oldNotifyNum = AppStorage().retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    Map projectWiseNum = oldNotifyNum[projectName] ?? {};
    var notNo = projectWiseNum[userName] ?? "0";
    if (notNo != "0") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        badgeCount.value = int.parse(notNo);
        showBadge.value = true;
      });
    }

    if (notList.isEmpty) return false;
    for (var item in notList) {
      try {
        var val = jsonDecode(item);
        var notify_to = val["notify_to"].toString().toLowerCase();
        var projectDet = jsonDecode(val['project_details']);
        // print("notiiii: " + projectDet["projectname"].toString());
        if (projectDet["projectname"].toString() == appStorage.retrieveValue(AppStorage.PROJECT_NAME).toString() &&
            notify_to.contains(userName.toString().toLowerCase()))
          list.add(WidgetNotification(FirebaseMessageModel.fromJson(val)));
      } catch (e) {
        print(e.toString());
      }
    }
    if (list.isEmpty) return false;
    return true;
  }

  Future<bool> deleteNotification(int index) async {
    var value;
    await Get.defaultDialog(
        title: "Delete?",
        middleText: "Do you want to delete this notification?",
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            value = true;
            _deleteNotificationFromStorage(index);
          },
          child: Text("Yes"),
        ),
        cancel: TextButton(
            onPressed: () {
              Get.back();
              value = false;
            },
            child: Text("No")),
        barrierDismissible: false);
    return value;
  }

  _deleteNotificationFromStorage(int index) async {
    Map oldMessages = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    var projectName = appStorage.retrieveValue(AppStorage.PROJECT_NAME) ?? "";
    Map projectWiseMessages = oldMessages[projectName] ?? {};
    var userName = appStorage.retrieveValue(AppStorage.USER_NAME) ?? "";
    List notiList = projectWiseMessages[userName] ?? [];

    notiList.removeAt(index);
    projectWiseMessages[userName] = notiList;
    oldMessages[projectName] = projectWiseMessages;

    await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, oldMessages);
    needRefreshNotification.value = true;
    notificationPageRefresh.value = true;
  }

  evaluteError(String value) {
    if (value.trim() == '')
      return null;
    else
      return value;
  }

  bool validForm() {
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$';
    RegExp regex = RegExp(pattern.toString());
    errOPass.value = errNPass.value = errCNPass.value = '';
    if (oPassCtrl.text.trim().toString() == '') {
      errOPass.value = "Enter old password";
      return false;
    }
    if (!regex.hasMatch(oPassCtrl.text.trim())) {
      errOPass.value = "Password should contain upper,lower,digit and Special character";
      return false;
    }
    if (nPassCtrl.text.trim().toString() == '') {
      errNPass.value = "Enter New password";
      return false;
    }
    if (!regex.hasMatch(nPassCtrl.text.trim())) {
      errNPass.value = "Password should contain upper,lower,digit and Special character";
      return false;
    }
    if (cnPassCtrl.text.trim().toString() == '') {
      errCNPass.value = "Enter Confirm password";
      return false;
    }
    if (!regex.hasMatch(cnPassCtrl.text.trim())) {
      errCNPass.value = "Password should contain upper,lower,digit and Special character";
      return false;
    }
    if (nPassCtrl.text.trim() != cnPassCtrl.text.trim()) {
      errOPass.value = "Password does not match";
      return false;
    }
    return true;
  }

  getDrawerTileList() {
    MenuMorePageController menuMorePageController = Get.find();

    List<Widget> menuList = [];
    menuList.add(
      Container(
        height: 70,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.7)))),
        child: Row(
          children: [
            SizedBox(width: 30),
            Image.asset(
              'assets/images/axAppLogo.png',
              width: 40,
            ),
            SizedBox(width: 25),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                TextScroll(
                  CommonMethods.capitalize(userName.value),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
    var index;
    var masterIndex = 0;
    for (var item in menuMorePageController.finalMenuHeader) {
      index = 0;
      // var wid = ListTile(leading: Icon(Icons.access_alarm), title: Text(item.caption.toString()));
      // menuList.add(wid);
      var wid2 = ExpansionTile(
        leading: Icon(menuMorePageController.IconList[masterIndex++ % 8]),
        title: Text(item.toString()),
        children: getDrawerInnerListTile(menuMorePageController, item, index).toList(),
      );
      menuList.add(wid2);
    }
    menuList.add(Container(
      height: 70,
      child: Center(
          child: Text(
        'App Version: ${Const.APP_VERSION}\n© agile-labs.com 2023',
        textAlign: TextAlign.center,
      )),
    ));
    return menuList;
  }

  getDrawerInnerListTile(MenuMorePageController menuMorePageController, item, index) {
    List<Widget> innerTile = [];
    innerTile.add(Container(
      height: 1,
      color: Colors.grey.withOpacity(0.1),
    ));
    for (MenuItemModel subMenu in menuMorePageController.finalHeadingWiseData[item] ?? [])
      innerTile.add(InkWell(
        onTap: () {
          menuMorePageController.openItemClick(subMenu);
          Get.back();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          // menuMorePageController.IconList[index++ % 8]
          child: ListTile(
              leading: Icon(menuMorePageController.generateIcon(subMenu, index++)), title: Text(subMenu.caption.toString())),
        ),
      ));

    return ListTile.divideTiles(context: Get.context, tiles: innerTile);
    // return innerTile;
  }

  void deleteAllNotifications() {
    Map oldMessages = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    var projectName = appStorage.retrieveValue(AppStorage.PROJECT_NAME) ?? "";
    Map projectWiseMessages = oldMessages[projectName] ?? {};
    var userName = appStorage.retrieveValue(AppStorage.USER_NAME) ?? "";

    projectWiseMessages.remove(userName);
    oldMessages[projectName] = projectWiseMessages;
    appStorage.storeValue(AppStorage.NOTIFICATION_LIST, oldMessages);
    needRefreshNotification.value = true;
    notificationPageRefresh.value = true;
  }

  void openWebView(String item) {
    try {
      var url = Const.getFullProjectUrl('aspx/AxMain.aspx?authKey=AXPERT-') + appStorage.retrieveValue(AppStorage.SESSIONID);
      var jsonData = jsonDecode(item);
      var messageClicked = jsonData["msg_onclick"] ?? "";
      print(messageClicked);
      if (messageClicked != "") {
        var jsonMainClickData = jsonDecode(messageClicked);
        print(jsonMainClickData['type']);
        var msgType = jsonMainClickData['type'];
        var msgValue = jsonMainClickData['value'].replaceAll("transid~", "").replaceAll("ivname~", "");
        url += "&pname=" + msgType + msgValue;
        print(url);
        Get.toNamed(Routes.InApplicationWebViewer, arguments: [url]);
      }
    } catch (e) {
      print("Can not open web view: error- " + e.toString());
    }
    // Get.toNamed(Routes.InApplicationWebViewer);
  }

  void fetchAndOpenWebView(int index) async {
    Map oldMessages = await appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    var projectName = await appStorage.retrieveValue(AppStorage.PROJECT_NAME) ?? "";
    Map projectWiseMessages = oldMessages[projectName] ?? {};
    var userName = await appStorage.retrieveValue(AppStorage.USER_NAME) ?? "";
    List notiList = projectWiseMessages[userName] ?? [];

    var clicked = notiList[index];
    openWebView(clicked);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      if (willAuth)
        isAuthRequired = true;
      else
        isAuthRequired = false;
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (isAuthRequired && !Get.isDialogOpen!) {
          isAuthRequired = false;
          await doTheMergeProcess();
          notificationPageRefresh.value = true;
          needRefreshNotification.value = true;
          var auth = await showBiometricDialog();

          Get.dialog(
            barrierDismissible: false,
            WidgetShakeableDialog(
              child: Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            auth = await showBiometricDialog();
                            if (auth) {
                              print(auth);
                              Get.back();
                              auth = false;
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              Icons.fingerprint_outlined,
                              color: MyColors.blue2,
                              size: 40,
                            ),
                          ),
                        ),
                        Text("Please Authenticate to access"),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {
                                  signOut();
                                },
                                child: Text("Exit")),
                            ElevatedButton(
                                onPressed: () async {
                                  auth = await showBiometricDialog();
                                  if (auth) {
                                    print(auth);
                                    Get.back();
                                    auth = false;
                                  }
                                },
                                child: Text("Try Again"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );

          if (auth) Get.back();
        }
      });
    }
  }
}
