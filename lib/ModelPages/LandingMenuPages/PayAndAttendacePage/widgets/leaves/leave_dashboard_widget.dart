import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/icon_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'leave_dashboard_count_widget.dart';
import 'leave_dashboard_event_widget.dart';

class LeaveDashboardWidget extends GetView<PayAndLeaveController> {
  const LeaveDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeLeaveData();
    });
    return Visibility(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconLabelWidget(
              iconColor: Color(0xffE0A47A), label: "Leave Activity"),
          10.verticalSpace,
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.leaveDetails);
            },
            child: SizedBox(
              height: 202,
              child: Row(
                spacing: 15,
                children: [
                  LeaveDashBoardLeaveCountWidget(),
                  LeaveDashBoardEventWidget(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
