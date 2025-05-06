import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class WidgetAttendancePanel extends StatelessWidget {
  WidgetAttendancePanel({super.key});
  final MenuHomePageController menuHomePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
          child: Visibility(
            visible: menuHomePageController.attendanceVisibility.value,
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attendance",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 1, color: MyColors.blue2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Am off today",
                                  style: TextStyle(color: MyColors.blue2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Visibility(
                            visible: menuHomePageController.isShowPunchIn.value,
                            child: GestureDetector(
                              onTap: () {
                                menuHomePageController.onClick_PunchIn();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MyColors.blue2,
                                    border: Border.all(width: 1, color: MyColors.blue2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Punch In",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: menuHomePageController.isShowPunchOut.value,
                            child: GestureDetector(
                              onTap: () {
                                menuHomePageController.onClick_PunchOut();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MyColors.blue2,
                                    border: Border.all(width: 1, color: MyColors.blue2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Punch Out",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: MyColors.grey.withOpacity(0.3)),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.timer_outlined),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shift Timing",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: TimelineTile(
                                      axis: TimelineAxis.vertical,
                                      alignment: TimelineAlign.start,
                                      indicatorStyle: IndicatorStyle(
                                        color: MyColors.green,
                                        width: 6,
                                      ),
                                      afterLineStyle: LineStyle(color: Colors.grey, thickness: 1),
                                      endChild: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(menuHomePageController.shift_start_time.value))),
                                      isFirst: true,
                                    ),
                                  ),
                                  Container(
                                      constraints: BoxConstraints(maxWidth: 100),
                                      child: TimelineTile(
                                        axis: TimelineAxis.vertical,
                                        alignment: TimelineAlign.start,
                                        indicatorStyle: IndicatorStyle(
                                          color: MyColors.red,
                                          width: 6,
                                        ),
                                        beforeLineStyle: LineStyle(color: Colors.grey, thickness: 1),
                                        endChild: Container(
                                            height: 30,
                                            padding: EdgeInsets.only(left: 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(menuHomePageController.shift_end_time.value))),
                                        isLast: true,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Container(width: 1, height: 70, color: Colors.grey.withOpacity(0.5)),
                          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(
                              "Last Login",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(width: 1, color: Colors.black.withOpacity(0.1))),
                                      child: Icon(
                                        Icons.person,
                                        color: MyColors.blue2.withOpacity(0.5),
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(menuHomePageController.last_login_date.value +
                                        " - " +
                                        menuHomePageController.last_login_time.value),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(width: 1, color: Colors.black.withOpacity(0.1))),
                                      child: Icon(
                                        Icons.location_on,
                                        color: MyColors.blue2.withOpacity(0.5),
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      menuHomePageController.last_login_location.value,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ]),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
