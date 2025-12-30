import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/app_styles.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/leave_history_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/icon_label_widget.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/leaves/leave_details_header_widget.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class LeaveDetailsScreen extends GetView<PayAndLeaveController> {
  const LeaveDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyColors.resetColorIndex();

      controller.getLeaveHistory();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Leave",
        ),
      ),
      body: Column(
        children: [
          Obx(() => controller.leaveDetailsList.isNotEmpty
              ? LeaveDetailsHeaderWidget()
                  .skeletonLoading(controller.isLeaveDetailsLoading.value)
              : _emptyWidget()),
          10.verticalSpace,
          Row(
            children: [
              23.horizontalSpace,
              IconLabelWidget(
                  iconColor: MyColors.snackBarNotificationColorBlue,
                  label: "Leave History"),
            ],
          ),
          5.verticalSpace,
          Expanded(
              child: Obx(
            () => ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: controller.leaveHistoryList.length,
                    itemBuilder: (context, index) =>
                        _historyTile(controller.leaveHistoryList[index]))
                .skeletonLoading(controller.isLeaveDetailsLoading.value),
          ))
        ],
      ),
    );
  }

  _historyTile(LeaveHistoryModel leave) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            controller.getColorByLeaveType(leave.leaveType).withAlpha(50),
        child: Center(
          child: Icon(
            controller.getIconByLeaveType(leave.leaveType),
            color: controller.getColorByLeaveType(leave.leaveType),
          ),
        ),
      ),
      title: Text(
        "${leave.leaveType} - ${leave.totalDays} ${leave.totalDays == 1 ? "day" : "days"}",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        "${DateUtilsHelper.getShortDayName(leave.fromDate.toString())} ${DateUtilsHelper.getDateNumber(leave.fromDate.toString())}-${DateUtilsHelper.getShortMonthName(leave.toDate.toString())}",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: controller.getColorByLeaveStatus(leave.status).withAlpha(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.getIconByLeaveStatus(leave.status),
              size: 13,
              color:
                  controller.getColorByLeaveStatus(leave.status).withAlpha(200),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyWidget() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: MyColors.snackBarErrorColorRed.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.error, color: MyColors.baseRed),
            Text(
              "Sorry we coudn't find any leave details or activity for User ${globalVariableController.USER_NAME}",
              textAlign: TextAlign.center,
              style:
                  AppStyles.actionButtonStyle.copyWith(color: MyColors.baseRed),
            )
          ],
        ),
      ),
    );
  }
}
