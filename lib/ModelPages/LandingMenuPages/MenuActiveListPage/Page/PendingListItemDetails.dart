import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/ListItemDetailsController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Widgets/WidgetPendingStatusScrollbar.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetLandingAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PendingListItemDetails extends StatelessWidget {
  PendingListItemDetails({super.key});

  // PendingListController pendingListController=Get.find();
  ListItemDetailsController listItemDetailsController = Get.find();

  @override
  Widget build(BuildContext context) {
    listItemDetailsController.fetchDetails();
    var size = MediaQuery.of(context).size;
    print("size1 $size");
    return Obx(() {
      if (listItemDetailsController.widgetProcessFlowNeedRefresh.value == true) {
        listItemDetailsController.widgetProcessFlowNeedRefresh.toggle();
        return reBuild(size);
      } else
        return reBuild(size);
    });
  }

  reBuild(size) => Scaffold(
        appBar: WidgetLandingAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: double.maxFinite,
                decoration:
                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: HexColor('707070').withOpacity(0.2)))),
                // color: Colors.red,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    controller: listItemDetailsController.scrollController,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          listItemDetailsController.onProcessFlowItemTap(index);
                          // print(pendingListController.processFlowList[index].taskid.toString());
                          if (listItemDetailsController.processFlowList[index].taskid.toString().toLowerCase() != 'null' &&
                              listItemDetailsController.processFlowList[index].taskid.toString() !=
                                  listItemDetailsController.selectedTaskID) {
                            //if(listItemDetailsController.processFlowList[index].tasktype.toString().toUpperCase() == "APPROVE" )
                            listItemDetailsController.fetchDetails(
                                hasArgument: true, pendingProcessFlowModel: listItemDetailsController.processFlowList[index]);
                            // print(pendingListController.processFlowList[index].toJson());
                          }
                        },
                        child: WidgetPendingStatusScrollBar(listItemDetailsController.processFlowList[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Center(
                          child: Text(
                        " > ",
                        style: TextStyle(color: HexColor("848D9C").withOpacity(0.4)),
                      ));
                    },
                    itemCount: listItemDetailsController.processFlowList.length),
              ),
              SizedBox(height: 0),
              if (listItemDetailsController.selected_processFlow_taskType.toUpperCase() == "MAKE") ...[
                Visibility(
                    visible: listItemDetailsController.selected_processFlow_taskType.toUpperCase() == "MAKE" ? true : false,
                    child: Expanded(
                      // height: size.height - 200,
                      // width: double.maxFinite,
                      // color: Colors.red,
                      child: InApplicationWebViewer(Const.getFullProjectUrl(CommonMethods.activeList_CreateURL_MAKE(
                        listItemDetailsController.openModel,
                      ))),
                    )),
              ] else ...[
                Visibility(
                  visible: listItemDetailsController.pendingTaskModel != null ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: HexColor('707070').withOpacity(0.2)))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back_ios, size: 30)),

                          // SizedBox(width: 10),
                          Icon(
                            Icons.calendar_month_sharp,
                            size: 35,
                          ),
                          // SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ticket",
                                  style: GoogleFonts.nunitoSans(textStyle: TextStyle(color: HexColor('495057'), fontSize: 16))),
                              Text(
                                  listItemDetailsController.pendingTaskModel != null
                                      ? '#' + listItemDetailsController.pendingTaskModel!.taskid ?? ' '
                                      : '',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle:
                                          TextStyle(color: HexColor('495057'), fontSize: 22, fontWeight: FontWeight.w800))),
                            ],
                          ),
                          Expanded(child: Text("")),
                          SizedBox(width: 10),
                          Visibility(
                            visible: listItemDetailsController.pendingTaskModel != null
                                ? listItemDetailsController.pendingTaskModel!.tasktype.toLowerCase() == ''
                                    ? false
                                    : true
                                : false,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular((20)), color: Colors.orange),
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                child: Text(
                                  listItemDetailsController.pendingTaskModel != null
                                      ? CommonMethods.capitalize(listItemDetailsController.pendingTaskModel!.tasktype ?? ' ')
                                      : '',
                                  style: GoogleFonts.nunitoSans(textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: listItemDetailsController.pendingTaskModel != null ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: HexColor('707070').withOpacity(0.2)))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: HexColor('FF7F79')),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text("Pending Approval",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(fontSize: 13, color: HexColor('495057').withOpacity(0.8)))),
                          ),
                          SizedBox(
                              width: size.width * 0.4,
                              child: Text(
                                  listItemDetailsController.pendingTaskModel != null
                                      ? CommonMethods.capitalize(listItemDetailsController.pendingTaskModel!.touser ?? ' ')
                                      : '',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontWeight: FontWeight.bold, color: HexColor('495057'))))),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: listItemDetailsController.pendingTaskModel != null ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: HexColor('707070').withOpacity(0.2)))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.group,
                            color: HexColor('616161'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text("Raised By",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(fontSize: 13, color: HexColor('495057').withOpacity(0.8)))),
                          ),
                          SizedBox(
                            width: size.width * 0.4,
                            child: Text(
                              listItemDetailsController.pendingTaskModel != null
                                  ? CommonMethods.capitalize(listItemDetailsController.pendingTaskModel!.fromuser ?? ' ')
                                  : '',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(fontWeight: FontWeight.bold, color: HexColor('495057'))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: listItemDetailsController.pendingTaskModel != null ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: HexColor('707070').withOpacity(0.2)))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: HexColor('616161'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text("Assigned By",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(fontSize: 13, color: HexColor('495057').withOpacity(0.8)))),
                          ),
                          SizedBox(
                            width: size.width * 0.4,
                            child: Text(
                              listItemDetailsController.pendingTaskModel != null
                                  ? CommonMethods.capitalize(listItemDetailsController.pendingTaskModel!.initiator ?? ' ')
                                  : '',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(fontWeight: FontWeight.bold, color: HexColor('495057'))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: listItemDetailsController.pendingTaskModel != null ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: HexColor('707070').withOpacity(0.2)))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.today,
                            color: HexColor('616161'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text("Assigned On",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(fontSize: 13, color: HexColor('495057').withOpacity(0.8)))),
                          ),
                          SizedBox(
                            width: size.width * 0.4,
                            child: Row(
                              children: [
                                Text(
                                  listItemDetailsController.pendingTaskModel != null
                                      ? listItemDetailsController
                                          .getDateValue(listItemDetailsController.pendingTaskModel!.eventdatetime)
                                      : "",
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontWeight: FontWeight.bold, color: HexColor('495057'))),
                                ),
                                SizedBox(width: 4),
                                Visibility(
                                    visible: listItemDetailsController.pendingTaskModel != null ? true : false,
                                    child: Icon(
                                      Icons.access_time,
                                      size: 15,
                                    )),
                                SizedBox(width: 1),
                                Text(
                                  listItemDetailsController.pendingTaskModel != null
                                      ? listItemDetailsController
                                          .getTimeValue(listItemDetailsController.pendingTaskModel!.eventdatetime)
                                      : "",
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontWeight: FontWeight.bold, color: HexColor('495057'))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: listItemDetailsController.pendingTaskModel != null ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: HexColor('707070').withOpacity(0.2)))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: HexColor('616161'),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description",
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontWeight: FontWeight.bold, color: HexColor('495057')))),
                              SizedBox(height: 10),
                              Text(
                                  listItemDetailsController.pendingTaskModel != null
                                      ? listItemDetailsController.pendingTaskModel!.displaycontent.toLowerCase() != 'null'
                                          ? listItemDetailsController.pendingTaskModel!.displaycontent.toString()
                                          : ' '
                                      : "",
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontSize: 13, color: HexColor('495057').withOpacity(0.8)))),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Visibility(
                  visible: listItemDetailsController.pendingTaskModel != null
                      ? listItemDetailsController.pendingTaskModel!.showbuttons.toLowerCase() == "t"
                          ? true
                          : false
                      : false,
                  child: Center(
                    child: Container(
                      height: 80,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: generateList(size),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0),
                Visibility(
                    visible: listItemDetailsController.pendingTaskModel == null ? true : false,
                    child: Container(
                      height: 500,
                      child: Center(
                        child: Text("Task details not found."),
                      ),
                    )),
              ],
            ],
          ),
        ),
      );

  List<Widget> generateList(size) {
    if (listItemDetailsController.pendingTaskModel != null) {
      if (listItemDetailsController.pendingTaskModel!.tasktype.toUpperCase() == "CHECK") return generateCheckList(size);
      if (listItemDetailsController.pendingTaskModel!.tasktype.toUpperCase() == "APPROVE") return generateApproveList(size);
    }
    return [Container()];
  }

  generateCheckList(size) {
    List<Widget> list = [];
    list.add(widgetCheckButton(size));
    if (listItemDetailsController.pendingTaskModel!.returnable.toUpperCase() == "T") list.add(widgetReturnButton(size));
    if (listItemDetailsController.pendingTaskModel!.allowsendflg.toUpperCase() == "2" ||
        listItemDetailsController.pendingTaskModel!.allowsendflg.toUpperCase() == "3" ||
        listItemDetailsController.pendingTaskModel!.allowsendflg.toUpperCase() == "4") {
      list.add(widgetSendButton(size));
    }
    list.add(widgetViewButton(size));
    list.add(widgetHistoryButton(size));
    return list;
  }

  generateApproveList(size) {
    List<Widget> list = [];
    list.add(widgetApproveButton(size));
    list.add(widgetRejectButton(size));
    if (listItemDetailsController.pendingTaskModel!.returnable.toUpperCase() == "T") list.add(widgetReturnButton(size));
    if (listItemDetailsController.pendingTaskModel!.allowsendflg.toUpperCase() == "2" ||
        listItemDetailsController.pendingTaskModel!.allowsendflg.toUpperCase() == "3" ||
        listItemDetailsController.pendingTaskModel!.allowsendflg.toUpperCase() == "4") {
      list.add(widgetSendButton(size));
    }
    list.add(widgetViewButton(size));
    list.add(widgetHistoryButton(size));
    return list;
  }

  widgetApproveButton(size) {
    var hasComments = listItemDetailsController.pendingTaskModel?.approvalcomments.toString().toLowerCase() == 't' ? true : false;
    listItemDetailsController.comments.text = "";
    listItemDetailsController.errCom.value = "";
    return AspectRatio(
      aspectRatio: 2 / 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            Get.dialog(Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Text(
                        'Approve?',
                        style: TextStyle(fontSize: 20),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      Visibility(
                        visible: listItemDetailsController.pendingTaskModel!.cmsg_reject.toString() != '' ? true : false,
                        child: Center(
                            child: Text(
                          listItemDetailsController.pendingTaskModel!.cmsg_appcheck.toString(),
                        )),
                      ),
                      Visibility(
                        visible: true,
                        child: Obx(() => Container(
                              margin: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: listItemDetailsController.comments,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    hintText: "Enter Comments",
                                    labelText: "Enter Comments",
                                    errorText: listItemDetailsController.errCom.value == ''
                                        ? null
                                        : listItemDetailsController.errCom.value,
                                    filled: true,
                                    fillColor: Colors.grey.shade100),
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200)),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  listItemDetailsController.actionApproveOrRejectOrCheck(hasComments, "Approve");
                                },
                                child: Text("Approve"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          },
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 60,
              width: size.width * 0.2,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: HexColor('4ABF7F'),
                  ),
                  Text(
                    "Approve",
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  widgetCheckButton(size) {
    var hasComments = listItemDetailsController.pendingTaskModel?.approvalcomments.toString().toLowerCase() == 't' ? true : false;
    listItemDetailsController.comments.text = "";
    listItemDetailsController.errCom.value = "";
    return AspectRatio(
      aspectRatio: 2 / 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            Get.dialog(Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Text(
                        'Check?',
                        style: TextStyle(fontSize: 20),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      Visibility(
                        visible: listItemDetailsController.pendingTaskModel!.cmsg_reject.toString() != '' ? true : false,
                        child: Center(
                            child: Text(
                          listItemDetailsController.pendingTaskModel!.cmsg_appcheck.toString(),
                        )),
                      ),
                      Visibility(
                        visible: true,
                        child: Obx(() => Container(
                              margin: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: listItemDetailsController.comments,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    hintText: "Enter Comments",
                                    labelText: "Enter Comments",
                                    errorText: listItemDetailsController.errCom.value == ''
                                        ? null
                                        : listItemDetailsController.errCom.value,
                                    filled: true,
                                    fillColor: Colors.grey.shade100),
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200)),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  listItemDetailsController.actionApproveOrRejectOrCheck(hasComments, "Check");
                                },
                                child: Text("Check"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          },
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 60,
              width: size.width * 0.2,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: HexColor('4ABF7F'),
                  ),
                  Text(
                    "Check",
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  widgetRejectButton(size) {
    var hasComments = listItemDetailsController.pendingTaskModel?.approvalcomments.toString().toLowerCase() != 't' ? true : false;
    listItemDetailsController.comments.text = "";
    listItemDetailsController.errCom.value = "";
    return AspectRatio(
      aspectRatio: 2 / 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            Get.dialog(Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Text(
                        'Reject?',
                        style: TextStyle(fontSize: 20),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      Visibility(
                        visible: listItemDetailsController.pendingTaskModel!.cmsg_reject.toString() != '' ? true : false,
                        child: Center(
                            child: Text(
                          listItemDetailsController.pendingTaskModel!.cmsg_appcheck.toString(),
                        )),
                      ),
                      Visibility(
                        visible: hasComments,
                        child: Obx(() => Container(
                              margin: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: listItemDetailsController.comments,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    hintText: "Enter Comments",
                                    labelText: "Enter Comments",
                                    errorText: listItemDetailsController.errCom.value == ''
                                        ? null
                                        : listItemDetailsController.errCom.value,
                                    filled: true,
                                    fillColor: Colors.grey.shade100),
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200)),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  listItemDetailsController.actionApproveOrRejectOrCheck(hasComments, "Reject");
                                },
                                child: Text("Reject"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          },
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 60,
              width: size.width * 0.2,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close_rounded,
                    color: HexColor('FF0000'),
                  ),
                  Text(
                    "Reject",
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  widgetReturnButton(size) {
    var hasComments = listItemDetailsController.pendingTaskModel?.approvalcomments.toString().toLowerCase() != 't' ? true : false;
    listItemDetailsController.comments.text = "";
    listItemDetailsController.errCom.value = "";
    return AspectRatio(
      aspectRatio: 2 / 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            Get.dialog(Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Text(
                        'Return?',
                        style: TextStyle(fontSize: 20),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      Visibility(
                        visible: listItemDetailsController.pendingTaskModel!.cmsg_reject.toString() != '' ? true : false,
                        child: Center(
                            child: Text(
                          listItemDetailsController.pendingTaskModel!.cmsg_appcheck.toString(),
                        )),
                      ),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value: listItemDetailsController.ddSelectedValue.value,
                            items: listItemDetailsController.dropdownMenuItem(),
                            onChanged: (value) => listItemDetailsController.dropDownItemChanged(value),
                            decoration: InputDecoration(prefixIcon: Icon(Icons.person)),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            // )
                          ),
                        ),
                      ),
                      Visibility(
                        visible: hasComments,
                        child: Obx(() => Container(
                              margin: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: listItemDetailsController.comments,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    hintText: "Enter Comments",
                                    labelText: "Enter Comments",
                                    errorText: listItemDetailsController.errCom.value == ''
                                        ? null
                                        : listItemDetailsController.errCom.value,
                                    filled: true,
                                    fillColor: Colors.grey.shade100),
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200)),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  listItemDetailsController.actionReturn(hasComments);
                                },
                                child: Text("Return"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          },
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 60,
              width: size.width * 0.2,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_return,
                    color: HexColor('951895'),
                  ),
                  Text(
                    "Return",
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  widgetSendButton(size) {
    var hasComments = listItemDetailsController.pendingTaskModel?.approvalcomments.toString().toLowerCase() != 't' ? true : false;
    listItemDetailsController.comments.text = "";
    listItemDetailsController.errCom.value = "";
    return AspectRatio(
      aspectRatio: 2 / 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        child: GestureDetector(
          onTap: () async {
            await listItemDetailsController.getSendToUsers_List();
            Get.dialog(Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Text(
                        'Send?',
                        style: TextStyle(fontSize: 20),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      Visibility(
                        visible: listItemDetailsController.pendingTaskModel!.cmsg_reject.toString() != '' ? true : false,
                        child: Center(
                            child: Text(
                          listItemDetailsController.pendingTaskModel!.cmsg_appcheck.toString(),
                        )),
                      ),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value: listItemDetailsController.ddSendToUsers_SelectedValue.value,
                            items: listItemDetailsController.dropdownMenuItem_sendToUsers(),
                            onChanged: (value) => listItemDetailsController.dropDownItemChanged_SendToUsers(value),
                            decoration: InputDecoration(prefixIcon: Icon(Icons.person)),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            // )
                          ),
                        ),
                      ),
                      Visibility(
                        visible: hasComments,
                        child: Obx(() => Container(
                              margin: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: listItemDetailsController.comments,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    hintText: "Enter Comments",
                                    labelText: "Enter Comments",
                                    errorText: listItemDetailsController.errCom.value == ''
                                        ? null
                                        : listItemDetailsController.errCom.value,
                                    filled: true,
                                    fillColor: Colors.grey.shade100),
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200)),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  listItemDetailsController.actionSend(hasComments);
                                },
                                child: Text("Send"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          },
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 60,
              width: size.width * 0.2,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send,
                    color: HexColor('951895'),
                  ),
                  Text(
                    "Send",
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  widgetViewButton(size) {
    return AspectRatio(
      aspectRatio: 2 / 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            listItemDetailsController.viewBtnClicked();
          },
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 60,
              width: size.width * 0.2,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    color: HexColor('951895'),
                  ),
                  Text(
                    "View",
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  widgetHistoryButton(size) {
    return AspectRatio(
      aspectRatio: 2 / 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        child: GestureDetector(
          onTap: () {
            listItemDetailsController.historyBtnClicked();
          },
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 60,
              width: size.width * 0.2,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restore,
                    color: HexColor('0000FF'),
                  ),
                  Text(
                    "History",
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
