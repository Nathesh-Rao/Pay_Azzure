class LeaveOverviewModel {
  final String employee;
  final double balanceLeave;
  final String leaveType;
  final int noDays;
  final String date;
  final String approvedBy;
  final int pendingLeaves;

  LeaveOverviewModel({
    required this.employee,
    required this.balanceLeave,
    required this.leaveType,
    required this.noDays,
    required this.date,
    required this.approvedBy,
    required this.pendingLeaves,
  });

  factory LeaveOverviewModel.fromJson(Map<String, dynamic> json) {
    return LeaveOverviewModel(
      employee: json['employee'] ?? '',
      balanceLeave: (json['balance_leave'] ?? 0).toDouble(),
      leaveType: json['leave_type'] ?? '',
      noDays: (json['no_days'] ?? 0).toInt(),
      date: json['date'] ?? '',
      approvedBy: json['approved_by'] ?? '',
      pendingLeaves: (json['pending_leaves'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'balance_leave': balanceLeave,
      'leave_type': leaveType,
      'no_days': noDays,
      'date': date,
      'approved_by': approvedBy,
      'pending_leaves': pendingLeaves,
    };
  }
}
