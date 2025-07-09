import 'dart:collection';
import 'dart:convert';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Models/MenuItemModel.dart';
import 'package:axpertflutter/Utils/ServerConnections/InternetConnectivity.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_icons_named/material_icons_named.dart';

class MenuMorePageController extends GetxController {
  InternetConnectivity internetConnectivity = Get.find();
  var needRefresh = true.obs;
  var menu_finalList = [].obs;
  var searchList = [].obs;
  TextEditingController searchController = TextEditingController();
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  List<MenuItemModel> menuListMain = [];
  List<MenuItemNewmModel> menuListMain_new = [];
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
    getMenuList_v2();
    //getMenuList();
  }

  getMenuList() async {
    var mUrl = Const.getFullARMUrl(ServerConnections.API_GET_MENU);
    var conectBody = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var menuResp = await serverConnections.postToServer(url: mUrl, body: jsonEncode(conectBody), isBearer: true);
    if (menuResp != "") {
      print("menuResp ${menuResp}");
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

  clearField_searchBar() {
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void openItemClick(itemModel) async {
    if (await internetConnectivity.connectionStatus) {
      if (itemModel.url != "") {
        // menuHomePageController.webUrl = Const.getFullProjectUrl(itemModel.url);
        // menuHomePageController.switchPage.value = true;
        Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullWebUrl(itemModel.url)]);
      }
    }
  }

  IconData? generateIcon(subMenu, index) {
    var iconName = subMenu.icon;

    if (iconName.contains("material-icons")) {
      iconName = iconName.replaceAll("|material-icons", "");
      return materialIcons[iconName];
    } else {
      switch (subMenu.pagetype.trim() != "" ? subMenu.pagetype.trim().toUpperCase()[0] : subMenu.pagetype.trim()) {
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

  void getMenuList_v2() async {
    print("getMenuList_v2_called");
    var mUrl = Const.getFullARMUrl(ServerConnections.API_GET_MENU_V2);
    var conectBody = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var menuResp = await serverConnections.postToServer(url: mUrl, body: jsonEncode(conectBody), isBearer: true);
    if (menuResp != "") {
      print("menuResp ${menuResp}");
      var menuJson = jsonDecode(menuResp);
      if (menuJson['result']['success'].toString() == "true") {
        for (var menuItem in menuJson['result']["data"]) {
          try {
            MenuItemNewmModel mi = MenuItemNewmModel.fromJson(menuItem);
            menuListMain_new.add(mi);
          } catch (e) {}
        }
      }
    }
    reOrganise_v2(menuListMain_new);
  }

  void reOrganise_v2(menuList) {
    var heada_ParentList = {};
    var map_menulist = {};
    for (var item in menuList) {
      var parent = item.parent;
      if (parent != "") {
        heada_ParentList[item.name] = parent;
        String parent_tree = getParent_hierarchy(heada_ParentList, item.name);
        item.parent_tree = parent_tree;
      }
      map_menulist[item.name] = item;
    }

    var keysToRemove = <String>[];

    //To get the parent tree reverse the Map
    final reverseM = LinkedHashMap.fromEntries(map_menulist.entries.toList().reversed);
    reverseM.forEach((key, value) {
      try {
        MenuItemNewmModel md = value;
        var parent = md.parent;
        if (parent != "") {
          reverseM[parent].childList.insert(0, md);
          keysToRemove.add(key);
        }
      } catch (e) {
        print(e);
      }
    });

    //Remove the record that was added to its parent.
    keysToRemove.forEach((key) => reverseM.remove(key));

    // Once again reverse the Map to get the actual order.
    final map_finalList = LinkedHashMap.fromEntries(reverseM.entries.toList().reversed);

    // Add the Map value to List
    List<MenuItemNewmModel> newList = [];
    map_finalList.forEach((k, v) => newList.add(v as MenuItemNewmModel));
    menu_finalList.value = newList;
  }

  String getParent_hierarchy(Map heada_parentList, String name) {
    String parent_tree = "";
    String parent = heada_parentList[name];
    while (parent != "") {
      parent_tree += parent_tree == "" ? parent : "~" + parent;
      parent = heada_parentList[parent] ?? "";
    }
    return parent_tree;
  }

  filter_search(value) {
    return menuListMain_new.where((oldValue) {
      return oldValue.url != "" && oldValue.caption.toString().toLowerCase().contains(value.toString().toLowerCase());
    }).toList();
  }

  getSuffixIcon_searchBar() {
    return ValueListenableBuilder(
      valueListenable: searchController,
      builder: (_, value, ___) {
        if (value.text.isNotEmpty) {
          return IconButton(
            onPressed: () => clearField_searchBar(), //searchController.clear(),
            icon: Icon(
              Icons.clear,
              color: HexColor("#8E8E8EA3"),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
