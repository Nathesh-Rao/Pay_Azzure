import 'dart:convert';
import 'dart:ui';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Models/ChartCardModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:get/get.dart';

import '../../../../Constants/MyColors.dart';
import '../../../../Utils/LogServices/LogService.dart';
import '../../UpdatedHomePage/Models/UpdatedHomeCardDataModel.dart';
import '../../UpdatedHomePage/Widgets/UpdatedWidgets11.4/WidgetActivityList.dart';
import '../../UpdatedHomePage/Widgets/UpdatedWidgets11.4/WidgetBannerCard.dart';
import '../../UpdatedHomePage/Widgets/UpdatedWidgets11.4/WidgetKPIList.dart';
import '../../UpdatedHomePage/Widgets/UpdatedWidgets11.4/WidgetKPIPanelSlider.dart';
import '../../UpdatedHomePage/Widgets/UpdatedWidgets11.4/WidgetMenuIcons.dart';
import '../../UpdatedHomePage/Widgets/UpdatedWidgets11.4/WidgetNewsCard.dart';
import '../../UpdatedHomePage/Widgets/UpdatedWidgets11.4/WidgetTaskList.dart';

class MenuDashboardController extends GetxController {
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  RxList<ChartCardModel> chartList = <ChartCardModel>[].obs;
  var dashBoardWidgetList = [].obs;


  MenuDashboardController() {
    fetchDataFromServer();
    print('Session: ${appStorage.retrieveValue(AppStorage.SESSIONID)}');
    print('Token: ${appStorage.retrieveValue(AppStorage.TOKEN)}');
  }

  init(){

  }

  fetchDataFromServer() async {
    LoadingScreen.show();
    var url = Const.getFullARMUrl(ServerConnections.API_GET_CARDS_WITH_DATA);
    var getCardsBody = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "Trace": false,
      "HomePageCards": false,
      "RefreshData": false,
      "IsMobile": true
      /* "AppName": appStorage.retrieveValue(AppStorage.PROJECT_NAME),
      "Roles": "default",
      "UserName": appStorage.retrieveValue(AppStorage.USER_NAME),
      "AxSessionId": "jbxqzz5tie2y3yujshe3k1x5",
      "GlobalParams": ServerConnections.SAMPLE_GET_CARDS_WITH_DATA_GLOBAL_PARAMS*/
    };
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(getCardsBody), isBearer: true);
    /*var dBody = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var url = Const.getFullARMUrl(ServerConnections.API_GET_DASHBOARD_DATA);
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(dBody), isBearer: true);*/
    LoadingScreen.dismiss();
    if (resp.toString() != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString().toLowerCase() == "true") {
        //
        var cards = jsonResp['result']['data'];
        _UpdateDataLists(cards);
        for (var card in cards) {
          //cards
          if (card['cardtype'].toString().toLowerCase() == "chart" || card['cardtype'].toString().toLowerCase() == "kpi") {
            switch (card['charttype'].toString().toLowerCase()) {
              case 'bar':
              case 'stacked-bar':
              case 'donut':
              case 'semi-donut':
              case 'pie':
              case 'line':
              case 'column':
              case 'stacked-column':
              case 'stacked-percentage-column':
              case '':
                try {
                  var jsonSqlData = jsonDecode(card['carddata']);
                  //var rows = jsonSqlData['row'];
                  List<ChartData> bar = [];
                  for (var eachData in jsonSqlData) {
                    ChartData bmodel = ChartData.fromJson(eachData);
                    bar.add(bmodel);
                  }
                  if (validate(bar))
                    chartList.add(ChartCardModel(card['cardname'], card['cardtype'], card['charttype'], bar,
                        cardbgclr: card['cardbgclr'] ?? "null"));
                } catch (e) {
                  LogService.writeLog(message: "[ERROR] $e");
                }
                break;
            }
          }
        }
      }
    }
    // print("charts:");
    // print(chartData);
  }

  _UpdateDataLists(List dataList) {
    // _clearDataLists();
    List<UpdatedHomeCardDataModel> cardDataList = dataList.map((e) => UpdatedHomeCardDataModel.fromJson(e)).toList();

    for (var i in cardDataList) {
      if (i.carddata != null) {
        try {
          i.carddata = jsonDecode(i.carddata);
        } catch (e) {
          print(e);
        }
      }
    }

    _sortDataByPluginName(dataList: cardDataList);
  }

  _sortDataByPluginName({required List<UpdatedHomeCardDataModel> dataList}) {
    dashBoardWidgetList.clear();
    LogService.writeLog(message: "dataList-length\n${dataList.length}");

    for (var data in dataList) {
      if (data.carddata == null ||
          (data.carddata is List && data.carddata.isEmpty) ||
          (data.carddata is String && data.carddata.trim().isEmpty) ||
          (data.carddata is Map && data.carddata.isEmpty)) {
        continue;
      }
      switch (data.pluginname?.toUpperCase()) {
        case "BANNER CARD":
        // bannerCardData.add(data);
          LogService.writeLog(message: "${data.carddata}");
          dashBoardWidgetList.add(WidgetBannerCard1(cardModel: data));

          break;
        case "TASK LIST":
        // taskListData.add(data);
          dashBoardWidgetList.add(TaskListPanel(taskListData: data));
          break;
        case "NEWS CARD":
        // newsCardData.add(data);
          dashBoardWidgetList.add(NewsPanel(newsCardData: data));
          break;
        case "KPI LIST":
          if (data.cardname?.toUpperCase() == "KPI LIST") {
            // kpiSliderCardData.add(data);
            dashBoardWidgetList.add(WidgetKPIPanelSlider1(cardData: data.carddata));
          } else {
            // kpiListCardData.add(data);
            List<Color> colors = List.generate(data.carddata.length, (index) => MyColors.getRandomColor());
            dashBoardWidgetList.add(KPICardsPanel(card: data, colors: colors));
          }

          break;
        case "MENU ICONS":
        // menuIconsData.add(data);
          List<Color> colors = List.generate(data.carddata.length, (index) => MyColors.getRandomColor());
          dashBoardWidgetList.add(MenuIconsPanel(card: data, colors: colors));

          break;
        case "ACTIVITY LIST":
        // activityListData.add(data);
          List<Color> colors = List.generate(data.carddata.length, (index) => MyColors.getRandomColor());
          dashBoardWidgetList.add(ActivityListPanel(colors: colors, activityListData: data));

          break;
        default:
      }
    }
    // _initializeListSwitches();
  }
}

bool validate(List<dynamic> bar) {
  if (bar.isEmpty) return false;
  for (ChartData item in bar) {
    if (item.value.toLowerCase() == "-1") {
      return false;
    }
  }
  return true;
}
