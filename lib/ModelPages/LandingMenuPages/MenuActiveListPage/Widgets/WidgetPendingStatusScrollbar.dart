import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/ListItemDetailsController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/PendingListController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/PendingProcessFlowModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetPendingStatusScrollBar extends StatelessWidget {
  WidgetPendingStatusScrollBar(this.status, {super.key});
  PendingProcessFlowModel status;
  PendingListController pendingListController = Get.find();
  ListItemDetailsController listItemDetailsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: (status.taskstatus.toLowerCase() == 'made' ||
                        status.taskstatus.toLowerCase() == 'approved' ||
                        status.taskstatus.toLowerCase() == 'approve')
                    ? HexColor("50CD89")
                    : status.taskstatus.toLowerCase() == 'active'
                        ? Colors.orange
                        : status.taskstatus.toLowerCase() == 'rejected'
                            ? Colors.red
                            : HexColor("DAE3ED").withOpacity(0.4),
                borderRadius: BorderRadius.circular(50)),
            child: Center(
                child: Text(
              double.parse(status.indexno).toInt().toString(),
              style: TextStyle(
                  color: (status.taskstatus.toLowerCase() == 'made' ||
                          status.taskstatus.toLowerCase() == 'approved' ||
                          status.taskstatus.toLowerCase() == 'rejected' ||
                          status.taskstatus.toLowerCase() == 'active')
                      ? Colors.white
                      : Colors.black.withOpacity(0.2)),
            )),
          ),
          SizedBox(width: 5),
          Text(
            status.taskname,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    color: (listItemDetailsController.selectedTaskID == status.taskid)
                        ? HexColor("333333")
                        : HexColor("495057").withOpacity(0.6),
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
