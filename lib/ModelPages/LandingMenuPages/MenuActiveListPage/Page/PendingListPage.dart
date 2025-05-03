import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/ListItemDetailsController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/PendingListController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Widgets/WidgetDottedSeparator.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Widgets/WidgetPendingListItem.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNoDataFound.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PendingListPage extends StatelessWidget {
  PendingListPage({super.key});

  final PendingListController pendingListController = Get.put(PendingListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (pendingListController.needRefresh.value == true) {
        pendingListController.needRefresh.toggle();
        return reBuild(pendingListController, context);
      }
      return reBuild(pendingListController, context);
    });
  }
}

reBuild(PendingListController pendingListController, BuildContext context) {
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
                controller: pendingListController.searchController,
                onChanged: pendingListController.filterList,
                decoration: InputDecoration(
                    prefixIcon: pendingListController.searchController.text.toString() == ""
                        ? GestureDetector(child: Icon(Icons.search))
                        : GestureDetector(
                            onTap: () {
                              pendingListController.clearCalled();
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
            //       if (pendingListController.selectedIconNumber.value != 1) pendingListController.getNoOfPendingActiveTasks();
            //       pendingListController.selectedIconNumber.value = 1;
            //     },
            //     child: Container(
            //       height: 35,
            //       width: 30,
            //       decoration: BoxDecoration(
            //           color: pendingListController.selectedIconNumber.value == 1 ? HexColor('0E72FD') : Colors.white,
            //           borderRadius: BorderRadius.circular(10)),
            //       child: Center(
            //         child: ImageIcon(
            //           AssetImage("assets/images/add_circle.png"),
            //           color: pendingListController.selectedIconNumber.value == 1
            //               ? Colors.white
            //               : HexColor('848D9C').withOpacity(0.7),
            //           size: 28,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(width: 6),
            // Material(
            //   elevation: 2,
            //   borderRadius: BorderRadius.circular(10),
            //   child: GestureDetector(
            //     onTap: () {
            //
            //     },
            //     child: Container(
            //       height: 35,
            //       width: 30,
            //       decoration: BoxDecoration(
            //           color: pendingListController.selectedIconNumber.value == 2 ? HexColor('0E72FD') : Colors.white,
            //           borderRadius: BorderRadius.circular(10)),
            //       child: Center(
            //         child: Icon(
            //           Icons.refresh,
            //           color: pendingListController.selectedIconNumber.value == 2
            //               ? Colors.white
            //               : HexColor('848D9C').withOpacity(0.7),
            //           size: 28,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(width: 6),
            // Material(
            //   elevation: 2,
            //   borderRadius: BorderRadius.circular(10),
            //   child: GestureDetector(
            //     onTap: () {
            //       pendingListController.selectedIconNumber.value = 3;
            //     },
            //     child: Container(
            //       height: 35,
            //       width: 30,
            //       decoration: BoxDecoration(
            //           color: pendingListController.selectedIconNumber.value == 3 ? HexColor('0E72FD') : Colors.white,
            //           borderRadius: BorderRadius.circular(10)),
            //       child: Center(
            //         child: Icon(
            //           Icons.access_time_outlined,
            //           color: pendingListController.selectedIconNumber.value == 3
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
                  Get.dialog(showFilterDialog(context, pendingListController));
                },
                child: Container(
                  height: 35,
                  width: 30,
                  decoration: BoxDecoration(
                      color: pendingListController.selectedIconNumber.value == 4 ? HexColor('0E72FD') : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(
                      Icons.filter_alt,
                      color: pendingListController.selectedIconNumber.value == 4
                          ? Colors.white
                          : HexColor('848D9C').withOpacity(0.7),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 6),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: () {
                  pendingListController.selectedIconNumber.value = 5;
                  Get.dialog(showBulkApprovalProcessDialog(context, pendingListController));
                },
                child: Container(
                  height: 35,
                  width: 30,
                  decoration: BoxDecoration(
                      color: pendingListController.selectedIconNumber.value == 5 ? HexColor('0E72FD') : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(
                      Icons.checklist,
                      color: pendingListController.selectedIconNumber.value == 5
                          ? Colors.white
                          : HexColor('848D9C').withOpacity(0.7),
                      size: 28,
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
          visible:
              (pendingListController.pending_activeList.length == 0 && !pendingListController.isLoading.value) ? true : false,
          child: WidgetNoDataFound()),

      Visibility(
        visible: pendingListController.pending_activeList.length != 0,
        child: Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      print(pendingListController.pending_activeList[index].toJson());
                      switch (pendingListController.pending_activeList[index].tasktype.toString().toUpperCase()) {
                        case "MAKE":
                          var URL = CommonMethods.activeList_CreateURL_MAKE(
                            pendingListController.pending_activeList[index],
                          );
                          if (!URL.isEmpty) Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullProjectUrl(URL)]);
                          break;
                          break;
                        case "CHECK":
                        case "APPROVE":
                          ListItemDetailsController listItemDetailsController = Get.put(ListItemDetailsController());
                          listItemDetailsController.openModel = pendingListController.pending_activeList[index];

                          Get.toNamed(Routes.ProjectListingPageDetails);
                          break;
                        case "":
                        case "NULL":
                        case "CACHED SAVE":
                          var URL = CommonMethods.activeList_CreateURL_MESSAGE(pendingListController.pending_activeList[index]);
                          if (!URL.isEmpty) Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullProjectUrl(URL)]);
                          break;
                        default:
                          break;
                      }
                    },
                    title: WidgetPendingListItem(pendingListController.pending_activeList[index]),
                  );
                  // return GestureDetector(
                  //     onTap: () {
                  //       Get.toNamed(Routes.ProjectListingPageDetails);
                  //     },
                  //     child: WidgetListItem(pendingListController.pending_activeList[index]));
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 20,
                    child: WidgetDottedSeparator(),
                  );
                },
                itemCount: pendingListController.pending_activeList.length)),
      )
    ],
  );
}

