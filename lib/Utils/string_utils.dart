import 'package:intl/intl.dart';

class StringUtils {
  static String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    return DateFormat('EEE, dd MMMM yyyy').format(date);
  }

  static String maskAmount(String amount) {
    if (amount.isEmpty) return amount;

    const int visibleCount = 2;

    final int maskLength = amount.length - visibleCount;
    final String visiblePart =
        amount.substring(amount.length - visibleCount, amount.length);

    final String maskedPart =
        List.filled(maskLength < 0 ? 0 : maskLength, '*').join();

    return maskedPart + visiblePart;
  }

  getProperMothFormat0m(int index) {
    var monthIndex = '';

    if (index > 10) {
      monthIndex = "0$index";
    } else {
      monthIndex = index.toString();
    }

    return monthIndex;
  }
}
