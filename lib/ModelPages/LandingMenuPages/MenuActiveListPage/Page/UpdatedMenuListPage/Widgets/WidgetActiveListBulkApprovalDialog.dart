import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Controllers/PendingListController.dart';
import '../../../Controllers/UpdatedActiveTaskListController/ActiveTaskListController.dart';

class WidgetActiveListBulkApprovalDialog extends StatelessWidget {
  const WidgetActiveListBulkApprovalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final PendingListController pendingListController = Get.find();
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
                      child: pendingListController.bulkApprovalCount_list.isEmpty
                          ? ListTile(
                              leading: Icon(
                                Icons.do_not_disturb_on_total_silence_rounded,
                                color: MyColors.baseRed,
                              ),
                              title: Text(
                                "No records available for approvals !",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: pendingListController.bulkApprovalCount_list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    Get.back();
                                    pendingListController.getBulkActiveTasks(
                                        pendingListController.bulkApprovalCount_list[index].processname.toString());
                                    Get.dialog(showBulkApproval_DetailDialog(context, pendingListController));
                                  },

                                  leading: Image.asset(
                                    'assets/images/createoffer.png',
                                    width: 25,
                                  ),

                                  title: Text(pendingListController.bulkApprovalCount_list[index].processname.toString(),
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          color: HexColor('#495057'),
                                        ),
                                      )),

                                  trailing: CircleAvatar(
                                    backgroundColor: MyColors.red,
                                    radius: 13,
                                    child: Text(
                                      pendingListController.bulkApprovalCount_list[index].pendingapprovals.toString(),
                                      style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  // title: WidgetBulkAppr_CountItem(pendingListController.bulkApprovalCount_list[index]),

                                  // title: Text("${pendingListController.bulkApprovalCount_list[index].pendingapprovals}"),
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

  Widget showBulkApproval_DetailDialog(BuildContext context, PendingListController pendingListController) {
    ActiveTaskListController activeTaskListController = Get.find();

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
                      controller: pendingListController.bulkCommentController,
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
                            pendingListController.doBulkApprove().then((_) {
                              activeTaskListController.refreshList();
                            });
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
}
