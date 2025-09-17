import 'dart:convert';
import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/WebViewCalendar.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/MenuActiveListPage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Page/MenuDashboardPage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Controllers/MenuMorePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Models/MenuItemModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Page/MenuMorePage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/UpdatedHomePage/Page/UpdatedHomePage.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Models/FirebaseMessageModel.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNotification.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../InApplicationWebView/controller/webview_controller.dart';
import '../../LandingMenuPages/MenuActiveListPage/Page/UpdatedMenuListPage/ActiveListPage.dart';
import '../../LandingMenuPages/MenuHomePagePage/Models/BannerModel.dart';
import '../Widgets/EmptyWidget.dart';
import '../Widgets/WidgetBanner.dart';

class LandingPageController extends GetxController with WidgetsBindingObserver {
  final globalVariableController = Get.find<GlobalVariableController>();
  final webViewController = Get.find<WebViewController>();
  final MenuMorePageController menuMorePageController = Get.put(MenuMorePageController());

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
  var userName = 'Demo'.obs;
  var userNickName = 'Demo'.obs;

  ///update with user name
  var bottomIndex = 0.obs;
  var carouselIndex = 0.obs;
  var carouselBannerIndex = 0.obs;
  var needRefreshNotification = false.obs;
  var notificationPageRefresh = false.obs;
  var showBadge = false.obs;
  var badgeCount = 0.obs;
  var fool = false.obs;
  var willAuth = false;
  var isAuthRequired = false;
  var unread;
  var toDay;
  final CarouselSliderController carouselController_notify = CarouselSliderController();
  final CarouselSliderController carouselController_banner = CarouselSliderController();

  DateTime currentBackPressTime = DateTime.now();

  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();

  late var pageList;
  var list = [WidgetNotification(FirebaseMessageModel("Title 1", "Body 1"))];
  var list_bannerItem = [].obs;
  bool isAxpertConnectEstablished = false;

  getPage() {
    if (bottomIndex.value == 0) {
      return UpdatedHomePage();
      // return MenuHomePage();
    }
    return pageList[bottomIndex.value];
  }

