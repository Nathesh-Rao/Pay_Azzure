import 'dart:convert';

import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/UpdatedActiveTaskListModel/ActiveTaskListModel.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../Constants/AppStorage.dart';
import '../../../../../Constants/CommonMethods.dart';
import '../../../../../Constants/Const.dart';
import '../../../../../Constants/MyColors.dart';
import '../../../../../Constants/Routes.dart';
import '../../../../../Utils/ServerConnections/ServerConnections.dart';
import '../ListItemDetailsController.dart';

class ActiveTaskListController extends GetxController {
  //----
  ListItemDetailsController listItemDetailsController = Get.put(ListItemDetailsController());
  // PendingListController
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  var body = {};
  var url = Const.getFullARMUrl(ServerConnections.API_GET_ALL_ACTIVE_TASKS);
  //----
  int pageNumber = 1;
  static const int pageSize = 40;
  var isListLoading = false.obs;
  var hasMoreData = true.obs;
  var isRefreshable = true.obs;
  var showFetchInfo = false.obs;
  var activeTaskList = [].obs;

  List<ActiveTaskListModel> activeTempList = [];
  //--------
  //--------
  var activeTaskMap = {}.obs;
  var taskSearchText = ''.obs;
  TextEditingController searchTextController = TextEditingController();
  //-----
  late ScrollController taskListScrollController;
  late List<ExpandedTileController> expandedListControllers;
  //-----
  var isFilterOn = false.obs;
  TextEditingController processNameController = TextEditingController();
  TextEditingController fromUserController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  var errDateFrom = ''.obs;
  var errDateTo = ''.obs;
  //-----
  @override
  void onInit() {
    taskListScrollController = ScrollController();
    taskListScrollController.addListener(() {
      if (taskListScrollController.position.pixels >= taskListScrollController.position.minScrollExtent + 100) {
        isRefreshable.value = false;
      } else {
        isRefreshable.value = true;
      }

      if (taskListScrollController.position.pixels >= taskListScrollController.position.maxScrollExtent &&
          !isListLoading.value &&
          hasMoreData.value) {
        fetchActiveTaskLists();
      }

      if (taskListScrollController.position.pixels >= taskListScrollController.position.maxScrollExtent - 100 &&
          !hasMoreData.value) {
        showFetchInfo.value = true;
      } else {
        showFetchInfo.value = false;
      }
      ;
    });

    super.onInit();
  }

  init() {
    if (activeTaskList.isEmpty) {
      hasMoreData.value = true;
      fetchActiveTaskLists();
    }
    ;
  }

