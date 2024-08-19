import 'dart:math';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNotification.dart';
import 'package:axpertflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  late LandingPageController landingPageController;
  final args = Get.arguments ?? {};
  var unreadCount;
  NotificationPage({super.key}) {
    try {
      flutterLocalNotificationsPlugin.cancelAll();
      landingPageController = Get.find();
    } catch (e) {
      // landingPageController = Get.put(LandingPageController());
    }
  }

  @override
  Widget build(BuildContext context) {
    unreadCount = args![0] ?? 0;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        flutterLocalNotificationsPlugin.cancelAll();
        if (unreadCount != 0) {
          var userName = AppStorage().retrieveValue(AppStorage.USER_NAME) ?? "";
          Map oldNotifyNum = AppStorage().retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
          var projectName = AppStorage().retrieveValue(AppStorage.PROJECT_NAME) ?? "";
          Map projectWiseNum = oldNotifyNum[projectName] ?? {};
          var notNo = projectWiseNum[userName] ?? "0";
          notNo = "0";
          projectWiseNum[userName] = notNo;
          oldNotifyNum[projectName] = projectWiseNum;
          AppStorage().storeValue(AppStorage.NOTIFICATION_UNREAD, oldNotifyNum);
          landingPageController.badgeCount.value = 0;
          landingPageController.showBadge.value = false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: MyColors.updatedUIBackgroundGradient),
          ),
          // elevation: 0,
          // backgroundColor: Colors.white,
          foregroundColor: MyColors.white1,
          actions: [
            TextButton(
                onPressed: () {
                  // landingPageController.deleteAllNotifications();
                  Get.defaultDialog(
                      title: "Delete All?",
                      middleText: "Do you want to delete all notifications?",
                      confirm: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          landingPageController.deleteAllNotifications();
                        },
                        child: Text("Yes"),
                      ),
                      cancel: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("No")),
                      barrierDismissible: false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    "Clear All",
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ),
        body: SafeArea(
          child: Obx(() => Padding(padding: EdgeInsets.only(bottom: 10), child: reBuild())),
        ),
      ),
    );
  }

  reBuild() {
    unreadCount = args![0] ?? 0;
    var val = getFromStorage();
    unreadCount = max<int>(unreadCount, val);

    if (landingPageController.notificationPageRefresh.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        landingPageController.notificationPageRefresh.value = false;
      });

      landingPageController.getNotificationList();
      return ListView.builder(
        itemBuilder: (context, index) {
          return drawNotificationItem(landingPageController.list[index], index, isNew: index < unreadCount ? true : false);
        },
        itemCount: landingPageController.list.length,
      );
    } else
      return ListView.builder(
        itemBuilder: (context, index) {
          return drawNotificationItem(landingPageController.list[index], index, isNew: index < unreadCount ? true : false);
        },
        itemCount: landingPageController.list.length,
      );
  }

  drawNotificationItem(WidgetNotification item, int index, {isNew = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Dismissible(
        key: ValueKey(index),
        background: Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Delete",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        confirmDismiss: (direction) {
          return landingPageController.deleteNotification(index);
        },
        secondaryBackground: Container(
          padding: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Delete",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        child: Stack(
          children: [
            Material(
              borderRadius: BorderRadius.circular(10),
              color: isNew ? Colors.blue.shade100 : Colors.white,
              elevation: 3,
              child: Container(
                  width: double.maxFinite,
                  constraints: BoxConstraints(minHeight: 120),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                landingPageController.fetchAndOpenWebView(index);
                              },
                              child: Container(color: Colors.transparent, child: item))),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.shade900,
                        ),
                        onPressed: () {
                          landingPageController.deleteNotification(index);
                        },
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 8.0),
                      //     child: IconButton(
                      //       icon: Icon(
                      //         Icons.delete,
                      //         color: Colors.red.shade900,
                      //       ),
                      //       onPressed: () {},
                      //     ),
                      //   ),
                      // )
                    ],
                  )),
            ),
            Visibility(
              visible: isNew,
              child: Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/new.png',
                  height: 60,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getFromStorage() {
    var userName = AppStorage().retrieveValue(AppStorage.USER_NAME) ?? "";
    var notiProjectName = AppStorage().retrieveValue(AppStorage.PROJECT_NAME).toString();
    Map oldNotifyNum = AppStorage().retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    Map projectWiseNum = oldNotifyNum[notiProjectName] ?? {};
    var notNo = projectWiseNum[userName] ?? "0";
    print(notNo);
    return int.parse(notNo);
  }
}
