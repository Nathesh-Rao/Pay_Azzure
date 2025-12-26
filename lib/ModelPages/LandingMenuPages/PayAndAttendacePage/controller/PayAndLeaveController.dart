import 'dart:async';
import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/announcement_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/leave_details_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/leave_history_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/leave_overview_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/off_days_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/payroll_overview_model.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:axpertflutter/Utils/ServerConnections/DataSourceServices.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/payroll_history_model.dart';

class PayAndLeaveController extends GetxController {
//PAYROLL DASHBOARD WIDGET----------------------------------
  var payrollOverviewLoading = false.obs;
  var payDivisionsValue = RxList<double>();
  var netpay = ''.obs;
  var payrollHistoryList = RxList<PayrollHistoryModel>();
  var isAmountVisible = false.obs;

  RxList<PayBreakup> payBreakupList = <PayBreakup>[].obs;

  getPayrollOverviewDetails() async {
    payBreakupList.value = [];
    payrollOverviewLoading.value = true;

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": "DS_GETPAYBREAKUP",
      "sqlParams": {
        "arv_companycode": globalVariableController
            .currentEmployeeData!.arvCompanycodec
            .toString(),
        "arv_empmaid": globalVariableController.currentEmployeeData!.arvEmpmaidn
            .toString(),
        "username":
            globalVariableController.currentEmployeeData!.arvEmpidc.toString(),
        "arv_sfinyrcode": globalVariableController
            .currentEmployeeData!.arvSfinyrcodec
            .toString(),
        "arv_spayperiod": globalVariableController
            .currentEmployeeData!.arvSpayperiodc
            .toString(),
        "arv_branch":
            globalVariableController.currentEmployeeData!.arvBranchc.toString()
      }
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        payBreakupList.clear();
        for (var item in dsDataList) {
          try {
            var pay = PayBreakup.fromJson(item);
            if (pay.name.toLowerCase().contains("net")) {
              netpay.value = pay.amount.toString();
            }
            payBreakupList.add(pay);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    payDivisionsValue.value = calculateLeavePercentages(payBreakupList);
    payrollOverviewLoading.value = false;

    getPayrollHistory();
  }

  getPayrollHistory() {
    payrollHistoryList.value = PayrollHistoryModel.tempData;
  }

  List<double> calculateLeavePercentages(List<PayBreakup> breakups) {
    double totalLeaves = breakups.fold(0, (sum, item) => sum + item.amount);

    if (totalLeaves <= 0) {
      throw ArgumentError("Total leaves must be greater than zero");
    }

    return breakups.map((item) {
      return (item.amount / totalLeaves) * 100;
    }).toList();
  }

//NEWS AND EVENT DASHBOARD WIDGET----------------------------------
  var pageController = PageController();
  RxInt currentIndex = 0.obs;
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  // var announcementList = AnnouncementModel.tempData();
  RxList<AnnouncementModel> announcementList = <AnnouncementModel>[].obs;
  var isEventsLoading = false.obs;
  getInitialData() {
    _getAllEvents();
  }

  _getAllEvents() async {
    LogService.writeLog(message: "getAllEvents()");
    isEventsLoading.value = true;
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETALLEVENTS,
      "sqlParams": {
        // "username": globalVariableController.USER_NAME.value,
        "Month": DateUtilsHelper.getShortMonthName(
            DateTime.now().toString().split(" ")[0])
      }
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        announcementList.clear();
        for (var item in dsDataList) {
          try {
            var event = AnnouncementModel.fromJson(item);
            announcementList.add(event);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    isEventsLoading.value = false;

    LogService.writeLog(message: dsResp);
  }

  String getImageFromEventType(String eventTYpe) {
    if (eventTYpe.toLowerCase().contains("birthday")) {
      return "assets/images/bday2.jpg";
    }

    return 'assets/images/news1.jpg';
  }

  String getLottieFromEventType(String eventTYpe) {
    return 'assets/lotties/bday.json';
  }

//WORK CALENDAR WIDGET ----------------------------------
  var isOffDaysLoading = false.obs;
  var dateClicked = false.obs;
  var dateInfo = ''.obs;
  Timer? _timer;

  DateTime selectedDate = DateTime.now();

  List<OffDaysModel> offDaysList = [];
  Map<DateTime, String> karnatakaHolidays = {};

  Map<DateTime, int> calendarMap = {
    ...generateWeekendData(DateTime.now().year, 1),
  };
  initializeOffDays() async {
    if (karnatakaHolidays.isNotEmpty) return;
    isOffDaysLoading.value = true;
    offDaysList = [];
    offDaysList = await getAllOffDays();
    _parseOffDaysList();
    isOffDaysLoading.value = false;
  }

  Future<List<OffDaysModel>> getAllOffDays() async {
    List<OffDaysModel> offDaysList = [];

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETOFFDAYS,
      "sqlParams": {"year": "2025"}
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        try {
          for (var i in dsDataList) {
            offDaysList.add(OffDaysModel.fromJson(i));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }

    return offDaysList;
  }

  DateTime parseDate(String dateString) {
    final parts = dateString.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid date format, expected dd-MM-yyyy');
    }

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

  static Map<DateTime, int> generateWeekendData(int year, int value) {
    final Map<DateTime, int> weekendData = {};
    DateTime date = DateTime(year, 1, 1);

    while (date.year == year) {
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        weekendData[DateTime(date.year, date.month, date.day)] = value;
      }
      date = date.add(const Duration(days: 1));
    }

    return weekendData;
  }

  onDateClick(DateTime value, {bool cancelTimer = false}) {
    selectedDate = value;

    if (karnatakaHolidays[value] == null) {
      dateClicked.value = false;
      _timer!.cancel();
      return;
    }

    if (dateClicked.value && cancelTimer) {
      dateClicked.value = false;
      _timer!.cancel();
      return;
    }

    dateClicked.value = true;
    dateInfo.value = karnatakaHolidays[value] ??
        "Nothing for ${DateUtilsHelper.getTodayFormattedDateMD()} try some other date";
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(seconds: 3), () {
      dateClicked.value = false;
    });
  }

  void _parseOffDaysList() {
    karnatakaHolidays.clear();
    calendarMap.clear();

    for (final offDay in offDaysList) {
      final date = offDay.toDateTime();

      karnatakaHolidays[date] = offDay.event;
      calendarMap[date] =
          3; // 3 is your “holiday” color intensity or marker value
    }

    // Optionally add weekends
    calendarMap.addAll(generateWeekendData(2025, 1));
  }

//Leave Details WIDGET ----------------------------------

  var isLeaveDetailsLoading = false.obs;
  var isLeaveOverviewLoading = false.obs;
  var isLeaveHistoryLoading = false.obs;

  var leaveHistoryList = RxList<LeaveHistoryModel>();
  var leaveCountRatio = 0.0.obs;
  var leaveDivisionsValue = RxList<double>();

  var leaveOverviewList = RxList<LeaveOverviewModel>();
  var leaveDetailsList = RxList<LeaveDetailsModel>();
  var totalLeaveTakenCount = 0.obs;
  var totalLeaveRemainingCount = 0.obs;

  initializeLeaveData() async {
    await _getLeaveOverview();
    await _getLeaveDetails();
  }

  Future<void> _getLeaveOverview() async {
    isLeaveOverviewLoading.value = true;

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETLEAVEOVERVIEW,
      "sqlParams": {"username": globalVariableController.USER_NAME.value}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        leaveOverviewList.clear();
        for (var item in dsDataList) {
          try {
            var event = LeaveOverviewModel.fromJson(item);
            leaveOverviewList.add(event);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    isLeaveOverviewLoading.value = false;
  }

  _setLeaveCountRatio() {
    totalLeaveTakenCount.value = 0;
    int totalLeaves =
        leaveDetailsList.fold(0, (sum, item) => sum + item.totalLeaves.toInt());

    int totalLeavesTaken = totalLeaveTakenCount.value =
        leaveDetailsList.fold(0, (sum, item) => sum + item.leavesTaken.toInt());
    totalLeaveRemainingCount.value = totalLeaves - totalLeavesTaken;
    if (totalLeaves == 0) {
      leaveCountRatio.value = 0;
    } else {
      leaveCountRatio.value = (totalLeaves - totalLeavesTaken) / totalLeaves;
    }
  }

  _getLeaveDetails() async {
    isLeaveDetailsLoading.value = true;

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETLEAVEDETAILS,
      "sqlParams": {"username": globalVariableController.USER_NAME.value}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        leaveDetailsList.clear();
        for (var item in dsDataList) {
          try {
            var event = LeaveDetailsModel.fromJson(item);
            leaveDetailsList.add(event);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    leaveDivisionsValue.value = calculateLeaveInfoPercentages();
    _setLeaveCountRatio();
    isLeaveDetailsLoading.value = false;
  }

  List<double> calculateLeaveInfoPercentages() {
    int totalLeaves =
        leaveDetailsList.fold(0, (sum, item) => sum + item.totalLeaves.toInt());

    if (totalLeaves <= 0) {
      // throw ArgumentError("Total leaves must be greater than zero");
    }

    return leaveDetailsList.map((item) {
      final remaining = item.totalLeaves - item.leavesTaken;
      return (remaining / totalLeaves) * 100;
    }).toList();
  }

  getLeaveHistory() async {
    // if (leaveHistoryList.isNotEmpty) return;
    isLeaveHistoryLoading.value = true;
    LogService.writeLog(message: "_getAllUserNames()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETLEAVEHISTORY,
      "sqlParams": {"username": globalVariableController.USER_NAME.value}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        leaveHistoryList.value = [];
        var dsDataList = jsonDSResp['result']['data'];

        List<LeaveHistoryModel> temLeaveHistoryList = [];

        for (var item in dsDataList) {
          try {
            if (item != null) {
              temLeaveHistoryList.add(LeaveHistoryModel.fromJson(item));
            }
          } catch (e) {
            debugPrint(" $e");
          }
        }

        leaveHistoryList.value = temLeaveHistoryList;
      }
    }

    isLeaveHistoryLoading.value = false;
  }

  Color getLeaveProgressColor(double progress) {
    if (progress >= 0.75) {
      return Colors.green;
    } else if (progress >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color getColorByLeaveType(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'annual leave':
        return Colors.blue;
      case 'sick leave':
        return Colors.red;
      case 'casual leave':
        return Colors.orange;
      case 'maternity leave':
        return Colors.pink;
      case 'paternity leave':
        return Colors.green;
      case 'earned leave':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getIconByLeaveType(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'annual leave':
        return Icons.beach_access;
      case 'sick leave':
        return Icons.healing;
      case 'casual leave':
        return Icons.weekend;
      case 'maternity leave':
        return Icons.child_friendly;
      case 'paternity leave':
        return Icons.family_restroom;
      case 'earned leave':
        return Icons.family_restroom;
      default:
        return Icons.event_note;
    }
  }

  Color getColorByLeaveStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getIconByLeaveStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  void applyForLeave() {
    // var url =
    //     "https://agileqa.agilecloud.biz/qaaxpert11.4base/aspx/AxMain.aspx?authKey=AXPERT-ARM-agilespaceqanew-8ca1f55c-3e6e-4526-bd55-460ca6d27ec6&pname=tLeave";

    // webviewController.openWebView(url: url);
  }

  List<Color> getColorList() {
    List<Color> colorList = List.generate(
        leaveDetailsList.length, (index) => MyColors.getNextColor());
    MyColors.resetColorIndex();
    return colorList;
  }
}
