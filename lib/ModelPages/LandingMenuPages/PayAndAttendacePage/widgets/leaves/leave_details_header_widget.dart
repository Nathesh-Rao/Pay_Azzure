import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/app_styles.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/leave_details_model.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveDetailsHeaderWidget extends GetView<PayAndLeaveController> {
  const LeaveDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: MyColors.baseGray.withAlpha(150),
        // color: AppColors.snackBarNotificationColorBlue.withAlpha(100),

        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFF3334A0),
        //     Color(0xFF12133A),
        //   ],
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Row(
            children: [
              20.horizontalSpace,
              Text(
                DateUtilsHelper.getTodayFormattedDate(),
                style: AppStyles.actionButtonStyle
                    .copyWith(color: MyColors.blue10),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 125,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: MyColors.secondaryButtonBGColorWhite,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(100),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(100),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 30,
                                sections: List.generate(
                                    controller.leaveDivisionsValue.length,
                                    (index) => _pieCrumbs(index)),
                              ),
                            ),
                            Text(
                              DateUtilsHelper.getShortMonthName(
                                  DateTime.now().toString()),
                              style: AppStyles.actionButtonStyle,
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: List.generate(
                            controller.leaveDetailsList.length,
                            (index) => _breakTile(index)),
                      ),
                    )),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              20.horizontalSpace,
              InkWell(
                onTap: () {
                  Get.back();
                  controller.applyForLeave();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    // AppColors.snackBarNotificationColorBlue.withAlpha(150),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Apply for Leave",
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: MyColors.blue10),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  PieChartSectionData _pieCrumbs(int index) {
    double value = controller.leaveDivisionsValue[index];
    Color color = controller.getColorList()[index];
    return PieChartSectionData(
      color: color,
      value: value,
      showTitle: false,
      radius: 20,
    );
  }

  Widget _breakTile(int index) {
    LeaveDetailsModel leave = controller.leaveDetailsList[index];
    Color color = controller.getColorList()[index];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.circle,
            size: 12,
            color: color,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leave.leaveType.split(" ")[0],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
            RichText(
              text: TextSpan(
                  text: (leave.totalLeaves - leave.leavesTaken)
                      .toInt()
                      .toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: MyColors.primaryActionColorDarkBlue,
                    // color: color,
                  ),
                  children: [
                    TextSpan(
                      text: "  ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 7,
                        color: MyColors.text2,
                      ),
                      children: [
                        TextSpan(
                          text: "(${leave.totalLeaves.toInt().toString()})",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                            color: MyColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ]),
            )
          ],
        ),
      ],
    );
  }
}
