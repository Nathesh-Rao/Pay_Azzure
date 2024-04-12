import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuCalendarPage/Controllers/MenuCalendarPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetSlidingNotification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MenuCalendarPage extends StatelessWidget {
  MenuCalendarPage({super.key});
  final MenuCalendarPageController menuCalendarPageController = Get.put(MenuCalendarPageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetSlidingNotificationPanel(),
        SizedBox(height: 5),
        // Obx(() => Container(
        //       height: 50,
        //       decoration:
        //           BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)))),
        //       child: Row(
        //         children: [
        //           SizedBox(width: 20),
        //           ToggleButtons(
        //             children: [
        //               Center(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(left: 10),
        //                   child: Icon(
        //                     Icons.arrow_back_ios,
        //                     color: HexColor("737373"),
        //                   ),
        //                 ),
        //               ),
        //               Center(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(left: 5, right: 5),
        //                   child: Icon(
        //                     Icons.arrow_forward_ios,
        //                     color: HexColor('737373'),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //             isSelected: [false, false],
        //             borderRadius: BorderRadius.circular(5),
        //             constraints: BoxConstraints(minHeight: 30, maxHeight: 30),
        //             onPressed: (index) => menuCalendarPageController.nextPrevious(index),
        //           ),
        //           Expanded(
        //             child: Center(
        //               child: Text(
        //                 menuCalendarPageController.monthName.value,
        //                 style: GoogleFonts.roboto(
        //                     textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('161616'))),
        //               ),
        //             ),
        //           ),
        //           ToggleButtons(
        //             children: [
        //               Container(
        //                 width: 60,
        //                 decoration: menuCalendarPageController.isMonthSelected.value == true
        //                     ? BoxDecoration(color: HexColor("009EF7"))
        //                     : BoxDecoration(),
        //                 child: Center(
        //                   child: Text(
        //                     "Month",
        //                     style: menuCalendarPageController.isMonthSelected.value == true
        //                         ? TextStyle(color: Colors.white)
        //                         : TextStyle(color: HexColor("707070")),
        //                   ),
        //                 ),
        //               ),
        //               Container(
        //                 width: 60,
        //                 decoration: menuCalendarPageController.isWeekSelected.value == true
        //                     ? BoxDecoration(color: HexColor("009EF7"))
        //                     : BoxDecoration(),
        //                 child: Center(
        //                     child: Text(
        //                   "Week",
        //                   style: menuCalendarPageController.isWeekSelected.value == true
        //                       ? TextStyle(color: Colors.white)
        //                       : TextStyle(color: HexColor("707070")),
        //                 )),
        //               ),
        //             ],
        //             borderRadius: BorderRadius.circular(5),
        //             constraints: BoxConstraints(minHeight: 30, maxHeight: 30),
        //             isSelected: menuCalendarPageController.getSelectList(),
        //             onPressed: (index) => menuCalendarPageController.updateSelection(index),
        //           ),
        //           SizedBox(width: 20),
        //         ],
        //       ),
        //     )),
        SizedBox(height: 5),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            child: SfCalendar(
              showNavigationArrow: true,
              showCurrentTimeIndicator: true,
              showTodayButton: false,
              view: CalendarView.month,
              allowViewNavigation: true,
              headerStyle: CalendarHeaderStyle(
                textAlign: TextAlign.center,
              ),
              allowedViews: [CalendarView.month, CalendarView.week],
              monthViewSettings: MonthViewSettings(
                agendaItemHeight: 4,
                monthCellStyle: MonthCellStyle(
                    textStyle: TextStyle(color: Colors.black, fontSize: 20),
                    trailingDatesTextStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
                    leadingDatesTextStyle: TextStyle(color: Colors.grey.withOpacity(0.4))),
              ),
              controller: menuCalendarPageController.calendarController,
            ),
          ),
        ),
        SizedBox(height: Get.height * 0.1)
      ],
    );
  }
}
/*
Container(
            height: 50,
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)))),
            child: Row(
              children: [
                SizedBox(width: 20),
                ToggleButtons(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: HexColor("737373"),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: HexColor('737373'),
                        ),
                      ),
                    ),
                  ],
                  isSelected: [false, false],
                  borderRadius: BorderRadius.circular(5),
                  constraints: BoxConstraints(minHeight: 30, maxHeight: 30),
                  onPressed: (index) => menuCalendarPageController.nextPrevious(index),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      menuCalendarPageController.monthName.value,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('161616'))),
                    ),
                  ),
                ),
                ToggleButtons(
                  children: [
                    Container(
                      width: 60,
                      decoration: menuCalendarPageController.isMonthSelected.value == true
                          ? BoxDecoration(color: HexColor("009EF7"))
                          : BoxDecoration(),
                      child: Center(
                        child: Text(
                          "Month",
                          style: menuCalendarPageController.isMonthSelected.value == true
                              ? TextStyle(color: Colors.white)
                              : TextStyle(color: HexColor("707070")),
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      decoration: menuCalendarPageController.isWeekSelected.value == true
                          ? BoxDecoration(color: HexColor("009EF7"))
                          : BoxDecoration(),
                      child: Center(
                          child: Text(
                        "Week",
                        style: menuCalendarPageController.isWeekSelected.value == true
                            ? TextStyle(color: Colors.white)
                            : TextStyle(color: HexColor("707070")),
                      )),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5),
                  constraints: BoxConstraints(minHeight: 30, maxHeight: 30),
                  isSelected: menuCalendarPageController.getSelectList(),
                  onPressed: (index) => menuCalendarPageController.updateSelection(index),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          Expanded(child: Center(child: Text("Calendar")))
 */

/*

Expanded(child: Center(child: Text("Calendar")))WebViewCalendar(Const.getFullProjectUrl("Entrypoint"))
 */
