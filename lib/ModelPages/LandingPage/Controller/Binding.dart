import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:get/get.dart';

import '../../InApplicationWebView/controller/webview_controller.dart';
import '../../LandingMenuPages/MenuDashboardPage/Controllers/MenuDashboaardController.dart';

class LandingPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => LandingPageController());
    Get.lazyPut(() => WebViewController());
    Get.lazyPut(() => MenuDashboardController());
  }
}