  refreshList() {
    pageNumber = 1;
    hasMoreData.value = true;
    taskListScrollController
        .animateTo(taskListScrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 700), curve: Curves.decelerate)
        .then((_) {
      fetchActiveTaskLists(isRefresh: true);
    });
  }

  prepAPI({required int pageNo, required int pageSize}) {
    body = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      "AxSessionId": "meecdkr3rfj4dg5g4131xxrt",
      "AppName": appStorage.retrieveValue(AppStorage.PROJECT_NAME), //Const.PROJECT_NAME.toString(),
      "Trace": "false",
      "PageSize": pageSize,
      "PageNo": pageNo,
      "Filter": "all"
    };
  }

  Future<void> fetchActiveTaskLists({bool isRefresh = false}) async {
    if (!hasMoreData.value) return;
    LogService.writeLog(message: " fetchActiveTaskLists() => started");
    isListLoading.value = true;
    activeTempList = [];
    prepAPI(pageNo: pageNumber, pageSize: pageSize);
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(body), isBearer: true);

    if (resp != "") {
      var jsonResp = jsonDecode(resp);

      if (jsonResp['result']['message'].toString().toLowerCase() == "success") {
        var activeList = jsonResp['result']['tasks'];

        for (var item in activeList) {
          ActiveTaskListModel activeListModel = ActiveTaskListModel.fromJson(item);
          activeTempList.add(activeListModel);
        }
      }
      if (activeTempList.isEmpty) {
        hasMoreData.value = false;
      } else {
        if (isRefresh) {
          activeTaskList.clear();
          activeTaskMap.value = {};
        }
        LogService.writeLog(message: "PageNumber: $pageNumber, PageSize: $pageSize, currentLength: ${activeTaskList.length}");

        activeTaskList.addAll(activeTempList);
        //-----------------------------------------
        _parseTaskMap();
        //----------------------------------------

        //----------------------------------------

        pageNumber++;
      }
    }

    isListLoading.value = false;
  }

  //search
  searchTask(String searchText) {
    taskSearchText.value = searchText;
    _parseTaskMap();
  }

  clearSearch() {
    if (Get.context != null) FocusScope.of(Get.context!).unfocus();
    searchTextController.clear();
    taskSearchText.value = '';
    _parseTaskMap();
  }

  _parseTaskMap() {
    activeTaskMap.value = {};
    // var filteredList = activeTaskList
    //     .where((t) => t.processname.toString().toLowerCase().contains(processNameController.text.toString().toLowerCase()))
    //     .toList();
    var filteredList = activeTaskList.where((t) => _filterTasks(t)).toList();
    for (var t in filteredList) {
      if (taskSearchText.value.isEmpty ||
          t.displaytitle.toString().toLowerCase().contains(taskSearchText.value.toString().toLowerCase()) ||
          t.displaycontent.toString().toLowerCase().contains(taskSearchText.value.toString().toLowerCase())) {
        activeTaskMap.putIfAbsent(categorizeDate(t.eventdatetime.toString()), () => []).add(t);
      }
    }
  }

  bool _filterTasks(ActiveTaskListModel task) {
    String processName = processNameController.text.trim().toLowerCase();
    String fromUser = fromUserController.text.trim().toLowerCase();
    String startDate = dateFromController.text.trim();
    String endDate = dateToController.text.trim();

    if (processName.isEmpty && fromUser.isEmpty && startDate.isEmpty && endDate.isEmpty) {
      isFilterOn.value = false;
      return true;
    } else {
      isFilterOn.value = true;
    }

    bool matchesProcess = processName.isEmpty || task.processname.toString().toLowerCase().contains(processName);
    bool matchesUser = fromUser.isEmpty || task.fromuser.toString().toLowerCase().contains(fromUser);
    bool matchesDate = true;

    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      DateTime taskDate = DateFormat("dd/MM/yyyy HH:mm:ss").parse(task.eventdatetime.toString());
      DateTime start = DateFormat("dd-MMM-yyyy").parse(startDate);
      DateTime end = DateFormat("dd-MMM-yyyy").parse(endDate);
      matchesDate = taskDate.isAfter(start) && taskDate.isBefore(end);
    }

    return matchesProcess && matchesUser && matchesDate;
  }

  String formatToDayTime(String dateString) {
    DateTime inputDate = DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateString);
    String category = categorizeDate(dateString);

    if (category == "Today" || category == "Yesterday") {
      return DateFormat('h:mm a').format(inputDate);
    } else if (category == "This Week" || category == "Last Week") {
      return DateFormat('E d').format(inputDate);
    } else {
      return DateFormat('E M/yy').format(inputDate);
    }
  }

  String categorizeDate(String dateString) {
    DateTime inputDate = DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateString);
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime lastWeekStart = startOfWeek.subtract(Duration(days: 7));
    DateTime lastWeekEnd = startOfWeek.subtract(Duration(days: 1));

    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastMonthStart = DateTime(now.year, now.month - 1, 1);
    DateTime lastMonthEnd = startOfMonth.subtract(Duration(days: 1));

    if (inputDate.isAfter(today)) {
      return "Today";
    } else if (inputDate.isAfter(yesterday)) {
      return "Yesterday";
    } else if (inputDate.isAfter(startOfWeek)) {
      return "This Week";
    } else if (inputDate.isAfter(lastWeekStart) && inputDate.isBefore(lastWeekEnd)) {
      return "Last Week";
    } else if (inputDate.isAfter(startOfMonth)) {
      return "This Month";
    } else if (inputDate.isAfter(lastMonthStart) && inputDate.isBefore(lastMonthEnd)) {
      return "Last Month";
    } else {
      return DateFormat('MMM yyyy').format(inputDate);
    }
  }

