class BulkApprovalCountModel {
  String processname;
  String pendingapprovals;

  @override
  String toString() {
    return 'processname: $processname, pendingapprovals: $pendingapprovals';
  }

  BulkApprovalCountModel.fromJson(Map<String, dynamic> json)
      : processname = json['processname'].toString() ?? '',
        pendingapprovals = json['pendingapprovals'].toString() ?? '';

  Map<String, dynamic> toJson() => {
    'processname': processname,
    'pendingapprovals': pendingapprovals
  };
}
