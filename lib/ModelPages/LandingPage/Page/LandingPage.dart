import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/AttendanceController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetBottomNavigation.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetDrawer.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetLandingAppBarUpdated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../InApplicationWebView/controller/webview_controller.dart';
import '../../LandingMenuPages/MenuActiveListPage/Controllers/UpdatedActiveTaskListController/ActiveTaskListController.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final LandingPageController landingPageController = Get.find();
  final MenuHomePageController menuHomePageController =
      Get.put(MenuHomePageController());
  final WebViewController webViewController = Get.find();
  final ActiveTaskListController _c = Get.put(ActiveTaskListController());
  final PayAndLeaveController _p = Get.put(PayAndLeaveController());
  final AttendanceController _a = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return; // already popped, no action needed

          if (webViewController.currentIndex.value == 1) {
            // If WebView is visible, go back to Home instead of closing app
            webViewController.currentIndex.value = 0;
          } else {
            // If already on Home, allow normal app close
            final shouldPop = await landingPageController.onWillPop();
            /*if (shouldPop) {
                  // Completely close the app
                  SystemNavigator.pop();
                }*/
          }
        },
        child: IndexedStack(
          index: webViewController.currentIndex.value,
          children: [
            Scaffold(
              appBar: WidgetLandingAppBarUpdated(),
              // appBar: WidgetLandingAppBar(),
              drawer: WidgetDrawer(),
              bottomNavigationBar: AppBottomNavigation(),
              body: /*WillPopScope(
                onWillPop: landingPageController.onWillPop,
                child:*/
                  Obx(
                () => Stack(
                  children: [
                    landingPageController.getPage(),
                  ],
                ),
              ),
              /* menuHomePageController.switchPage.value == true
                        ? InApplicationWebViewer(menuHomePageController.webUrl)
                        : landingPageController.getPage(),
                    ),*/
            ),
            //  ),
            Obx(() =>
                InApplicationWebViewer(webViewController.currentUrl.value)),
          ],
        ),
      ),
    );
  }
}
