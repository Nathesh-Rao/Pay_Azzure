class AttendanceOverviewModel {
  final bool hasPunchedIn;
  final bool hasPunchedOut;
  final DateTime scheduledPunchInTime;
  final DateTime scheduledPunchOutTime;
  final PunchDetails? punchInDetails;
  final PunchDetails? punchOutDetails;
  final bool isWorkLogUpdated;

  AttendanceOverviewModel({
    required this.hasPunchedIn,
    required this.hasPunchedOut,
    required this.scheduledPunchInTime,
    required this.scheduledPunchOutTime,
    this.punchInDetails,
    this.punchOutDetails,
    required this.isWorkLogUpdated,
  });

  Map<String, dynamic> toJson() => {
        "has_punched_in": hasPunchedIn,
        "has_punched_out": hasPunchedOut,
        "scheduled_punch_in_time": scheduledPunchInTime.toIso8601String(),
        "scheduled_punch_out_time": scheduledPunchOutTime.toIso8601String(),
        "punch_in_details": punchInDetails?.toJson(),
        "punch_out_details": punchOutDetails?.toJson(),
        "is_work_log_updated": isWorkLogUpdated,
      };

  static AttendanceOverviewModel fromJson(Map<String, dynamic> json) => AttendanceOverviewModel(
        hasPunchedIn: json["has_punched_in"],
        hasPunchedOut: json["has_punched_out"],
        scheduledPunchInTime: DateTime.parse(json["scheduled_punch_in_time"]),
        scheduledPunchOutTime: DateTime.parse(json["scheduled_punch_out_time"]),
        punchInDetails: json["punch_in_details"] != null ? PunchDetails.fromJson(json["punch_in_details"]) : null,
        punchOutDetails: json["punch_out_details"] != null ? PunchDetails.fromJson(json["punch_out_details"]) : null,
        isWorkLogUpdated: json["is_work_log_updated"],
      );

  // ---------- Temp Data ----------
  static AttendanceOverviewModel beforePunchIn() {
    return AttendanceOverviewModel(
      hasPunchedIn: false,
      hasPunchedOut: false,
      scheduledPunchInTime: DateTime.parse("2025-08-13T09:00:00Z"),
      scheduledPunchOutTime: DateTime.parse("2025-08-13T18:00:00Z"),
      isWorkLogUpdated: false,
    );
  }

  static AttendanceOverviewModel afterPunchIn() {
    return AttendanceOverviewModel(
      hasPunchedIn: true,
      hasPunchedOut: false,
      scheduledPunchInTime: DateTime.parse("2025-08-13T09:00:00Z"),
      scheduledPunchOutTime: DateTime.parse("2025-08-13T18:00:00Z"),
      punchInDetails: PunchDetails(
        time: DateTime.parse("2025-08-13T09:05:00Z"),
        latitude: 12.9715987,
        longitude: 77.594566,
      ),
      isWorkLogUpdated: false,
    );
  }

  static AttendanceOverviewModel afterPunchOut() {
    return AttendanceOverviewModel(
      hasPunchedIn: true,
      hasPunchedOut: true,
      scheduledPunchInTime: DateTime.parse("2025-08-13T09:00:00Z"),
      scheduledPunchOutTime: DateTime.parse("2025-08-13T18:00:00Z"),
      punchInDetails: PunchDetails(
        time: DateTime.parse("2025-08-13T09:05:00Z"),
        latitude: 12.9715987,
        longitude: 77.594566,
      ),
      punchOutDetails: PunchDetails(
        time: DateTime.parse("2025-08-13T18:02:00Z"),
        latitude: 12.9716000,
        longitude: 77.5945700,
      ),
      isWorkLogUpdated: true,
    );
  }
}

class PunchDetails {
  final DateTime time;
  final double latitude;
  final double longitude;

  PunchDetails({
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        "time": time.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
      };

  static PunchDetails fromJson(Map<String, dynamic> json) => PunchDetails(
        time: DateTime.parse(json["time"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}
