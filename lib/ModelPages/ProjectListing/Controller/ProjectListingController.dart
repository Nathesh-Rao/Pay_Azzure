import 'dart:convert';
import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:get/get.dart';

class ProjectListingController extends GetxController {
  var needRefresh = false.obs;
  var isloading = false.obs;
  List<dynamic> fullList = [].obs;
  var number = 1.obs;
  var isCountAvailable = false.obs;
  AppStorage appStorage = AppStorage();

  ProjectListingController() {
    getProjectCount();
  }

  getConnections() {
    List<dynamic> list = [];
    var jsonList = appStorage.retrieveValue(AppStorage.PROJECT_LIST);
    if (jsonList == null) {
      return list;
    } else {
      list = jsonDecode(jsonList).toList();
      fullList = list;
      return list;
    }
  }

  getProjectCount() {
    List<dynamic> list = getConnections();
    if (list.isEmpty) {
      isCountAvailable.value = false;
      return 0;
    } else {
      isCountAvailable.value = true;
      print(list);
      return list.length;
    }
  }

  Future<List<dynamic>> getProjectList() async {
    return await getConnections();
  }
}
