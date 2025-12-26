import 'package:animate_do/animate_do.dart';
import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpertflutter/Constants/Enums.dart';
import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/app_styles.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/AttendanceController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/attendance/secondary_button_widget.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/icon_label_widget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:one_clock/one_clock.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceLogHeaderWidget extends GetView<AttendanceController> {
  const AttendanceLogHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 400),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: controller.isLogExpanded.value ? 180 : 230,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MyColors.violetBorder,
                  )),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      //   color: MyColors.violetBorder,
                      // ),
                      gradient: LinearGradient(
                        colors: [
                          MyColors.gradientBlue,
                          MyColors.gradientViolet,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    height: controller.isLogExpanded.value ? 35 : 70,
                    child: Center(
                        child: Text(
                      _getAttendanceInfoHeadText(),
                      style: AppStyles.actionButtonStyle
                          .copyWith(color: Colors.white),
                    )),
                  ),
                  _getAttendanceStateWidget(controller.attendanceState.value),
                ],
              ),
            ).skeletonLoading(controller.isAttendanceDetailsIsLoading.value),
          ),
          // Obx(() => AnimatedSwitcherPlus.revealY(
          //       duration: Duration(milliseconds: 400),
          //       child: controller.isLogExpanded.value
          //           ? SizedBox.shrink()
          //           : _getActionButtonWidget(controller.attendanceState.value),
          //     ).skeletonLoading(controller.isAttendanceDetailsIsLoading.value))
        ],
      ),
    );
  }

  Widget _getAttendanceStateWidget(AttendanceState state) {
    switch (state) {
      case AttendanceState.notPunchedIn:
        return Expanded(child: _beforeClockedInWidget());
      case AttendanceState.punchedIn:
        return Expanded(
            flex: 2,
            child: Row(
              children: [
                _getAttendanceInfoMainWidget(),
                10.horizontalSpace,
                _getAttendanceInfoSecondWidget(),
              ],
            ));
      case AttendanceState.punchedOut:
        return Expanded(child: _punchedOutWidget());
      case AttendanceState.leave:
        return Expanded(child: _leaveWidget());
      case AttendanceState.holiday:
        return Expanded(child: _holidayWidget());
      case AttendanceState.error:
        return Expanded(child: _noDetailsAvailableWidget());
    }
  }

  Widget _leaveWidget() {
    var message =
        controller.attendanceDetails.value?.message.toLowerCase() ?? '';
    var text = "";
    var image = "assets/lotties/relaxing.json";
    if (message.contains("sick")) {
      text = "Hope you feel better soon! 🛌 Take care today.";
      image = "assets/lotties/sick1.json";
    } else if (message.contains("earned")) {
      text = "Enjoy your well-deserved leave today! ⛴️";
    } else if (message.contains("casual")) {
      text = "Take it easy and enjoy your casual leave! ☀️";
      image = "assets/lotties/car.json";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Lottie.asset(
            image,
            // width: 150.w,
            // height: 150.w,
            // fit: BoxFit.cover,
          ),
        ),
        10.horizontalSpace,
        Expanded(
            child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MyColors.flatButtonColorBlue.withAlpha(30),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: MyColors.flatButtonColorBlue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )),
      ],
    );
  }

  Widget _punchedOutWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Lottie.asset("assets/lotties/cycle.json"),
          ),
          10.horizontalSpace,
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.baseYellow.withAlpha(10),
            ),
            child: Center(
              child: Text(
                "You have been successfully Clocked Out! 🚌",
                style: GoogleFonts.poppins(
                  color: MyColors.baseYellow,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )),
        ],
      );
  Widget _holidayWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Lottie.asset("assets/lotties/relaxing2.json"),
          ),
          10.horizontalSpace,
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.baseYellow.withAlpha(10),
            ),
            child: Center(
              child: Text(
                "Happy Holidays! Enjoy your day off! 🚌",
                style: GoogleFonts.poppins(
                  color: MyColors.baseYellow,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )),
        ],
      );

  Widget _beforeClockedInWidget() => ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Row(
          children: [
            Expanded(child: _clockWidget()),
            Expanded(
                child: Column(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.chipCardWidgetColorBlue.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.location_circle,
                        color: MyColors.chipCardWidgetColorBlue,
                      ),
                      10.horizontalSpace,
                      Obx(() => Flexible(
                            child: AutoSizeText(
                              maxFontSize: 10,
                              minFontSize: 3,
                              controller.clockInLocation.value,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: MyColors.chipCardWidgetColorBlue,
                              ),
                            ),
                          ))
                    ],
                  ),
                )),
                // 10.verticalSpace,
                // Expanded(
                //   child: PrimaryButtonWidget(
                //     height: double.infinity,
                //     margin: EdgeInsets.zero,
                //     key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                //     isLoading: controller.attendanceAppbarSwitchIsLoading.value,
                //     onPressed: controller.onAttendanceClockInCardClick,
                //     label: "ClockInn 🌞",
                //     backgroundColor: MyColors.taskClockInWidgetColorPurple,
                //     labelStyle: AppStyles.textButtonStyle.copyWith(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ))
          ],
        ),
      );

  Widget _clockWidget() => Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: AnalogClock(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          isLive: true,
          hourHandColor: MyColors.primaryActionColorDarkBlue,
          minuteHandColor: MyColors.primaryActionColorDarkBlue,
          showSecondHand: true,
          numberColor: MyColors.primaryActionColorDarkBlue,
          secondHandColor: MyColors.baseRed,
          showNumbers: true,
          showAllNumbers: true,
          textScaleFactor: 1,
          showTicks: true,
          showDigitalClock: true,
          datetime: DateTime.now(),
        ),
      );

  Widget statusChip(String text, Color color) => Container(
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(5),
        width: 100,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 7,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      );

  Widget _getActionButtonWidget(AttendanceState state) {
    var bgColor = MyColors.blue9;
    var primaryLabel = '';
    var isVisible = true;
    var isPunchedInn = false;

    switch (state) {
      case AttendanceState.notPunchedIn:
        primaryLabel = "Clocck In";
        bgColor = MyColors.chipCardWidgetColorGreen;
        isVisible = true;
        isPunchedInn = false;
        break;

      case AttendanceState.punchedIn:
        primaryLabel = "Clocck Out";
        bgColor = MyColors.baseRed;
        isVisible = true;
        isPunchedInn = true;
        break;

      case AttendanceState.punchedOut:
      case AttendanceState.leave:
      case AttendanceState.holiday:
      case AttendanceState.error:
        primaryLabel = "";
        bgColor = MyColors.blue9;
        isVisible = false;
        isPunchedInn = false;
        break;
    }

    return Row(spacing: 10, children: [
      Flexible(
          child: SecondaryButtonWidget(
              margin: EdgeInsets.only(top: 10),
              backgroundColor: MyColors.blue10,
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Icon(
                    Icons.access_alarm_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  Text(
                    "Action",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ))),
      if (isVisible)
        Flexible(
            child: SecondaryButtonWidget(
                margin: EdgeInsets.only(top: 10),
                backgroundColor: bgColor,
                onPressed: () {
                  controller.onAttendnaceLogClockButtonClick(isPunchedInn);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Icon(
                      CupertinoIcons.hand_point_right_fill,
                      size: 18,
                      color: Colors.white,
                    ),
                    Text(
                      primaryLabel,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )))
    ]);
  }

  Widget _buttonRow() => Row(
        spacing: 10,
        children: [
          Flexible(
              child: SecondaryButtonWidget(
                  margin: EdgeInsets.zero,
                  backgroundColor: MyColors.blue10,
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.access_alarm_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      Text(
                        "Action",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ))),
          Flexible(
              child: SecondaryButtonWidget(
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  backgroundColor: MyColors.blue9,
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Icon(
                        CupertinoIcons.hand_point_right_fill,
                        size: 18,
                        color: Colors.white,
                      ),
                      Text(
                        "Clock out",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ))),
        ],
      );

  Widget _noDetailsAvailableWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.clear_circled_solid,
              color: MyColors.baseRed),
          10.horizontalSpace,
          const Text("No data found"),
        ],
      );

  _getAttendanceInfoHeadText() {
    var text = '';
    switch (controller.attendanceState.value) {
      case AttendanceState.punchedIn:
        text = controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualOuttime}");
        break;
      case AttendanceState.punchedOut:
        text = "Punched out at ${controller.attendanceDetails.value?.outtime}";
        break;
      case AttendanceState.holiday:
        text = "HOLIDAY";
        break;
      case AttendanceState.leave:
        text = "On Leave";
        break;
      default:
        text = controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualIntime}");
    }

    controller.attendanceState.value == AttendanceState.punchedIn
        ? controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualOuttime}")
        : controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualIntime}");
    return text;
  }

  Widget _getAttendanceInfoMainWidget() {
    return Expanded(
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: MyColors.chipCardWidgetColorGreen,
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 10,
                        color: MyColors.chipCardWidgetColorGreen,
                      ),
                      Text(
                        // controller.clockedInTimeStatus(${controller.attendanceDetails.value?.intime}, expectedTimeStr),
                        "",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              RichText(
                  key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                  text: TextSpan(
                      text: "${controller.attendanceDetails.value?.intime}",
                      style: AppStyles.attendanceWidgetTimeStyle,
                      children: [
                        TextSpan(
                          text: "",
                          style: AppStyles.attendanceWidgetTimeStyle
                              .copyWith(fontSize: 12),
                        )
                      ])),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Clocked In",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAttendanceInfoSecondWidget() {
    var signInWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location,
                color: MyColors.chipCardWidgetColorRed,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10,
                    color: MyColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "In Office",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          Obx(
            () => Text(
              // "${controller.clockInLocation.valuelit("\n")[0].replaceFirst("Name:", "").trim()}\n${controller.clockInLocation.valuelit("\n")[4].replaceFirst("Postal code:", "").trim()}",
              controller.clockInLocation.value,
              style: AppStyles.attendanceWidgetTimeStyle.copyWith(fontSize: 10),
            ),
          ),
          5.verticalSpace,
        ],
      ),
    );

    var signOutWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: MyColors.chipCardWidgetColorGreen,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10,
                    color: MyColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "On time",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          RichText(
              key: ValueKey(controller.attendanceAppbarSwitchValue.value),
              text: TextSpan(
                  text: "${controller.attendanceDetails.value?.outtime}",
                  style: AppStyles.attendanceWidgetTimeStyle,
                  children: [
                    TextSpan(
                      text: "",
                      style: AppStyles.attendanceWidgetTimeStyle
                          .copyWith(fontSize: 12),
                    )
                  ])),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Clocked Out",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    var noLocationWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.baseRed.withAlpha(50)),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColors.baseRed.withAlpha(20),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.location_circle,
                color: MyColors.baseRed,
              ),
              10.verticalSpace,
              Text(
                "Location is disabled",
                style: AppStyles.actionButtonStyle.copyWith(
                  color: MyColors.baseRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    var loadingWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.blue10.withAlpha(50)),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColors.blue10.withAlpha(20),
        ),
        child: Center(
          child: CupertinoActivityIndicator(
            color: MyColors.blue10,
          ),
        ),
      ),
    );

    return FutureBuilder<PermissionStatus>(
      future: Permission.location.status,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
              child: ZoomIn(
                  duration: const Duration(milliseconds: 400),
                  child: loadingWidget));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error checking location permission"));
        }

        if (snapshot.hasData) {
          final status = snapshot.data!;

          if (status.isDenied ||
              status.isRestricted ||
              status.isPermanentlyDenied) {
            return noLocationWidget;
          }

          if (controller.isClockedOut.value) {
            return Expanded(
              child: ZoomIn(
                duration: const Duration(milliseconds: 400),
                child: signOutWidget,
              ),
            );
          }

          return Expanded(
            child: ZoomIn(
              duration: const Duration(milliseconds: 400),
              child: signInWidget,
            ),
          );
        }

        return loadingWidget;
      },
    );
  }
}

