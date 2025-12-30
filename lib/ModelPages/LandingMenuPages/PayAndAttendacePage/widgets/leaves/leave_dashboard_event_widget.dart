import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/leaves/leave_dashboard_event_upcoming_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveDashBoardEventWidget extends GetView<PayAndLeaveController> {
  const LeaveDashBoardEventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.getLeaveOverview();
    // });
    return Expanded(
        flex: 4,
        child: Obx(
          () => Column(
            spacing: 15,
            children: [
              LeaveDashBoardEventUpcomingWidget(),
              _pendingWidget(),
            ],
          ).skeletonLoading(controller.isLeaveOverviewLoading.value),
        ));
  }

  _pendingWidget() {
    var pendingCount = controller.leaveOverviewList.isEmpty
        ? 0
        : controller.leaveOverviewList.first.pendingLeaves;

    return Expanded(
      child: _baseContainer(
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.pie_chart,
                    size: 15,
                    color: MyColors.leaveWidgetColorPink,
                  ),
                ),
                Text(
                  "Pending Leave Requests",
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  10.horizontalSpace,
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: MyColors.leaveWidgetColorPink,
                    child: Text(
                      pendingCount.toString(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Flexible(
                      child: Text(
                    "You have $pendingCount leave requests pending for approval",
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  10.horizontalSpace,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _baseContainer(Widget child) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: MyColors.secondaryButtonBorderColorGrey,
            )),
        child: child,
      );
}
