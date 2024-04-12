import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Models/MenuItemModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/InternetConnectivity.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_icons_named/material_icons_named.dart';

class MenuMorePageController extends GetxController {
  InternetConnectivity internetConnectivity = Get.find();
  var needRefresh = true.obs;
  TextEditingController searchController = TextEditingController();
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  List<MenuItemModel> menuListMain = [];
  Set menuHeadersMain = {}; //master
  var finalMenuHeader; //master
  var headingWiseData = {}; //map  //Master
  var finalHeadingWiseData = {}; //map  //Master

  var fetchData = {}.obs;
  var fetchList = [].obs;
  var colorList = [
    HexColor("#63168F"),
    HexColor("#081F4D"),
    HexColor("#038387"),
    HexColor("#FF781E"),
    HexColor("#6264A7"),
    HexColor("#98B5CD"),
    HexColor("#6264A7"),
    HexColor("#8C193F"),
  ];
  var IconList = [
    Icons.calendar_month_outlined,
    Icons.today_outlined,
    Icons.date_range_outlined,
    Icons.event_repeat_outlined,
    Icons.perm_contact_calendar_outlined,
    Icons.event_note_outlined,
    Icons.event_available_outlined,
    Icons.event_busy_outlined,
  ];

  MenuMorePageController() {
    print("-----------MenuMorePageController Called-------------");
    getMenuList();
  }

  getMenuList() async {
    var mUrl = Const.getFullARMUrl(ServerConnections.API_GET_MENU);
    var conectBody = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var menuResp = await serverConnections.postToServer(url: mUrl, body: jsonEncode(conectBody), isBearer: true);
    if (menuResp != "") {
      var menuJson = jsonDecode(menuResp);
      if (menuJson['result']['success'].toString() == "true") {
        for (var menuItem in menuJson['result']["pages"]) {
          MenuItemModel mi = MenuItemModel.fromJson(menuItem);
          menuListMain.add(mi);
        }
      }
    }
    menuListMain..sort((a, b) => a.rootnode.toString().toLowerCase().compareTo(b.rootnode.toString().toLowerCase()));
    reOrganise(menuListMain, firstCall: true);
  }

  reOrganise(menuList, {firstCall = false}) {
    menuHeadersMain.clear();
    headingWiseData.clear();
    for (var item in menuList) {
      var rootNode = item.rootnode == "" ? "Home" : item.rootnode;
      if (item.caption.toString() == "") item.caption = "No Name";
      menuHeadersMain.add(rootNode);
      List<MenuItemModel> list = [];
      list = headingWiseData[rootNode] ?? [];
      list.add(item);
      list..sort((a, b) => a.caption.toString().toLowerCase().compareTo(b.caption.toString().toLowerCase()));
      headingWiseData[rootNode] = list;
      if (firstCall) {
        List<MenuItemModel> list2 = [];
        list2 = finalHeadingWiseData[rootNode] ?? [];
        list2.add(item);
        list2..sort((a, b) => a.caption.toString().toLowerCase().compareTo(b.caption.toString().toLowerCase()));
        finalHeadingWiseData[rootNode] = list2;
      }
    }
    //create for display
    fetchList.value = menuHeadersMain.toList();
    fetchData.value = headingWiseData;
    if (firstCall) {
      finalMenuHeader = menuHeadersMain.toList();
    }
  }

  getSubmenuItemList(int mainIndex) {
    return headingWiseData[menuHeadersMain.toList()[mainIndex]];
  }

  filterList(value) {
    value = value.toString().trim();
    needRefresh.value = true;
    if (value == "")
      reOrganise(menuListMain);
    else {
      needRefresh.value = true;
      var newList = menuListMain.where((oldValue) {
        return oldValue.caption.toString().toLowerCase().contains(value.toString().toLowerCase());
      });
      // print("new list: " + newList.length.toString());
      reOrganise(newList);
    }
  }

  futureBuilder() async {
    // await Future.delayed(Duration(microseconds: 2));
    // reOrganise(menuListMain)
    return fetchList;
  }

  clearCalled() {
    searchController.text = "";
    filterList("");
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void openItemClick(MenuItemModel itemModel) async {
    if (await internetConnectivity.connectionStatus) {
      if (itemModel.url != "") {
        // menuHomePageController.webUrl = Const.getFullProjectUrl(itemModel.url);
        // menuHomePageController.switchPage.value = true;
        Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullProjectUrl(itemModel.url)]);
      }
    }
  }

  IconData? generateIcon(MenuItemModel subMenu, index) {
    var iconName = subMenu.icon;

    if (iconName.contains("material-icons")) {
      iconName = iconName.replaceAll("|material-icons", "");
      return materialIcons[iconName];
    } else {
      switch (subMenu.pagetype.trim().toUpperCase()[0]) {
        case "T":
          return Icons.assignment;
        case "I":
          return Icons.view_list;
        case "W":
        case "H":
          return Icons.code;
        default:
          return IconList[index++ % 8];
      }
    }
    return IconList[index++ % 8];
    if (iconName.contains(".png")) {
      return null;
    }
    switch (subMenu.type.toUpperCase()) {
      case "T":
        return null;
      case "P":
        return null;
      case "I":
        return null;
      case "H":
        return null;
      default:
        return null;
    }

    return null;
  }
}
