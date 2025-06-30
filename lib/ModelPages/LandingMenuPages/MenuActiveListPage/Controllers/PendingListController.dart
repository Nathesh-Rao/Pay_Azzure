import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/GlobalVariableController.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/BulkApprovalCountModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/PendingListModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Utils/LogServices/LogService.dart';

class PendingListController extends GetxController {
  final globalVariableController = Get.find<GlobalVariableController>();
  var subPage = true.obs;
  var needRefresh = true.obs;
  var pending_activeList = [].obs;
  var bulkApprovalCount_list = [].obs;
  var bulkApproval_activeList = [].obs;
  var pendingCount = "0";
  var isLoading = false.obs;

  var selectedIconNumber = 1.obs; //1->default, 2-> reload, 3->accesstime, 4-> filter, 5=> checklist
  var isBulkAppr_SelectAll = false.obs;

  // PendingTaskModel? pendingTaskModel;
  List<PendingListModel> activeList_Main = [];

  // PendingListModel? openModel;
  // String selectedTaskID = "";
  // var processFlowList = [].obs;
  TextEditingController searchController = TextEditingController();
  var statusListActiveIndex = 2;

  // ScrollController scrollController = ScrollController(initialScrollOffset: 100 * 3.0);
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();

  // var widgetProcessFlowNeedRefresh = true.obs;

  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController processNameController = TextEditingController();
  TextEditingController fromUserController = TextEditingController();
  var errDateFrom = "".obs;
  var errDateTo = "".obs;

  PendingListController() {
    // print("-----------PendingListController Called-------------");
    getNoOfPendingActiveTasks();
    // getPendingActiveList();
    getBulkApprovalCount();
    //getBulkActiveTasks("PEG");
  }

