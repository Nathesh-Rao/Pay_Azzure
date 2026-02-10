import 'package:intl/intl.dart';

class AttendanceReportModel {
  final DateTime? punchDate;
  final String? status;
  final String? punchInTime;
  final String? punchOutTime;
  final String? workingHours;

  AttendanceReportModel({
    this.punchDate, 
    this.status,
    this.punchInTime,
    this.punchOutTime,
    this.workingHours,
  });

  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
      punchDate: json['punchdate'] != null
          ? DateTime.tryParse(json['punchdate'])
          : null,
      status: json['status'],
      punchInTime: json['punch_intime'],
      punchOutTime: json['punch_outtime'],
      workingHours: json['workinghours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'punchdate': punchDate?.toIso8601String(),
      'status': status,
      'punch_intime': punchInTime,
      'punch_outtime': punchOutTime,
      'workinghours': workingHours,
    };
  }

  /// Returns "1 MON"
  String get formattedPunchDate {
    if (punchDate == null) return "";
    final day = DateFormat('d').format(punchDate!); // 1, 2, 3...
    final weekday =
        DateFormat('EEE').format(punchDate!).toUpperCase(); // MON, TUE...
    return "$day $weekday";
  }

  /// Returns formatted clock-in like "09:00 am"
  String get clockIn {
    if (punchInTime == null) return "";
    try {
      final parsed = DateFormat("HH:mm:ss").parse(punchInTime!);
      return DateFormat("hh:mm a").format(parsed).toLowerCase();
    } catch (_) {
      return punchInTime ?? "";
    }
  }

  /// Returns formatted clock-out like "06:15 pm"
  String get clockOut {
    if (punchOutTime == null) return "";
    try {
      final parsed = DateFormat("HH:mm:ss").parse(punchOutTime!);
      return DateFormat("hh:mm a").format(parsed).toLowerCase();
    } catch (_) {
      return punchOutTime ?? "";
    }
  }

  String get formattedWorkingHours {
    if (workingHours == null || !workingHours!.contains("to")) return "";

    try {
      final parts = workingHours!.split("to");
      if (parts.length != 2) return "";

      String startStr = parts[0].trim().replaceAll("@", ":");
      String endStr = parts[1].trim().replaceAll("@", ":");

      final start = DateFormat("hh:mm a").parse(startStr);
      final end = DateFormat("hh:mm a").parse(endStr);

      final diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;

      if (minutes == 0) {
        return "${hours}h";
      }
      return "${hours}h ${minutes}m";
    } catch (_) {
      return "";
    }
  }
}