Widget showFilterDialog(BuildContext context, var pendingListController) {
  pendingListController.errDateFrom.value = pendingListController.errDateTo.value = '';
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
                  // TextField(
                  //   controller: pendingListController.searchTextController,
                  //   textInputAction: TextInputAction.next,
                  //   decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor: Colors.grey.withOpacity(0.05),
                  //       suffix: GestureDetector(
                  //           onTap: () {
                  //             pendingListController.searchTextController.text = "";
                  //             FocusManager.instance.primaryFocus?.unfocus();
                  //           },
                  //           child: Container(
                  //             child: Text("X"),
                  //           )),
                  //       border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                  //       hintText: "Search Text "),
                  // ),
                  // Center(
                  //     child: Padding(
                  //         padding: EdgeInsets.only(top: 10, bottom: 10),
                  //         child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold)))),
                  TextField(
                    controller: pendingListController.processNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                        suffix: GestureDetector(
                            onTap: () {
                              pendingListController.processNameController.text = "";
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
                    controller: pendingListController.fromUserController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                        suffix: GestureDetector(
                            onTap: () {
                              pendingListController.fromUserController.text = "";
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
                    controller: pendingListController.dateFromController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                        suffix: GestureDetector(
                            onTap: () {
                              pendingListController.dateFromController.text = "";
                            },
                            child: Container(
                              child: Text("X"),
                            )),
                        border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                        errorText: pendingListController.errText(pendingListController.errDateFrom.value),
                        hintText: "From Date: DD-MMM-YYYY "),
                    canRequestFocus: false,
                    onTap: () {
                      selectDate(context, pendingListController.dateFromController);
                    },
                    enableInteractiveSelection: false,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: pendingListController.dateToController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                        suffix: GestureDetector(
                            onTap: () {
                              pendingListController.dateToController.text = "";
                            },
                            child: Container(
                              child: Text("X"),
                            )),
                        border: OutlineInputBorder(borderSide: BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                        errorText: pendingListController.errText(pendingListController.errDateTo.value),
                        hintText: "To Date: DD-MMM-YYYY"),
                    canRequestFocus: false,
                    enableInteractiveSelection: false,
                    onTap: () {
                      selectDate(context, pendingListController.dateToController);
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
                            pendingListController.removeFilter();
                            Get.back();
                          },
                          child: Text("Reset")),
                      ElevatedButton(
                          onPressed: () {
                            pendingListController.applyFilter();
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

void selectDate(BuildContext context, TextEditingController text) async {
  FocusManager.instance.primaryFocus?.unfocus();
  const months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final DateTime? picked =
      await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1990), lastDate: DateTime.now());
  if (picked != null)
    text.text =
        picked.day.toString().padLeft(2, '0') + "-" + months[picked.month - 1] + "-" + picked.year.toString().padLeft(2, '0');
}

Widget showBulkApprovalProcessDialog(BuildContext context, PendingListController pendingListController) {
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
                      "Bulk Approve",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(margin: EdgeInsets.only(top: 10), height: 1, color: Colors.grey.withOpacity(0.6)),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: pendingListController.bulkApprovalCount_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            Get.back();
                            pendingListController
                                .getBulkActiveTasks(pendingListController.bulkApprovalCount_list[index].processname.toString());
                            Get.dialog(showBulkApproval_DetailDialog(context, pendingListController));
                          },
                          title: WidgetBulkAppr_CountItem(pendingListController.bulkApprovalCount_list[index]),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("Cancel")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
}

Widget WidgetBulkAppr_CountItem(var bulkApprovalCountModel) {
  return Container(
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 40,
        width: 40,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Image.asset(
            'assets/images/createoffer.png',
          ),
          //AssetImage( 'assets/images/createoffer.png'),
        ),
      ),
      SizedBox(width: 10),
      Container(
        height: 40,
        child: Center(
          child: Text(bulkApprovalCountModel.processname.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: HexColor('#495057'),
                ),
              )),
        ),
      ),
      Expanded(child: SizedBox(width: 10)),
      Container(
        height: 40,
        width: 40,
        child: Center(
          child: Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.red, boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 1),
              )
            ]),
            child: Center(
                child: Text(
              bulkApprovalCountModel.pendingapprovals.toString(),
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
      ),
    ]),
  );
}

