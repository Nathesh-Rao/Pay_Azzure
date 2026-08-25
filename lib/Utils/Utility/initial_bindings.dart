import 'package:get/get.dart';

import '../../Constants/GlobalVariableController.dart';
import '../../ModelPages/LandingMenuPages/offline_form_pages/controller/offline_form_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalVariableController(), permanent: true);
    Get.put(OfflineFormController(), permanent: true);
  }
}