  Future<void> getNoOfPendingActiveTasks() async {
    LoadingScreen.show();
    isLoading.value = true;
    var url = Const.getFullARMUrl(ServerConnections.API_GET_PENDING_ACTIVETASK_COUNT);
    var body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        pendingCount = jsonResp['result']['data'].toString();
      }
      await getPendingActiveList();
    }
    isLoading.value = false;
    LoadingScreen.dismiss();
  }

  Future<void> getPendingActiveList() async {
    var url = Const.getFullARMUrl(ServerConnections.API_GET_PENDING_ACTIVETASK);
    var body = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      "Trace": "false",
      "AppName": globalVariableController.PROJECT_NAME.value.toString(),
      "pagesize": double.parse(pendingCount).toInt(),
      "pageno": 1,
    };

    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      print(jsonResp);
      if (jsonResp['result']['message'].toString() == "success") {
        activeList_Main.clear();
        var dataList = jsonResp['result']['pendingtasks'];

        for (var item in dataList) {
          PendingListModel pendingActiveListModel = PendingListModel.fromJson(item);
          activeList_Main.add(pendingActiveListModel);
        }
      }
      pending_activeList.value = activeList_Main;
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
      pending_activeList.value = activeList_Main;
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      needRefresh.value = true;
      var newList = activeList_Main.where((oldValue) {
        return oldValue.displaytitle.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
            oldValue.eventdatetime.toString().toLowerCase().contains(value.toString().toLowerCase());
      });
      // print("new list: " + newList.length.toString());
      pending_activeList.value = newList.toList();
    }
  }

  void clearCalled() {
    searchController.text = "";
    filterList("");
    FocusManager.instance.primaryFocus?.unfocus();
  }

  ////////////////////////************************** Pending List Item Details *****************

  void applyFilter() async {
    var url = Const.getFullARMUrl(ServerConnections.API_GET_FILTERED_PENDING_TASK);
    Map<String, dynamic> body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "AppName": globalVariableController.PROJECT_NAME.value.toString(),
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
          var taskList = jsonResp['result']['pendingtasks'];
          pending_activeList.clear();
          for (var item in taskList) {
            PendingListModel activeListModel = PendingListModel.fromJson(item);
            pending_activeList.add(activeListModel);
          }
          if (pending_activeList.length == 0) {
            pending_activeList.value = activeList_Main;
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
    if (selectedIconNumber != 1) getNoOfPendingActiveTasks();
    selectedIconNumber.value = 1;
  }

  errText(String value) {
    if (value == "")
      return null;
    else
      return value;
  }

  // void refreshList() async {
  //   LoadingScreen.show();
  //   if (selectedIconNumber.value != 1) {
  //     await getNoOfPendingActiveTasks();
  //   }
  //   selectedIconNumber.value = 1;
  //
  //   Future.delayed(Duration(milliseconds: 500), () {
  //     LoadingScreen.dismiss();
  //   });
  // }

  Future<void> getBulkApprovalCount() async {
    var url = Const.getFullARMUrl(ServerConnections.API_GET_BULK_APPROVAL_COUNT);
    var body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};

    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        bulkApprovalCount_list.clear();
        var dataList = jsonResp['result']['data'];
        LogService.writeLog(message: "getBulkApprovalCount=> $dataList");
        for (var item in dataList) {
          BulkApprovalCountModel bulkApprovalCountModel = BulkApprovalCountModel.fromJson(item);
          bulkApprovalCount_list.add(bulkApprovalCountModel);
        }
      }
    }
  }

  Future<void> getBulkActiveTasks(String? processname) async {
    bulkApproval_activeList.clear();
    isBulkAppr_SelectAll.value = false;
    var url = Const.getFullARMUrl(ServerConnections.API_GET_BULK_ACTIVETASKS);
    var body = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      "AppName": globalVariableController.PROJECT_NAME.value.toString(),
      "tasktype": "Approve",
      "processname": processname,
      "touser": appStorage.retrieveValue(AppStorage.USER_NAME)
    };

    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        var dataList = jsonResp['result']['data'];

        for (var item in dataList) {
          PendingListModel bulkApproval_activeTaskModel = PendingListModel.fromJson(item);
          bulkApproval_activeList.add(bulkApproval_activeTaskModel);
        }
      }
    }
  }

  selectAll_BulkApproveList_item(value) {
    isBulkAppr_SelectAll.value = value;
    for (var item in bulkApproval_activeList) {
      value == true ? item.bulkApprove_isSelected.value = true : item.bulkApprove_isSelected.value = false;
    }
  }

  onChange_BulkApprItem(index, value) {
    if (isBulkAppr_SelectAll.value == true) isBulkAppr_SelectAll.value = false;
    print("ON_TAP: $value");
    bulkApproval_activeList[index].bulkApprove_isSelected.value = value;
    bulkApproval_activeList.refresh();
  }

  TextEditingController bulkCommentController = TextEditingController();
  Future doBulkApprove() async {
    var list_taskId = "";
    for (var item in bulkApproval_activeList) {
      if (item.bulkApprove_isSelected.value == true)
        list_taskId.isEmpty ? list_taskId += item.taskid : list_taskId += "," + item.taskid;
    }

    print("list_taskId: $list_taskId");

    if (list_taskId.isEmpty) {
      Get.snackbar("Oops!", "Select atleast one task for approval.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
    } else if (bulkCommentController.text.isEmpty) {
      Get.snackbar("Comment is required", "Try again with proper Comment",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3));
    } else {
      var url = Const.getFullARMUrl(ServerConnections.API_POST_BULK_DO_BULK_ACTION);
      var body = {
        "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
        "AxSessionId": "lqkrqbrwa3v3c2nmhq1dm1sk",
        "Trace": "true",
        "TaskId": list_taskId,
        "taskType": "APPROVE",
        "action": "BULKAPPROVE",
        "statusText": bulkCommentController.text,
        "AppName": globalVariableController.PROJECT_NAME.value.toString(),
        "user": appStorage.retrieveValue(AppStorage.USER_NAME)
      };
      var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);

      print(resp);
      var jsonResp = jsonDecode(resp);
      // print(jsonResp['result']['success']);
      if (jsonResp["result"]["success"].toString() == "true") {
        Get.back();
        Get.snackbar("Bulk Approval success", "All ${list_taskId.split(",").length} tasks approved",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3));
      }
    }
  }
}
