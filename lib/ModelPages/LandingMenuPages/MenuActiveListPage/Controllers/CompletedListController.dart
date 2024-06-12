import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/PendingListModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/PendingTaskModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedListController extends GetxController {
  var subPage = true.obs;
  var needRefresh = true.obs;
  var completed_activeList = [].obs;
  var completedCount = "0";
  var isLoading = false.obs;

  var selectedIconNumber = 1.obs; //1->default, 2-> reload, 3->accesstime, 4-> filter, 5=> checklist
  PendingTaskModel? completedTaskModel;
  List<PendingListModel> activeList_Main = [];
  PendingListModel? openModel;
  String selectedTaskID = "";
  var processFlowList = [].obs;
  TextEditingController searchController = TextEditingController();
  var statusListActiveIndex = 2;
  ScrollController scrollController = ScrollController(initialScrollOffset: 100 * 3.0);
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  var widgetProcessFlowNeedRefresh = true.obs;

  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController processNameController = TextEditingController();
  TextEditingController fromUserController = TextEditingController();
  var errDateFrom = "".obs;
  var errDateTo = "".obs;

  CompletedListController() {
    // print("-----------CompletedListController Called-------------");
    getNoOfCompletedActiveTasks();
    // getPendingActiveList();
  }

  Future<void> getNoOfCompletedActiveTasks() async {
    LoadingScreen.show();
    isLoading.value = true;
    var url = Const.getFullARMUrl(ServerConnections.API_GET_COMPLETED_ACTIVETASK_COUNT);
    var body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        completedCount = jsonResp['result']['data'].toString();
      }
      await getPendingActiveList();
    }
    isLoading.value = false;
    LoadingScreen.dismiss();
  }

  Future<void> getPendingActiveList() async {
    var url = Const.getFullARMUrl(ServerConnections.API_GET_COMPLETED_ACTIVETASK);
    var body = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      "Trace": "false",
      "AppName": Const.PROJECT_NAME.toString(),
      "pagesize": double.parse(completedCount).toInt(),
      "pageno": 1,
    };

    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        activeList_Main.clear();
        var dataList = jsonResp['result']['completedtasks'];

        for (var item in dataList) {
          PendingListModel pendingActiveListModel = PendingListModel.fromJson(item);
          activeList_Main.add(pendingActiveListModel);
        }
      }
      completed_activeList.value = activeList_Main;
      needRefresh.value = true;
    }
  }

  String getDateValue(String? eventdatetime) {
    var parts = eventdatetime!.split(' ');
    return parts[0].trim() ?? "";
  }

  String getTimeValue(String? eventdatetime) {
    var parts = eventdatetime!.split(' ');
    return parts[1].trim() ?? "";
  }

  filterList(value) {
    value = value.toString().trim();
    needRefresh.value = true;
    if (value == "") {
      completed_activeList.value = activeList_Main;
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      needRefresh.value = true;
      var newList = activeList_Main.where((oldValue) {
        return oldValue.displaytitle.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
            oldValue.eventdatetime.toString().toLowerCase().contains(value.toString().toLowerCase());
      });
      // print("new list: " + newList.length.toString());
      completed_activeList.value = newList.toList();
    }
  }

  void clearCalled() {
    searchController.text = "";
    filterList("");
    FocusManager.instance.primaryFocus?.unfocus();
  }

  ////////////////////////************************** Pending List Item Details *****************

  // fetchDetails({hasArgument = false, PendingProcessFlowModel? pendingProcessFlowModel = null}) async {
  //   LoadingScreen.show();
  //   var url = Const.getFullARMUrl_SecondServer(ServerConnections.API_GET_ACTIVETASK_DETAILS);
  //   var body;
  //   var shouldCall = true;
  //   if (hasArgument) {
  //     if (pendingProcessFlowModel!.taskid.toString() == "" || pendingProcessFlowModel!.taskid.toString().toLowerCase() == "null")
  //       shouldCall = false;
  //
  //     body = {
  //       'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
  //       "AppName": Const.PROJECT_NAME.toString(),
  //       "processname": pendingProcessFlowModel!.processname,
  //       "tasktype": pendingProcessFlowModel!.tasktype,
  //       "taskid": pendingProcessFlowModel!.taskid,
  //       "keyvalue": pendingProcessFlowModel!.keyvalue,
  //     };
  //     selectedTaskID = pendingProcessFlowModel!.taskid;
  //   } else {
  //     if (openModel!.taskid.toString() == "" || openModel!.taskid.toString().toLowerCase() == "null") shouldCall = false;
  //     body = {
  //       'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
  //       "AppName": Const.PROJECT_NAME.toString(),
  //       "processname": openModel!.processname,
  //       "tasktype": openModel!.tasktype,
  //       "taskid": openModel!.taskid,
  //       "keyvalue": openModel!.keyvalue
  //     };
  //     selectedTaskID = openModel!.taskid;
  //   }
  //   if (!shouldCall) {
  //     widgetProcessFlowNeedRefresh.value = true;
  //     LoadingScreen.dismiss();
  //     completedTaskModel = null;
  //     return;
  //   }
  //
  //   var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
  //   if (resp != "" ) {
  //     var jsonResp = jsonDecode(resp);
  //     if (jsonResp['result']['message'].toString() == "success") {
  //       //process Flow ********************************
  //       if (!hasArgument) {
  //         var dataList = jsonResp['result']['processflow'];
  //         processFlowList.clear();
  //         for (var item in dataList) {
  //           PendingProcessFlowModel processFlowModel = PendingProcessFlowModel.fromJson(item);
  //           processFlowList.add(processFlowModel);
  //         }
  //       }
  //
  //       // Task details *************************
  //       // var taskList = jsonResp['result']['taskdetails'];
  //       // for (var task in taskList) {
  //       //
  //       // }
  //       var task = jsonResp['result']['taskdetails'][0];
  //       if (task != null)
  //         completedTaskModel = PendingTaskModel.fromJson(task);
  //       else {
  //         completedTaskModel = null;
  //         // Get.snackbar("Oops!", "No details found!",
  //         //     duration: Duration(seconds: 1),
  //         //     snackPosition: SnackPosition.BOTTOM,
  //         //     backgroundColor: Colors.redAccent,
  //         //     colorText: Colors.white);
  //       }
  //     }
  //   }
  //   // print("Length: ${processFlowList.length}");
  //   widgetProcessFlowNeedRefresh.value = true;
  //   LoadingScreen.dismiss();
  // }

  void applyFilter() async {
    var url = Const.getFullARMUrl(ServerConnections.API_GET_FILTERED_COMPLETED_TASK);
    Map<String, dynamic> body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "AppName": Const.PROJECT_NAME.toString(),
      "pagesize": 1000,
      "pageno": 1,
    };
    if (fromUserController.text.trim() != "") body["fromuser"] = fromUserController.text.trim();
    if (processNameController.text.trim() != "") body["processname"] = processNameController.text.trim();
    if (searchTextController.text.trim() != "") body["searchtext"] = searchTextController.text.trim();
    if (dateFromController.text.trim() != "" && dateToController.text.trim() != "") {
      body["fromdate"] = dateFromController.text.trim();
      body["todate"] = dateToController.text.trim();
    } else {
      if (dateFromController.text.trim() == "" && dateToController.text.trim() != "") {
        errDateFrom.value = "Enter from Date";
        return;
      }
      if (dateFromController.text.trim() != "" && dateToController.text.trim() == "") {
        errDateTo.value = "Enter To Date";
        return;
      }
    }
    Get.back();
    print(body.length);
    if (body.length > 4) {
      selectedIconNumber.value = 4;
      LoadingScreen.show();
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
      LoadingScreen.dismiss();
      if (resp != "") {
        var jsonResp = jsonDecode(resp);
        if (jsonResp['result']['message'].toString() == "success") {
          var taskList = jsonResp['result']['completedtasks'];
          completed_activeList.clear();
          for (var item in taskList) {
            PendingListModel activeListModel = PendingListModel.fromJson(item);
            completed_activeList.add(activeListModel);
          }
          if (completed_activeList.length == 0) {
            completed_activeList.value = activeList_Main;
            Get.snackbar("Oops!", "No details found!",
                duration: Duration(seconds: 1),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white);
          }
          needRefresh.value = true;
        }
      }
    }
  }

  void removeFilter() {
    dateFromController.text =
        dateToController.text = searchTextController.text = processNameController.text = fromUserController.text = "";
    if (selectedIconNumber != 1) getNoOfCompletedActiveTasks();
    selectedIconNumber.value = 1;
  }

  errText(String value) {
    if (value == "")
      return null;
    else
      return value;
  }

  void refreshList() async {
    LoadingScreen.show();
    if (selectedIconNumber.value != 1) {
      await getNoOfCompletedActiveTasks();
    }
    selectedIconNumber.value = 1;

    Future.delayed(Duration(milliseconds: 500), () {
      LoadingScreen.dismiss();
    });
  }
}