//--
  List<TextSpan> formatDateTimeSpan(String formattedDate) {
    final regex = RegExp(r'(\d{1,2}:\d{2})\s?(AM|PM)');
    final match = regex.firstMatch(formattedDate);

    if (match != null) {
      String timePart = match.group(1)!;
      String amPmPart = match.group(2)!;
      String prefix = formattedDate.replaceAll(match.group(0)!, '').trim();

      return [
        TextSpan(text: '$prefix '),
        TextSpan(text: timePart),
        TextSpan(
          text: ' $amPmPart',
          style: GoogleFonts.poppins(
            fontSize: 8,
            color: MyColors.grey9,
            // color: Color(0xff666D80),
            fontWeight: FontWeight.w600,
          ),
        ),
      ];
    } else {
      return [
        TextSpan(
          text: formattedDate,
        )
      ];
    }
  }

  //---
  Widget highlightedText(String text, TextStyle style, {bool isTitle = false}) {
    if (taskSearchText.value.isEmpty)
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: isTitle ? 1 : 2,
      );

    final index = text.toLowerCase().indexOf(taskSearchText.value.toLowerCase());
    if (index == -1)
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: isTitle ? 1 : 2,
      );

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: isTitle ? 1 : 2,
      text: TextSpan(
        style: style.copyWith(color: Colors.black),
        children: [
          TextSpan(
            text: text.substring(0, index),
          ),
          TextSpan(
            text: text.substring(index, index + taskSearchText.value.length),
            style: TextStyle(color: MyColors.red, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(index + taskSearchText.value.length)),
        ],
      ),
    );
  }

  //---------------------------------------

  void onTaskClick(ActiveTaskListModel task) async {
    var pendingModel = task.toPendingListModel();

    print(pendingModel.tasktype);
    switch (pendingModel.tasktype.toString().toUpperCase()) {
      case "MAKE":
        var URL = CommonMethods.activeList_CreateURL_MAKE(pendingModel);
        if (!URL.isEmpty) Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullWebUrl(URL)]);
        break;
      // break;
      case "CHECK":
      case "APPROVE":
        listItemDetailsController.openModel = pendingModel;

        print("Going to active details page");
        //listItemDetailsController.fetchDetails();
        await Get.toNamed(Routes.ProjectListingPageDetails);
        print("returned from active details page");
        refreshList();

        ;
        break;
      case "":
      case "NULL":
      case "CACHED SAVE":
        var URL = CommonMethods.activeList_CreateURL_MESSAGE(pendingModel);
        if (!URL.isEmpty)
          Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullWebUrl(URL)])?.then((_) {
            pageNumber--;
            _parseTaskMap();
          });
        break;
      default:
        break;
    }
  }

  openFilterPrompt() {
    print("Filter prompt");
    Get.dialog(showFilterDialog());
  }

  removeFilter() {
    processNameController.text = fromUserController.text = dateFromController.text = dateToController.text = '';
    errDateFrom.value = errDateTo.value = '';

    _parseTaskMap();
  }

  Widget showFilterDialog() {
    errDateFrom.value = errDateTo.value = '';
    return Obx(() => GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Filter results",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 10), height: 1, color: Colors.grey.withOpacity(0.6)),
                    SizedBox(height: 20),
                    TextField(
                      controller: processNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                          suffix: GestureDetector(
                              onTap: () {
                                processNameController.text = "";
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Container(
                                child: Text("X"),
                              )),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          hintText: "Process Name "),
                    ),
                    Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold)))),
                    TextField(
                      controller: fromUserController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                          suffix: GestureDetector(
                              onTap: () {
                                fromUserController.text = "";
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Container(
                                child: Text("X"),
                              )),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          hintText: "From User "),
                    ),
                    Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold)))),
                    TextField(
                      controller: dateFromController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                          suffix: GestureDetector(
                              onTap: () {
                                dateFromController.text = "";
                              },
                              child: Container(
                                child: Text("X"),
                              )),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          errorText: errText(errDateFrom.value),
                          hintText: "From Date: DD-MMM-YYYY "),
                      canRequestFocus: false,
                      onTap: () {
                        selectDate(Get.context!, dateFromController);
                      },
                      enableInteractiveSelection: false,
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: dateToController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                          suffix: GestureDetector(
                              onTap: () {
                                dateToController.text = "";
                              },
                              child: Container(
                                child: Text("X"),
                              )),
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                          errorText: errText(errDateTo.value),
                          hintText: "To Date: DD-MMM-YYYY"),
                      canRequestFocus: false,
                      enableInteractiveSelection: false,
                      onTap: () {
                        selectDate(Get.context!, dateToController);
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              removeFilter();
                              Get.back();
                            },
                            child: Text("Reset")),
                        ElevatedButton(
                            onPressed: () {
                              _parseTaskMap();
                              Get.back();
                            },
                            child: Text("Filter"))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  errText(String value) {
    if (value == "")
      return null;
    else
      return value;
  }

  void selectDate(BuildContext context, TextEditingController text) async {
    FocusManager.instance.primaryFocus?.unfocus();
    const months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1990), lastDate: DateTime.now());
    if (picked != null)
      text.text =
          picked.day.toString().padLeft(2, '0') + "-" + months[picked.month - 1] + "-" + picked.year.toString().padLeft(2, '0');
  }
}
