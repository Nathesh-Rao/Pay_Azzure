import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/CompletedListController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/ListItemDetailsController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/PendingListPage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Widgets/WidgetCompletedListItem.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Widgets/WidgetDottedSeparator.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNoDataFound.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../Constants/CommonMethods.dart';

class CompletedListPage extends StatelessWidget {
  CompletedListPage({super.key});

  final CompletedListController completedListController = Get.put(CompletedListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (completedListController.needRefresh.value == true) {
        completedListController.needRefresh.toggle();
        return reBuild(completedListController, context);
      }
      return reBuild(completedListController, context);
    });
  }

  reBuild(CompletedListController completedListController, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: completedListController.searchController,
                  onChanged: completedListController.filterList,
                  decoration: InputDecoration(
                      prefixIcon: completedListController.searchController.text.toString() == ""
                          ? GestureDetector(child: Icon(Icons.search))
                          : GestureDetector(
                              onTap: () {
                                completedListController.clearCalled();
                              },
                              child: Icon(Icons.clear, color: HexColor("#8E8E8EA3")),
                            ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: "Search",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 1))),
                ),
              ),
              // SizedBox(width: 6),
              // Material(
              //   elevation: 2,
              //   borderRadius: BorderRadius.circular(10),
              //   child: GestureDetector(
              //     onTap: () {
              //       if (completedListController.selectedIconNumber.value != 1)
              //         completedListController.getNoOfCompletedActiveTasks();
              //       completedListController.selectedIconNumber.value = 1;
              //     },
              //     child: Container(
              //       height: 35,
              //       width: 30,
              //       decoration: BoxDecoration(
              //           color: completedListController.selectedIconNumber.value == 1 ? HexColor('0E72FD') : Colors.white,
              //           borderRadius: BorderRadius.circular(10)),
              //       child: Center(
              //         child: ImageIcon(
              //           AssetImage("assets/images/add_circle.png"),
              //           color: completedListController.selectedIconNumber.value == 1
              //               ? Colors.white
              //               : HexColor('848D9C').withOpacity(0.7),
              //           size: 28,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(width: 6),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(showFilterDialog(context, completedListController));
                  },
                  child: Container(
                    height: 35,
                    width: 30,
                    decoration: BoxDecoration(
                        color: completedListController.selectedIconNumber.value == 4 ? HexColor('0E72FD') : Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Icon(
                        Icons.filter_alt,
                        color: completedListController.selectedIconNumber.value == 4
                            ? Colors.white
                            : HexColor('848D9C').withOpacity(0.7),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6),
              Visibility(
                visible: false,
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () {
                      completedListController.selectedIconNumber.value = 5;
                    },
                    child: Container(
                      height: 35,
                      width: 30,
                      decoration: BoxDecoration(
                          color: completedListController.selectedIconNumber.value == 5 ? HexColor('0E72FD') : Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(
                          Icons.checklist,
                          color: completedListController.selectedIconNumber.value == 5
                              ? Colors.white
                              : HexColor('848D9C').withOpacity(0.7),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 10),
        Visibility(
            visible: (completedListController.completed_activeList.length == 0 && !completedListController.isLoading.value)
                ? true
                : false,
            child: WidgetNoDataFound()),

        Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      print(completedListController.completed_activeList[index].toJson());
                      switch (completedListController.completed_activeList[index].tasktype.toString().toUpperCase()) {
                        case "MAKE":
                          var URL =
                              CommonMethods.activeList_CreateURL_MAKE(completedListController.completed_activeList[index], index);
                          if (!URL.isEmpty) Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullProjectUrl(URL)]);
                          break;
                        case "CHECK":
                        case "APPROVE":
                          ListItemDetailsController listItemDetailsController = Get.put(ListItemDetailsController());
                          listItemDetailsController.openModel = completedListController.completed_activeList[index];
                          Get.toNamed(Routes.ProjectListingPageDetails);
                          break;

                        case "":
                        case "NULL":
                        case "CACHED SAVE":
                          var URL = CommonMethods.activeList_CreateURL_MESSAGE(
                              completedListController.completed_activeList[index], index);
                          if (!URL.isEmpty) Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullProjectUrl(URL)]);
                          break;
                        default:
                          break;
                      }
                    },
                    title: WidgetCompletedListItem(completedListController.completed_activeList[index]),
                  );
                  // return GestureDetector(
                  //     onTap: () {
                  //       Get.toNamed(Routes.ProjectListingPageDetails);
                  //     },
                  //     child: WidgetListItem(completedListController.pending_activeList[index]));
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 20,
                    child: WidgetDottedSeparator(),
                  );
                },
                itemCount: completedListController.completed_activeList.length))
      ],
    );
  }
}
