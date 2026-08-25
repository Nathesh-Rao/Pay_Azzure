import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/EmployeeData.dart';
import 'package:get/get.dart';

class GlobalVariableController extends GetxController {
  var WEB_URL = ''.obs;
  var PROJECT_NAME = ''.obs;
  var ARM_URL = ''.obs;
  var NICK_NAME = ''.obs;
  var USER_NAME = ''.obs;
  var USER_EMAIL = ''.obs;
  var USER_ROLE = ''.obs;
  // Rxn<EmployeeData> currentEmployee = Rxn<EmployeeData>();
  EmployeeData? currentEmployeeData;

  var OFFLINE_FORMS_COUNT = 0.obs;
  final RxBool autoSyncEnabled = false.obs;
  final RxBool autoSyncMasterEnabled = false.obs;
}
