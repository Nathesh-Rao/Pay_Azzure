class AttendanceDetailsModel {
  String? username;
  String? actualIntime;
  String? intime;
  String? actualOuttime;
  String? outtime;
  String? intimeLatitude;
  String? intimeLongitude;
  String? outtimeLatitude;
  String? outtimeLongitude;
  String? worksheetUpdateStatus;
  String message;

  AttendanceDetailsModel({
    this.username,
    this.actualIntime,
    this.intime,
    this.actualOuttime,
    this.outtime,
    this.intimeLatitude,
    this.intimeLongitude,
    this.outtimeLatitude,
    this.outtimeLongitude,
    this.worksheetUpdateStatus,
    this.message = "",
  });

  /// Factory constructor for JSON parsing
  factory AttendanceDetailsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceDetailsModel(
      username: json['username'],
      actualIntime: json['actual_intime'],
      intime: json['intime'],
      actualOuttime: json['actual_outtime'],
      outtime: json['outtime'],
      intimeLatitude: json['intime_latitude'],
      intimeLongitude: json['intime_longitude'],
      outtimeLatitude: json['outtime_latitude'],
      outtimeLongitude: json['outtime_longitude'],
      worksheetUpdateStatus: json['worksheet_update_status'],
      message: json['message'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'actual_intime': actualIntime,
      'intime': intime,
      'actual_outtime': actualOuttime,
      'outtime': outtime,
      'intime_latitude': intimeLatitude,
      'intime_longitude': intimeLongitude,
      'outtime_latitude': outtimeLatitude,
      'outtime_longitude': outtimeLongitude,
      'worksheet_update_status': worksheetUpdateStatus,
      'message': message,
    };
  }
}
