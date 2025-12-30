class LeaveHistoryModel {
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final double totalDays;
  final String status;

  LeaveHistoryModel({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.totalDays,
    required this.status,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      leaveType: json['leave_type'] as String,
      fromDate: DateTime.parse(json['fromdate'] as String),
      toDate: DateTime.parse(json['todate'] as String),
      totalDays: json['total_days'] as double,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type': leaveType,
      'fromdate': fromDate.toIso8601String(),
      'todate': toDate.toIso8601String(),
      'total_days': totalDays,
      'status': status,
    };
  }

  static List<LeaveHistoryModel> tempData = [
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2025-08-20",
      "total_days": 2,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Sick Leave",
      "date": "2025-07-15",
      "total_days": 1,
      "status": "Pending"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Casual Leave",
      "date": "2025-06-10",
      "total_days": 3,
      "status": "Rejected"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2025-05-05",
      "total_days": 5,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Sick Leave",
      "date": "2025-04-22",
      "total_days": 2,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Maternity Leave",
      "date": "2025-03-15",
      "total_days": 10,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Casual Leave",
      "date": "2025-02-05",
      "total_days": 1,
      "status": "Pending"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2025-01-25",
      "total_days": 4,
      "status": "Rejected"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Sick Leave",
      "date": "2024-12-12",
      "total_days": 2,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2024-11-30",
      "total_days": 3,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Casual Leave",
      "date": "2024-10-18",
      "total_days": 1,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Sick Leave",
      "date": "2024-09-10",
      "total_days": 2,
      "status": "Rejected"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2024-08-05",
      "total_days": 6,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Paternity Leave",
      "date": "2024-07-15",
      "total_days": 7,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Casual Leave",
      "date": "2024-06-20",
      "total_days": 2,
      "status": "Pending"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2024-05-12",
      "total_days": 5,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Sick Leave",
      "date": "2024-04-01",
      "total_days": 3,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2024-03-25",
      "total_days": 4,
      "status": "Rejected"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Casual Leave",
      "date": "2024-02-14",
      "total_days": 1,
      "status": "Approved"
    }),
    LeaveHistoryModel.fromJson({
      "leave_type": "Annual Leave",
      "date": "2024-01-05",
      "total_days": 3,
      "status": "Approved"
    }),
  ];
}
