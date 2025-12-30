import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/attendance/attendance_dashboard_widget.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/leaves/leave_dashboard_widget.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/work_calendar/work_calendar_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/news_events/news_event_dashboard_widget.dart';
import '../widgets/payroll/payroll_dashboard_widget.dart';

class PayAndAttendancePage extends StatelessWidget {
  const PayAndAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          PayRollDashBoardWidget(),
          15.verticalSpace,
          NewsEventsDashboardWidget(),
          15.verticalSpace,
          WorkCalendarDashboardWidget(),
          15.verticalSpace,
          AttendanceDashBoardWidget(),
          15.verticalSpace,
          LeaveDashboardWidget(),
          15.verticalSpace,
        ],
      ),
    );
  }
}
