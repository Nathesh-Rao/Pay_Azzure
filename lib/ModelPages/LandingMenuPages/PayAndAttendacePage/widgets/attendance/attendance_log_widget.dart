import 'package:animate_do/animate_do.dart';
import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/app_styles.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/AttendanceController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/attendance/AttendanceReportModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/icon_label_widget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceLogWidget extends GetView<AttendanceController> {
  const AttendanceLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var style = AppStyles.attendanceLogStyle;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAttendanceLog();
    });

    var buttonStyle = AppStyles.actionButtonStyle;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Row(children: [
            IconLabelWidget(
              iconColor: Color(0xff8371EC),
              label: "Previous Logs",
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Obx(() => InkWell(
                onTap: controller.switchLogExpandValue,
                child: AnimatedSwitcherPlus.revealY(
                    duration: Duration(milliseconds: 500),
                    child: !controller.isLogExpanded.value
                        ? Icon(
                            key: ValueKey("rectangle_compress_vertical"),
                            CupertinoIcons.rectangle_compress_vertical)
                        : Icon(
                            key: ValueKey("rectangle_expand_vertical"),
                            CupertinoIcons.rectangle_expand_vertical)))),
          ]),
        ),
        15.verticalSpace,
        Obx(() =>
            _attendanceListView(value: controller.selectedMonthIndex.value)),
        10.verticalSpace,
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    offset: Offset(0, -2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ]),
            child: Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(gradient: MyColors.subBGGradientHorizontal),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 42,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Date",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Clock In",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(width: 25),
                      Expanded(
                        child: Text(
                          "Clock Out",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Working Hrs",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () {
                      if (controller.isAttendanceReportLoading.value) {
                        // return Center(
                        //   child: CircularProgressIndicator(),
                        // );
                        return Column(
                          children: [
                            LinearProgressIndicator(
                              color: Color(0xff3764FC),
                              minHeight: 2,
                            ),
                            Spacer(),
                            FadeInUp(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.decelerate,
                                from: 25,
                                // child: Text.rich(
                                //   TextSpan(text: "Getting ", children: [
                                //     TextSpan(
                                //         text: "${attendanceController.months[attendanceController.selectedMonthIndex.value]}",
                                //         style: GoogleFonts.poppins(
                                //             fontSize: 20, fontWeight: FontWeight.w500, color: MyColors.text1)),
                                //     TextSpan(text: " report...")
                                //   ]),

                                // style: GoogleFonts.poppins(
                                //   fontSize: 15,
                                //   fontWeight: FontWeight.w500,
                                //   color: MyColors.text1,
                                // ),
                                child: Text(
                                  "${controller.months[controller.selectedMonthIndex.value]}\n${controller.selectedYear.value}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.text1),
                                )
                                // ),
                                ),
                            Spacer(),
                          ],
                        );
                      }

                      if (controller.attendanceReportList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/no-data.png',
                                width: 200,
                              ),
                              5.verticalSpace,
                              Text(
                                "No Data found",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return FadeInUp(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                        from: 25,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: List.generate(
                                controller.attendanceReportList.length,
                                (index) => _attendanceListTile(
                                    controller.attendanceReportList[index])),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _attendanceListTile(AttendanceReportModel data) {
    var style = GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: _getTileWidgetBorderColor(data.status ?? '')))),
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _getTileDateWidget(data),
          ),
          Expanded(
            child: _statusCheck(data.status ?? '')
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.clockIn,
                        style: style,
                        textAlign: TextAlign.start,
                      ),
                      // Text(
                      //   "📍Location",
                      //   style: style.copyWith(
                      //       fontSize: 8,
                      //       fontWeight: FontWeight.w700,
                      //       color: Color(0xff919191)),
                      //   textAlign: TextAlign.start,
                      // ),
                    ],
                  )
                : Text(
                    data.status ?? '',
                    style: style.copyWith(
                      color: _getTileWidgetBorderColor(data.status ?? ""),
                    ),
                  ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _statusCheck(data.status ?? "")
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      data.punchOutTime != null
                          ? Text(
                              data.clockOut,
                              style: style,
                              textAlign: TextAlign.start,
                            )
                          : Text(
                              data.status ?? '',
                              style: style.copyWith(
                                color: _getTileWidgetBorderColor(
                                    data.status ?? ""),
                              ),
                            ),
                      // Text(
                      //   "📍Location",
                      //   style: style.copyWith(
                      //       fontSize: 8,
                      //       fontWeight: FontWeight.w700,
                      //       color: Color(0xff919191)),
                      //   textAlign: TextAlign.start,
                      // ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          Expanded(
            child: Text(
              data.formattedWorkingHours,
              style: style,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTileDateWidget(AttendanceReportModel data) {
    var color = _getTileDateWidgetColor(data.status ?? "");
    var date = data.formattedPunchDate;
    return Row(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: color.withOpacity(0.28),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Expanded(
                  child: Center(
                child: Text(date.split(" ")[0].trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    )),
              )),
              Expanded(
                child: Container(
                  color: color,
                  child: Center(
                    child: Text(
                      date.split(" ")[1].trim(),
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  bool _statusCheck(String status) {
    if (status.toLowerCase().contains("present") ||
        status.toLowerCase().contains("half")) {
      return true;
    }

    return false;
  }

  Color _getTileDateWidgetColor(String status) {
    if (status.toLowerCase().contains("off")) {
      return MyColors.baseRed;
    } else if (status.toLowerCase().contains("leave") ||
        status.toLowerCase().contains("half")) {
      return MyColors.baseYellow;
    } else {
      return MyColors.baseBlue;
    }
  }

  Color _getTileWidgetBorderColor(String status) {
    if (status.toLowerCase().contains("off")) {
      return MyColors.baseRed;
    } else if (status.toLowerCase().contains("leave") ||
        status.toLowerCase().contains("half")) {
      return MyColors.baseYellow;
    } else {
      return MyColors.baseGray;
    }
  }

  Widget _attendanceListView({required int value}) {
    var style = GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500);
    return SizedBox(
      height: 40,
      child: Center(
        child: ListView.separated(
          controller: controller.monthScrollController,
          padding: EdgeInsets.symmetric(horizontal: 15),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              controller.updateMonthIndex(index);
            },
            child: Text(
              controller.months[index],
              style: style.copyWith(
                fontSize: 16,
                color: value == index ? MyColors.baseBlue : MyColors.text1,
                fontWeight:
                    value == index ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 20),
        ),
      ),
    );
  }
}
