import 'dart:convert';
import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Models/FirebaseMessageModel.dart';
import 'package:axpertflutter/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

initialize() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }
  NotificationSettings settings = await messaging.requestPermission(
      alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    hasNotificationPermission = true;
  } else
    hasNotificationPermission = false;

  AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  );
  InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  var fcmID = await messaging.getToken();
  print("FCMID: $fcmID");
}

onMessageListener(RemoteMessage message) {
  decodeFirebaseMessage(message);
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageListner(RemoteMessage message) async {
  await GetStorage.init();
  print("Background message: ${message.data}");
  decodeFirebaseMessage(message, isBackground: true);
}

onMessageOpenAppListener(RemoteMessage message) {
  print("Opened in android");
  try {
    Get.toNamed(Routes.NotificationPage);
  } catch (e) {
    Get.toNamed(Routes.SplashScreen);
  }
}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  print("Opened in iOS");
  try {
    Get.toNamed(Routes.NotificationPage);
  } catch (e) {
    Get.toNamed(Routes.SplashScreen);
  }
}

onDidReceiveLocalNotification(id, title, body, payload) {}

void decodeFirebaseMessage(RemoteMessage message, {isBackground = false}) async {
  AppStorage appStorage = AppStorage();
  var shouldDisplay = false;
  var notiProjectName = "";
  var projectName = await appStorage.retrieveValue(AppStorage.PROJECT_NAME).toString() ?? "";
  print("project name: $projectName");
  var userName = (await appStorage.retrieveValue(AppStorage.USER_NAME) ?? "").toString().trim();
  print("Message Received:" + message.data.toString());
  FirebaseMessageModel data;
  try {
    data = FirebaseMessageModel(message.data["notify_title"], message.data["notify_body"]);
    var projectDet = jsonDecode(message.data['project_details']);

    notiProjectName = projectDet["projectname"].toString();
    if (notiProjectName == projectName &&
        userName != "" &&
        message.data["notify_to"].toString().toLowerCase().contains(userName.toLowerCase())) {
      shouldDisplay = true;
    }
  } catch (e) {
    print(e.toString());
    data = FirebaseMessageModel("Axpert", "You have received a new notification");
  }
  if (hasNotificationPermission) {
    try {
      if (shouldDisplay)
        await flutterLocalNotificationsPlugin.show(data.hashCode, data.title, data.body, notificationDetails, payload: 'item x');
    } catch (e) {}
  }

  //save message

  if (shouldDisplay) {
    //get and modify old messages
    // await GetStorage.init();\
    var notNo;
    if (isBackground) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      var backList = await (prefs.getStringList(AppStorage.SHAREDPREF_NAME) ?? []).toList();
      backList.add(jsonEncode(message.data));
      await prefs.setStringList(AppStorage.SHAREDPREF_NAME, backList);
      print("list length: ${backList.length}");
    } else {
      Map oldMessages = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
      Map projectWiseMessages = oldMessages[notiProjectName] ?? {};
      var userWiseMessages = projectWiseMessages[userName] ?? [];
      var messageList = [];
      messageList.add(jsonEncode(message.data));
      if (!userWiseMessages.isEmpty) messageList.addAll(userWiseMessages);
      projectWiseMessages[userName] = messageList;
      oldMessages[notiProjectName] = projectWiseMessages;
      appStorage.remove(AppStorage.NOTIFICATION_LIST);
      appStorage.storeValue(AppStorage.NOTIFICATION_LIST, oldMessages);
      // //get and Modify notify Number
      // print(messageList.length);
      Map oldNotifyNum = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
      Map projectWiseNum = oldNotifyNum[notiProjectName] ?? {};
      notNo = projectWiseNum[userName] ?? "0";
      notNo = int.parse(notNo) + 1;
      projectWiseNum[userName] = notNo.toString();
      oldNotifyNum[notiProjectName] = projectWiseNum;
      appStorage.remove(AppStorage.NOTIFICATION_UNREAD);
      appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, oldNotifyNum);
    }
    try {
      LandingPageController landingPageController = Get.find();
      landingPageController.needRefreshNotification.value = true;
      landingPageController.notificationPageRefresh.value = true;
      landingPageController.showBadge.value = true;
      landingPageController.badgeCount.value = notNo;
    } catch (e) {}
  }
}
