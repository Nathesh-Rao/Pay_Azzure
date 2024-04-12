import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetBottomNavigation.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetDrawer.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetLandingAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final LandingPageController landingPageController = Get.put(LandingPageController());
  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetLandingAppBar(),
      drawer: WidgetDrawer(),
      bottomNavigationBar: AppBottomNavigation(),
      body: WillPopScope(
        onWillPop: landingPageController.onWillPop,
        child: Obx(() => menuHomePageController.switchPage.value == true
            ? InApplicationWebViewer(menuHomePageController.webUrl)
            : landingPageController.getPage),
      ),
    );
  }
}