Widget showBulkApproval_DetailDialog(BuildContext context, PendingListController pendingListController) {
  return Obx(() => Dialog(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CheckboxListTile(
                    title: Text(
                      "Bulk Approval ",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    value: pendingListController.isBulkAppr_SelectAll.value,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (bool? value) {
                      pendingListController.selectAll_BulkApproveList_item(value);
                    },
                  ),
                ),
                Container(margin: EdgeInsets.only(top: 10), height: 1, color: Colors.grey.withOpacity(0.6)),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    maxHeight: 300.0,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: pendingListController.bulkApproval_activeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        value: pendingListController.bulkApproval_activeList[index].bulkApprove_isSelected.value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (value) {
                          pendingListController.onChange_BulkApprItem(index, value);
                        },
                        title: widgetBulkApproval_ListItem(
                            pendingListController, pendingListController.bulkApproval_activeList[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: "Enter Comments",
                        labelText: "Enter Comments",
                        filled: true,
                        fillColor: Colors.grey.shade100),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          pendingListController.doBulkApprove();
                        },
                        child: Text("Bulk Approve"))
                  ],
                )
              ],
            ),
          ),
        ),
      ));
}

Widget widgetBulkApproval_ListItem(PendingListController pendingListController, itemModel) {
  return Container(
    padding: EdgeInsets.only(top: 5, bottom: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                itemModel.displaytitle.toString(),
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('#495057'))),
                textAlign: TextAlign.left,
                maxLines: 2,
                // selectable: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(itemModel.displaycontent.toString(),
            maxLines: 1,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 11,
                color: HexColor('#495057'),
              ),
            )),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.person,
            ),
            SizedBox(
              width: 5,
            ),
            Text(itemModel.fromuser.toString().capitalize!,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#495057'),
                  ),
                ))
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16),
            SizedBox(width: 10),
            Text(pendingListController.getDateValue(itemModel.eventdatetime),
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#495057'),
                  ),
                )),
            Expanded(child: Text("")),
            Icon(Icons.access_time, size: 16),
            SizedBox(width: 5),
            Text(pendingListController.getTimeValue(itemModel.eventdatetime),
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#495057'),
                  ),
                )),
            SizedBox(width: 10),
          ],
        ),
      ],
    ),
  );
}