class AttendanceLogHeaderWidget1 extends GetView<AttendanceController> {
  const AttendanceLogHeaderWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconLabelWidget(iconColor: Color(0xff8371EC), label: "Attendance"),
          10.verticalSpace,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dashboardHeadWidget(),
              Obx(
                () => AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  onEnd: controller.isLogExpandedAssist.toggle,
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: controller.isLogExpanded.value ? 220 : 265,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: MyColors.violetBorder,
                      )),
                  child: Obx(
                    () => controller.isLogExpandedAssist.value
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              controller.isLogExpanded.value
                                  ? SizedBox.shrink()
                                  : controller.isClockedIn.value
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            5.verticalSpace,
                                            Text(
                                              "You are in the Clock-Out area now , Clock-Out available from ${controller.attendanceDetails.value?.actualOuttime}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Remaining time until you can clock out is 0 min ",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "Please clock in before ${controller.attendanceDetails.value?.actualIntime}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              30.verticalSpace,
                              Obx(
                                () => controller.isClockedIn.value
                                    ? Expanded(
                                        child: Row(
                                        children: [
                                          _getAttendanceInfoMainWidget(),
                                          10.horizontalSpace,
                                          _getAttendanceInfoSecondWidget(),
                                        ],
                                      ))
                                    : Expanded(child: _beforeClockedInWidget()),
                              ),
                              20.verticalSpace,
                              Container(
                                decoration: BoxDecoration(
                                    color: MyColors.violetBorder.withAlpha(50),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Update your work sheet before clock out",
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _dashboardHeadWidget() => Container(
        height: 23,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          gradient: LinearGradient(
            colors: [
              MyColors.gradientBlue,
              MyColors.gradientViolet,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            10.horizontalSpace,
            Obx(
              () => Text(
                "60 mins to clock-out ${controller.isLogExpandedAssist.value}",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ).skeletonLoading(false);

  Widget _getAttendanceInfoMainWidget() {
    return Expanded(
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: MyColors.chipCardWidgetColorGreen,
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 10,
                        color: MyColors.chipCardWidgetColorGreen,
                      ),
                      Text(
                        "On time",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              RichText(
                  key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                  text: TextSpan(
                      text: "${controller.attendanceDetails.value?.intime}",
                      style: AppStyles.attendanceWidgetTimeStyle,
                      children: [
                        TextSpan(
                          text: "",
                          style: AppStyles.attendanceWidgetTimeStyle
                              .copyWith(fontSize: 12),
                        )
                      ])),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Clocked In",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAttendanceInfoSecondWidget() {
    var signInWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location,
                color: MyColors.chipCardWidgetColorRed,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10,
                    color: MyColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "In Office",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          Text(
            "${controller.clockInLocation.value.split("\n")[0].replaceFirst("Name:", "").trim()}\n${controller.clockInLocation.value.split("\n")[4].replaceFirst("Postal code:", "").trim()}",
            style: AppStyles.attendanceWidgetTimeStyle.copyWith(fontSize: 10),
          ),
          5.verticalSpace,
        ],
      ),
    );

    var signOutWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: MyColors.chipCardWidgetColorGreen,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10,
                    color: MyColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "On time",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          RichText(
              key: ValueKey(controller.attendanceAppbarSwitchValue.value),
              text: TextSpan(
                  text: "${controller.attendanceDetails.value?.outtime}",
                  style: AppStyles.attendanceWidgetTimeStyle,
                  children: [
                    TextSpan(
                      text: "",
                      style: AppStyles.attendanceWidgetTimeStyle
                          .copyWith(fontSize: 12),
                    )
                  ])),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Clocked Out",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (controller.isClockedOut.value) {
      return Expanded(
        child: ZoomIn(
          duration: Duration(milliseconds: 400),
          child: signOutWidget,
        ),
      );
    }

    return Expanded(
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: signInWidget,
      ),
    );
  }

  Widget _beforeClockedInWidget() => ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Row(
          children: [
            // Expanded(
            //     child: PrimaryButtonWidget(
            //   height: double.infinity,
            //   margin: EdgeInsets.zero,
            //   key: ValueKey(controller.attendanceAppbarSwitchValue.value),
            //   isLoading: controller.attendanceAppbarSwitchIsLoading.value,
            //   onPressed: controller.onAttendanceClockInCardClick,
            //   label: "ClockInn 🌞",
            //   backgroundColor: MyColors.taskClockInWidgetColorPurple,
            //   labelStyle: AppStyles.textButtonStyle.copyWith(
            //     color: Colors.white,
            //   ),
            // ))
          ],
        ),
      );
}
