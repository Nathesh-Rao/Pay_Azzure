class LeaveDetailsModel {
  final String employee;
  final String leaveType;
  final double totalLeaves;
  final String allocatedDate;
  final double leavesTaken;

  LeaveDetailsModel({
    required this.employee,
    required this.leaveType,
    required this.totalLeaves,
    required this.allocatedDate,
    required this.leavesTaken,
  });

  factory LeaveDetailsModel.fromJson(Map<String, dynamic> json) {
    return LeaveDetailsModel(
      employee: json['employee'] ?? '',
      leaveType: json['leave_type'] ?? '',
      totalLeaves: (json['total_leaves'] ?? 0).toDouble(),
      allocatedDate: json['allocated_date'] ?? '',
      leavesTaken: (json['leaves_taken'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'leave_type': leaveType,
      'total_leaves': totalLeaves,
      'allocated_date': allocatedDate,
      'leaves_taken': leavesTaken,
    };
  }

  /// Optional: computed field for remaining leaves
  double get remainingLeaves => totalLeaves - leavesTaken;
}
