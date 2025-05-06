import 'dart:convert';
import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Models/FirebaseMessageModel.dart';
import 'package:axpertflutter/Services/LocationServiceManager/LocationServiceManager.dart';
import 'package:axpertflutter/Services/LocationServiceManager/location_service.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:axpertflutter/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
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
      //todo need to update the old method that removed
      //below method been removed from the package's latest vergitsion
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
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
  var messageData = message.data;
  //check if it is service related...

  if (messageData.containsKey("type")) //key from message
  {
    var receivedProjectName = messageData['project'].toString().trim();
    if (receivedProjectName != projectName) return;
    if (messageData['type'].toString().toLowerCase() == 'sendlocation') {
      //new functionality.....
      //update interval
      String interval = messageData['interval'].toString();
      String identifier = messageData['identifier'];
      print("Received Identifiers: ${identifier}");
      var pref = await SharedPreferences.getInstance();
      await pref.reload();
      String outerDataStr = await pref.getString("outerData") ?? "{}";
      Map outerMap = jsonDecode(outerDataStr);
      Map innerDetails = {};
      if (outerMap.containsKey(identifier)) {
        innerDetails = outerMap[identifier];
      }
      innerDetails["interval"] = interval;
      innerDetails["lastData"] = jsonEncode(message.data);
      outerMap[identifier] = innerDetails;

      await pref.setString("outerData", jsonEncode(outerMap));
      print("Identifier saved: ${identifier} and data ${jsonEncode(outerMap)}");

      // await startLocationTracking();
      await Future.delayed(Duration(seconds: 5));

      // LocalNotificationService.displayNotification("service", "running", "");
      //Get location here

      // if (lastApiCall == "0")
      //   await getLocationAndCallApi(data);
      // else {
      //   var dt = DateFormat("dd-MM-yyyy HH:mm:ss").parse(lastApiCall);
      //   var diff = dt.difference(DateTime.now()).inMinutes;
      //   if (diff > int.parse(interval)) {
      //     await getLocationAndCallApi(data);
      //   }
      // }
    } else if (messageData['type'].toString().toLowerCase() == 'stoplocation') {
      // stopBackgroundLocationService();
      // stopLocationTracking(messageData['identifier'].toString());
    }
    return;
  }

  FirebaseMessageModel data;
  try {
    data = FirebaseMessageModel(message.data["notify_title"], message.data["notify_body"]);
    var projectDet = jsonDecode(message.data['project_details']);

    notiProjectName = projectDet["projectname"].toString();
    if (notiProjectName == projectName &&
        userName != "" &&
        projectDet["notify_to"].toString().toLowerCase().contains(userName.toLowerCase())) {}
    shouldDisplay = true;
  } catch (e) {
    print(e.toString());
    data = FirebaseMessageModel("Axpert", "You have received a new notification");
  }
  print("hasNotificationPermission: ${hasNotificationPermission}: ${shouldDisplay}");

  if (hasNotificationPermission) {
    try {
      if (shouldDisplay && await AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled))
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

getLocationAndCallApi(data, [String lat = "0", String long = "0"]) async {
  print("Location parsing Initiated");
  String locName = "";
  if (lat == "0" && long == "0") {
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.reload();
    lat = await sharedPref.getString("lat") ?? "0";
    long = await sharedPref.getString("long") ?? "0";
    //get Name of the location and call api
    //double check the values
    if (lat == "0" || long == "0") {
      await Future.delayed(Duration(seconds: 5));
      await sharedPref.reload();
      lat = await sharedPref.getString("lat") ?? "0";
      long = await sharedPref.getString("long") ?? "0";
    }
  }
  var currentLoc = {"lat": lat, "long": long};

  try {
    LocationService locationService = LocationService();
    await locationService.getAddress(lat: double.parse(lat), lon: double.parse(long)).then((value) {
      locName = value['data'];
      print(value['data']);
    });
  } catch (e) {
    locName = " ";
    // LogService.writeLog(tag: "Error Parsing Location", subtag: "Location Parsing", message: e.toString());
  }

  // print(" Notification: lat: ${lat}, long: ${long}, Name: ${Const.LocName}");
  //decode and encode data
  var stringList = data['expectedlocations'];
  var listOfItems = [];
  for (var item in jsonDecode(stringList)) {
    var distance = Geolocator.distanceBetween(
      double.parse(item['lat']),
      double.parse(item['long']),
      double.parse(lat),
      double.parse(long),
    );
    item['dist'] = distance;
    print("Item: ${item}");
    listOfItems.add(item);
  }
  data['current_name'] = locName;
  data['current_loc'] = jsonEncode(currentLoc);
  data['expectedlocations'] = jsonEncode(listOfItems);

  var url = data['armurl'].toString().trim() ?? "";
  // var header = {"Content-Type": "application/json"};
  var postData = jsonEncode(data);
  print("PostData: ${postData}");
  try {
    // LogService.writeLog(tag: "Sending Data to Server", subtag: "Trying to call API", message: postData.toString());
    // var resp = await http.post(Uri.parse(url), body: postData, headers: header);
    var resp = await ServerConnections().postToServer(url: url, body: postData);
    print(resp.body.toString());
    // LogService.writeLog(tag: "Sending Data to Server", subtag: "Successfully sent", message: resp.body.toString());
  } catch (e) {
    print("Some error occured:");
  }
}
