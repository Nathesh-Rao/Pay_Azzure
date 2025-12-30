import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/EmployeeData.dart';
import 'package:get/get.dart';

class GlobalVariableController extends GetxController {
  var WEB_URL = ''.obs;
  var PROJECT_NAME = ''.obs;
  var ARM_URL = ''.obs;
  var NICK_NAME = ''.obs;
  var USER_NAME = ''.obs;
  var USER_EMAIL = ''.obs;
  Rxn<EmployeeData> currentEmployee = Rxn<EmployeeData>();
  EmployeeData? currentEmployeeData;
}
