import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Models/ChartCardModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:get/get.dart';

class MenuDashboardController extends GetxController {
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  List<ChartCardModel> chartList = [];

  MenuDashboardController() {
    fetchDataFromServer();
    print('Session: ${appStorage.retrieveValue(AppStorage.SESSIONID)}');
    print('Token: ${appStorage.retrieveValue(AppStorage.TOKEN)}');
  }

  fetchDataFromServer() async {
    LoadingScreen.show();
    var dBody = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var url = Const.getFullARMUrl(ServerConnections.API_GET_DASHBOARD_DATA);
    var resp = await serverConnections.postToServer(url: url, body: jsonEncode(dBody), isBearer: true);
    LoadingScreen.dismiss();
    if (resp.toString() != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString().toLowerCase() == "true") {
        var cards = jsonResp['result']['cards']['data'];
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
                  var jsonSqlData = jsonDecode(card['cardsql']);
                  var rows = jsonSqlData['row'];
                  List<ChartData> bar = [];
                  for (var eachData in rows) {
                    ChartData bmodel = ChartData.fromJson(eachData);
                    bar.add(bmodel);
                  }
                  if (validate(bar))
                    chartList.add(ChartCardModel(card['cardname'], card['cardtype'], card['charttype'], bar,
                        cardbgclr: card['cardbgclr'] ?? "null"));
                } catch (e) {}
                break;
            }
          }
        }
      }
    }
    // print("charts:");
    // print(chartData);
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
