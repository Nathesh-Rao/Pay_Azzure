import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/AttendanceController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/attendance/attendance_log_header_widget.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/attendance/attendance_log_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onAttendanceLogInit();
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Attendance",
        ),
      ),
      body: Column(children: [
        Obx(() => controller.isAttendanceDetailsIsLoading.value
            ? LinearProgressIndicator(
                color: MyColors.PayAzzureColor2,
              )
            : SizedBox.shrink()),
        AttendanceLogHeaderWidget(),
        Expanded(child: AttendanceLogWidget()),
      ]),
    );
  }
}
