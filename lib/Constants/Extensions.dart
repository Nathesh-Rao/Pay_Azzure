import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as timeago;

extension StringExtensions on String {
  String getInitials({int subStringIndex = 3}) {
    var words = this
        .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join();

    return words.length >= 3 ? words.substring(0, subStringIndex) : words;
  }
}

//--------------------------------------------------------------

extension ColorExtensions on Color {
  Color darken([double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      alpha,
      (red * (1 - amount)).round(),
      (green * (1 - amount)).round(),
      (blue * (1 - amount)).round(),
    );
  }
}
//--------------------------------------------------------------

extension TimeAgoExtension on String {
  String timeAgo() {
    DateTime dateTime = DateTime.parse(this);
    return timeago.format(dateTime, locale: 'en');
  }
}
//-----------------------------------------------------------------

extension SpaceExtension on num {
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}

extension SkeletonizeExtension on Widget {
  Widget skeletonLoading(bool enabled) {
    return Skeletonizer(
      enabled: enabled,
      effect: PulseEffect(duration: Duration(milliseconds: 500)),
      enableSwitchAnimation: true,
      child: this,
    );
  }
}

extension DateTimeHourOffset on DateTime {
  DateTime copyWithHourOffset(int offset) {
    int baseHour = hour;

    if (baseHour < 9) {
      baseHour = 9;
    }

    return DateTime(
      year,
      month,
      day,
      baseHour + offset,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