  LandingPageController() {
    var dt = DateTime.now();
    toDay = DateFormat('dd-MMM-yyyy, EEEE').format(dt);
    userName.value = appStorage.retrieveValue(AppStorage.USER_NAME) ?? userName.value;
    userCtrl.text = userName.value;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pageList = [
        UpdatedHomePage(),
        // MenuActiveListPage(),
        ActiveListPage(),
        MenuDashboardPage(),

        ///NOTE Pass a [ValueKey] with a unique identifier to force widget rebuilds.
        //NOTE to open the WebViewCalendar page
        EmptyWidget(), //NOTE to open the WebViewCalendar page handled in indexchange() method
        EmptyWidget(), //NOTE to open the WebViewAnalytics page handled in indexchange() method
        //MenuMorePage(),
      ];
    });
    showChangePassword_PopUp();
    // getBiometricStatus();
    getClientInfo();
    // getBannerDetailList();
  }

  getClientInfo() async {
    // var dataSourceUrl = baseUrl + GlobalConfiguration().get("HomeCardDataResponse").toString();
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_GET_HOMEPAGE_CARDSDATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "username": appStorage.retrieveValue(AppStorage.USER_NAME),
      "appname": globalVariableController.PROJECT_NAME.value, //"agilepost113",
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
            userNickName.value = item['user_nickname'] ?? "";
          } catch (e) {
            print(e);
          }
        }
      }
    }
  }

  getBiometricStatus() async {
    var willAuthLocal = await getWillBiometricAuthenticateForThisUser(userName.value);
    if (willAuthLocal == null || willAuthLocal == false) {
      Get.bottomSheet(
        isDismissible: false,
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
                      color: MyColors.PayAzzureColor2,
                      size: 80,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Biometric Authentication is now Available!",
                  style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(height: 20),
                Text(
                  "Log into your project account using your phone's biometric credentials..",
                  style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey.shade600)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    var willAuthenticate = await showBiometricDialog();
                    if (willAuthenticate) {
                      Get.back();
                    }
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
                    style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => Colors.grey.shade300)),
                    child: Container(
                      width: 300,
                      child: Center(child: Text("Skip for now")),
                    )),
              ],
            ),
          ),
        ),
        // isDismissible: false,
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

  indexChange(index) async {
    MenuHomePageController menuHomePageController = Get.find();
    menuHomePageController.switchPage.value = false;
    bottomIndex.value = index;

    if (pageList[index] is EmptyWidget) {
      if (index == 3) {
        //NOTE to open the WebViewCalendar page
        await webViewController.openWebView(
          url: Const.getFullWebUrl(Const.BOTTOMBAR_CALENDAR) + AppStorage().retrieveValue(AppStorage.SESSIONID),
        );
      } else if (index == 4) {
        //NOTE to open the WebViewAnalytics page
        await webViewController.openWebView(
          url: Const.getFullWebUrl(Const.BOTTOMBAR_ANALYTICS) + AppStorage().retrieveValue(AppStorage.SESSIONID),
        );
      }
      bottomIndex.value = 0;
    }
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
      // SystemNavigator.pop(animated: true);
      exit(0);
      // return Future.value(true);
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
              webViewController.signOut(url: Const.getFullWebUrl("aspx/AxMain.aspx?signout=true"));
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
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.grey)),
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
            notify_to.contains(userName.toString().toLowerCase())) list.add(WidgetNotification(FirebaseMessageModel.fromJson(val)));
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
      errOPass.value = "Enter Existing password";
      return false;
    }
    /* if (!regex.hasMatch(oPassCtrl.text.trim())) {
      errOPass.value = "Password should contain upper,lower,digit and Special character";
      return false;
    }*/
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
      errCNPass.value = "Password does not match";
      return false;
    }
    return true;
  }

  getDrawerTileList() {
    List<Widget> menuList = [];

    menuList.add(
      Container(
        height: 70,
        decoration: BoxDecoration(color: MyColors.PayAzzureColor2.withAlpha(450), border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.7)))),
        child: Row(
          children: [
            SizedBox(width: 30),
            Image.asset(
              'assets/images/axpert_03.png',
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
                  CommonMethods.capitalize(Get.find<MenuHomePageController>().user_nickName.value),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
    /*var index;
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
    }*/
    var a = menuMorePageController.menu_finalList.map(build_innerListTile).toList();
    menuList.addAll(a);

    if (menuList.length == 1) {
      menuList.add(ListTile(
        tileColor: Colors.white,
        onTap: () {
          Get.back();
          indexChange(0);
        },
        leading: Icon(Icons.home_outlined),
        title: Text("Home"),
      ));
      menuList.add(ListTile(
        tileColor: Colors.white,
        onTap: () {
          Get.back();
          indexChange(1);
        },
        leading: Icon(Icons.view_list_outlined),
        title: Text("Active List"),
      ));
      menuList.add(ListTile(
        tileColor: Colors.white,
        onTap: () {
          Get.back();
          indexChange(2);
        },
        leading: Icon(Icons.speed_outlined),
        title: Text("Dashboard"),
      ));
      menuList.add(ListTile(
        tileColor: Colors.white,
        onTap: () {
          Get.back();
          indexChange(3);
        },
        leading: Icon(Icons.calendar_month_outlined),
        title: Text("Calendar"),
      ));
      menuList.add(ListTile(
        tileColor: Colors.white,
        onTap: () {
          Get.back();
          indexChange(4);
        },
        leading: Icon(Icons.analytics_outlined),
        title: Text("Analytics"),
      ));
      menuList.add(ListTile(
        tileColor: Colors.white,
        onTap: () {
          Get.back();
          indexChange(5);
        },
        leading: Icon(Icons.dashboard_customize_outlined),
        title: Text("More"),
      ));
      menuList.add(ListTile(
        tileColor: Colors.white,
        onTap: () {
          Get.back();
          signOut();
        },
        leading: Icon(Icons.power_settings_new),
        title: Text("Logout"),
      ));
      menuList.add(SizedBox(
        height: MediaQuery.of(Get.context!).size.height - 540,
      ));
    }
    menuList.add(Container(
      color: Colors.white,
      height: 70,
      child: Center(
          child: Column(
        children: [
          Text(
            'App Version: ${Const.APP_VERSION}',
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/axpert_03.png',
                height: Get.height * 0.03,
                // width: MediaQuery.of(context).size.width * 0.075,
                fit: BoxFit.fill,
              ),
              Text(" © ${DateTime.now().year} Powered by Axpert"),
            ],
          )
        ],
      )),
    ));

    return menuList;
  }

  Widget build_innerListTile(tile, {double leftPadding = 15}) {
    MenuItemNewmModel model_tile = tile;
    if (model_tile.childList.isEmpty) {
      return Visibility(
        visible: model_tile.visible.toUpperCase() == "T",
        child: InkWell(
          onTap: () {
            menuMorePageController.openItemClick(model_tile);
            Get.back();
          },
          child: ListTile(
            tileColor: Colors.white,
            leading: Icon(menuMorePageController.generateIcon(tile, 1)),
            contentPadding: EdgeInsets.only(left: leftPadding),
            title: Text(
              model_tile.caption,
            ),
          ),
        ),
      );
    } else {
      return Visibility(
        visible: model_tile.visible.toUpperCase() == "T",
        child: ExpansionTile(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white70,
          leading: Icon(menuMorePageController.generateIcon(tile, 1)),
          tilePadding: EdgeInsets.only(left: leftPadding, right: 10),
          title: Text(tile.caption),
          children: ListTile.divideTiles(
              context: Get.context, tiles: model_tile.childList.map((tile) => build_innerListTile(tile, leftPadding: leftPadding + 15))).toList(),
        ),
      );
    }
  }

  getDrawerInnerListTile(MenuMorePageController menuMorePageController, item, index) {
    List<Widget> innerTile = [];
    innerTile.add(Container(
      height: 1,
      color: Colors.white,
      // color: Colors.grey.withOpacity(0.1),
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
          child: ListTile(leading: Icon(menuMorePageController.generateIcon(subMenu, index++)), title: Text(subMenu.caption.toString())),
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
      var url = Const.getFullWebUrl('aspx/AxMain.aspx?authKey=AXPERT-') + appStorage.retrieveValue(AppStorage.SESSIONID);
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
        // Get.toNamed(Routes.InApplicationWebViewer, arguments: [url]);
        webViewController.openWebView(url: url);
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
    // print('state = $state');
    // if (state == AppLifecycleState.paused) {
    //   if (willAuth)
    //     isAuthRequired = true;
    //   else
    //     isAuthRequired = false;
    //   if (Get.isDialogOpen!) {
    //     Get.back();
    //   }
    // }
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await doTheMergeProcess();
        // if (isAuthRequired && !Get.isDialogOpen!) {
        //   isAuthRequired = false;
        //   notificationPageRefresh.value = true;
        //   needRefreshNotification.value = true;
        //   var auth = await showBiometricDialog();
        //
        //   Get.dialog(
        //     barrierDismissible: false,
        //     WidgetShakeableDialog(
        //       child: Dialog(
        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        //         child: Container(
        //           height: 200,
        //           width: 300,
        //           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        //           child: Center(
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 GestureDetector(
        //                   onTap: () async {
        //                     auth = await showBiometricDialog();
        //                     if (auth) {
        //                       print(auth);
        //                       Get.back();
        //                       auth = false;
        //                     }
        //                   },
        //                   child: Container(
        //                     color: Colors.transparent,
        //                     padding: EdgeInsets.all(20),
        //                     child: Icon(
        //                       Icons.fingerprint_outlined,
        //                       color: MyColors.blue2,
        //                       size: 40,
        //                     ),
        //                   ),
        //                 ),
        //                 Text("Please Authenticate to access"),
        //                 SizedBox(height: 20),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                   children: [
        //                     TextButton(
        //                         onPressed: () {
        //                           signOut();
        //                         },
        //                         child: Text("Exit")),
        //                     ElevatedButton(
        //                         onPressed: () async {
        //                           auth = await showBiometricDialog();
        //                           if (auth) {
        //                             print(auth);
        //                             Get.back();
        //                             auth = false;
        //                           }
        //                         },
        //                         child: Text("Try Again"))
        //                   ],
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   );
        //
        //   if (auth) Get.back();
        // }
      });
    }
  }

  showChangePassword_PopUp() async {
    AppStorage appStorage = AppStorage();
    var isChangePassword = await appStorage.retrieveValue(AppStorage.USER_CHANGE_PASSWORD);
    if (isChangePassword.toString().toLowerCase() == "true") {
      Get.dialog(
        barrierDismissible: false,
        PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
              child: SingleChildScrollView(
                child: Obx(() => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: oPassCtrl,
                          obscureText: !showOldPass.value,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {},
                          style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
                          decoration: InputDecoration(
                            labelText: 'Existing Password',
                            hintText: 'Enter your old password',
                            errorText: this.evaluteError(errOPass.value),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showOldPass.value ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                showOldPass.toggle();
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: nPassCtrl,
                          obscureText: !showNewPass.value,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {},
                          style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            hintText: 'Enter your new password',
                            errorText: evaluteError(errNPass.value),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showNewPass.value ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                showNewPass.toggle();
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: cnPassCtrl,
                          obscureText: !showConNewPass.value,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {},
                          style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
                          decoration: InputDecoration(
                            labelText: 'Confrmation Password',
                            hintText: 'Enter your Confrmation password',
                            errorText: evaluteError(errCNPass.value),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showConNewPass.value ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                showConNewPass.toggle();
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          SizedBox(
                            height: 30.0,
                            width: 100.0,
                            child: ElevatedButton(
                              onPressed: () {
                                //Get.back();
                                changePasswordCalled();
                              },
                              child: Container(
                                width: 600.0,
                                height: 30,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(3.0, 6.0, 3.0, 3.0),
                                child: Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"),
                                ),
                              ),
                            ),
                          )
                        ]),
                        SizedBox(height: 10),
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    }
  }

  showManageWindow({initialIndex = 0}) {
    oPassCtrl.text = "";
    nPassCtrl.text = "";
    cnPassCtrl.text = "";

    return Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          height: 400,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: DefaultTabController(
              length: 2,
              initialIndex: initialIndex,
              child: Scaffold(
                appBar: TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: "User Profile",
                    ),
                    Tab(text: "Change\nCredentials")
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TabBarView(
                    children: [userProfile(), userCredentials()],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeIn,
    );
  }

  userProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        TextFormField(
          readOnly: true,
          controller: userCtrl,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
          decoration: const InputDecoration(
            labelText: 'User Name',
            hintText: 'User Name',
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            closeProfileDialog();
          },
          child: Container(
            width: 600.0,
            height: 30,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: const EdgeInsets.fromLTRB(3.0, 6.0, 3.0, 3.0),
            child: Column(children: const [
              Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  userCredentials() {
    return Obx(() => Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: oPassCtrl,
              obscureText: !showOldPass.value,
              keyboardType: TextInputType.text,
              onChanged: (value) {},
              style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
              decoration: InputDecoration(
                labelText: 'Old Password',
                hintText: 'Enter your old password',
                errorText: evaluteError(errOPass.value),
                suffixIcon: IconButton(
                  icon: Icon(
                    showOldPass.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    showOldPass.toggle();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nPassCtrl,
              obscureText: !showNewPass.value,
              keyboardType: TextInputType.text,
              onChanged: (value) {},
              style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your new password',
                errorText: evaluteError(errNPass.value),
                suffixIcon: IconButton(
                  icon: Icon(
                    showNewPass.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    showNewPass.toggle();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: cnPassCtrl,
              obscureText: !showConNewPass.value,
              keyboardType: TextInputType.text,
              onChanged: (value) {},
              style: const TextStyle(fontFamily: "nunitobold", fontSize: 14.0),
              decoration: InputDecoration(
                labelText: 'Confrmation Password',
                hintText: 'Enter your Confrmation password',
                errorText: evaluteError(errCNPass.value),
                suffixIcon: IconButton(
                  icon: Icon(
                    showConNewPass.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    showConNewPass.toggle();
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SizedBox(
                height: 30.0,
                width: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                    closeProfileDialog();
                  },
                  child: Container(
                    width: 600.0,
                    height: 30,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.fromLTRB(3.0, 6.0, 3.0, 3.0),
                    child: Column(children: const [
                      Text('Cancel', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"))
                    ]),
                  ),
                ),
              ),
              Container(
                width: 15.0,
              ),
              SizedBox(
                height: 30.0,
                width: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                    changePasswordCalled();
                  },
                  child: Container(
                    width: 600.0,
                    height: 30,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(3.0, 6.0, 3.0, 3.0),
                    child: Text(
                      'Update',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "nunitoreg"),
                    ),
                  ),
                ),
              )
            ]),
          ],
        ));
  }

  getBannerDetailList() async {
    try {
      list_bannerItem.clear();
      var baseUrl = globalVariableController.WEB_URL.value;
      baseUrl += baseUrl.endsWith("/") ? "" : "/";
      var url = baseUrl + ServerConnections.BANNER_JSON_NAME;
      // url = "https://demo.agilecloud.biz/mainpagebanner.json";
      final data = await serverConnections.getFromServer(url: url, show_errorSnackbar: false);
      if (data != null && data != "") {
        print("getBannerDetails1: $data");
        var jsonResp = jsonDecode(data);
        if (jsonResp.length > 0) {
          list_bannerItem.clear();
          for (var item in jsonResp) {
            list_bannerItem.add(WidgetBanner(BannerModel.fromJson(item, baseUrl)));
          }
        }
      } else {
        if (globalVariableController.WEB_URL.value.endsWith("/")) {
          var URL = globalVariableController.WEB_URL.value.substring(0, globalVariableController.WEB_URL.value.length - 1);
          baseUrl = URL.substring(0, URL.lastIndexOf('/'));
        } else {
          baseUrl = globalVariableController.WEB_URL.value.substring(0, globalVariableController.WEB_URL.value.lastIndexOf('/'));
        }

        baseUrl += baseUrl.endsWith("/") ? "" : "/";
        var url = baseUrl + ServerConnections.BANNER_JSON_NAME;
        final data = await serverConnections.getFromServer(url: url, show_errorSnackbar: false);
        if (data != null && data != "") {
          print("getBannerDetails2: $data");
          var jsonResp = jsonDecode(data);
          if (jsonResp.length > 0) {
            list_bannerItem.clear();
            for (var item in jsonResp) {
              list_bannerItem.add(WidgetBanner(BannerModel.fromJson(item, baseUrl)));
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  signOut_withoutDialog() async {
    var body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var url = Const.getFullARMUrl(ServerConnections.API_SIGNOUT);
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      clearCacheData();
    } catch (e) {}
    appStorage.storeValue(AppStorage.USER_NAME, "");
    await serverConnections.postToServer(url: url, body: jsonEncode(body));
    LoadingScreen.dismiss();
    //webViewController.signOut(url: Const.getFullWebUrl("aspx/AxMain.aspx?signout=true"));
    Get.offAllNamed(Routes.Login);
  }

  Future<void> callApiForConnectToAxpert() async {
    var connectBody = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var cUrl = Const.getFullARMUrl(ServerConnections.API_CONNECTTOAXPERT);
    var connectResp = await serverConnections.postToServer(url: cUrl, body: jsonEncode(connectBody), isBearer: true);
    print(connectResp);
    // getArmMenu

    var jsonResp = jsonDecode(connectResp);
    if (jsonResp != "") {
      if (jsonResp['result']['success'].toString() == "true") {
        print("callApiForConnectToAxpert: ${jsonResp.toString()}");
        isAxpertConnectEstablished = true;
        // Get.offAllNamed(Routes.LandingPage);
      } else {
        var message = jsonResp['result']['message'].toString();
        showErrorSnack(title: "Error - Connect To Axpert", message: message);
      }
    } else {
      showErrorSnack();
    }
  }

  void showSignOutDialog_sessionExpired() {
    webViewController..signOut(url: Const.getFullWebUrl("aspx/AxMain.aspx?signout=true"));
    Get.defaultDialog(
      barrierDismissible: false,
      titleStyle: TextStyle(color: MyColors.PayAzzureColor2),
      titlePadding: EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      title: "Session Expired",
      content: PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Your session has expired. Please log in again to continue."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                signOut_withoutDialog();
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
