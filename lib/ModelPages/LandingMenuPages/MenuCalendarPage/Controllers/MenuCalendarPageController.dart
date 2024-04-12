import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MenuCalendarPageController extends GetxController {
  var isMonthSelected = true.obs;
  var isWeekSelected = false.obs;
  var monthName = "".obs;

  CalendarController calendarController = CalendarController();

  updateSelection(index) {
    if (index == 0) {
      isMonthSelected.value = true;
      isWeekSelected.value = false;
    } else {
      isMonthSelected.value = false;
      isWeekSelected.value = true;
    }
  }

  getSelectList() {
    // updateSelection(0);
    return [isMonthSelected.value, isWeekSelected.value];
  }

  nextMonth() {
    print("next");
    monthName.value = calendarController.toStringShort();
  }

  previousMonth() {
    print("prev");
    monthName.value = "sept 23";
  }

  nextPrevious(int index) {
    if (index == 0)
      previousMonth();
    else
      nextMonth();
  }
}
