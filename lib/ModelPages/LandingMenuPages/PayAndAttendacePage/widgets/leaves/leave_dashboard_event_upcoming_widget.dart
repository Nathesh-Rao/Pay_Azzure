import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/app_styles.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/leave_overview_model.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class LeaveDashBoardEventUpcomingWidget extends GetView<PayAndLeaveController> {
  const LeaveDashBoardEventUpcomingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(
      () => controller.leaveOverviewList.isEmpty
          ? _emptyWidget()
          : CarouselSlider(
              options: CarouselOptions(
                height: 500,
                autoPlay: true,
                scrollDirection: Axis.vertical,
                reverse: true,
              ),
              items: controller.leaveOverviewList.map((overview) {
                return Builder(
                  builder: (BuildContext context) {
                    return _upcomingEventTile(overview);
                  },
                );
              }).toList(),
            ),
    ));
  }

  // _upcomingWidget() => Expanded(
  //       child: _baseContainer(
  //         Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(5),
  //                   child: Icon(
  //                     Icons.upcoming,
  //                     size: 15.w,
  //                     color: AppColors.leaveWidgetColorGreen,
  //                   ),
  //                 ),
  //                 Text(
  //                   "Upcoming & Approved Leaves",
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 8,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Expanded(
  //               child: CarouselSlider(
  //                 options: CarouselOptions(
  //                   height: 500,
  //                   autoPlay: true,
  //                   scrollDirection: Axis.vertical,
  //                 ),
  //                 items: controller.leaveActivity.value?.upcomingLeave.map((i) {
  //                   return Builder(
  //                     builder: (BuildContext context) {
  //                       return _upcomingEventTile();
  //                     },
  //                   );
  //                 }).toList(),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     );

  _upcomingEventTile(LeaveOverviewModel leave) => Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: MyColors.leaveWidgetColorGreenLite,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: MyColors.leaveWidgetColorGreen,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateUtilsHelper.getDateNumber(leave.date),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        DateUtilsHelper.getShortDayName(leave.date),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
                flex: 2,
                child: Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total requested days : ${leave.noDays}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 6,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      leave.approvedBy.toLowerCase().contains("na")
                          ? "not approved yet"
                          : leave.approvedBy,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      leave.leaveType,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 6,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      );

  Widget _emptyWidget() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.chipCardWidgetColorGreen.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: MyColors.chipCardWidgetColorGreen),
            Text(
              "no pending leaves found",
              style: AppStyles.actionButtonStyle
                  .copyWith(color: MyColors.chipCardWidgetColorGreen),
            )
          ],
        ),
      ),
    );
  }
  //
  // Widget _baseContainer(Widget child) => Container(
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10.r),
  //           border: Border.all(
  //             color: AppColors.secondaryButtonBorderColorGrey,
  //           )),
  //       child: child,
  //     );
}
