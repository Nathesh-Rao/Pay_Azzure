import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/payroll_history_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/icon_label_widget.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/payroll/payroll_details_header_widget.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:axpertflutter/Utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PayrollDetailsPage extends GetView<PayAndLeaveController> {
  const PayrollDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Payroll",
        ),
      ),
      body: Column(
        children: [
          // Obx(() => (controller.payRollOverview.value == null &&
          //             controller.payrollOverviewLoading.value) ||
          //         (controller.payRollOverview.value != null)
          //     ? PayrollDetailsHeaderWidget().skeletonLoading(
          //         (controller.payRollOverview.value == null)
          //             ? true
          //             : controller.payrollOverviewLoading.value)
          //     : SizedBox.shrink()),

          Obx(
            () => PayrollDetailsHeaderWidget()
                .skeletonLoading(controller.payrollOverviewLoading.value),
          ),
          10.verticalSpace,
          Row(
            children: [
              23.horizontalSpace,
              IconLabelWidget(
                  iconColor: MyColors.violetBorder, label: "Previous Payslips"),
            ],
          ),
          5.verticalSpace,
          Expanded(
              child: Obx(
            () => ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: controller.payrollHistoryList.value.length,
                    itemBuilder: (context, index) =>
                        _historyTile(controller.payrollHistoryList[index]))
                .skeletonLoading(controller.payrollOverviewLoading.value),
          ))
        ],
      ),
    );
  }

  _historyTile(PayrollHistoryModel payroll) {
    return ListTile(
      leading: Image.asset(
        "assets/images/download.png",
        width: 40,
      ),
      title: Text(
        // "${payroll.name} - ${payroll.date}days",
        payroll.name,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        "${DateUtilsHelper.getShortDayName(payroll.date)} ${DateUtilsHelper.getDateNumber(payroll.date)}-${DateUtilsHelper.getShortMonthName(payroll.date)}",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
      trailing:
          Text("₹${StringUtils.maskAmount(payroll.totalAmount.toString())}",
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              )),
    );
  }
}
