class PendingProcessFlowModel {
  String processname;
  String indexno;
  String displayicon;
  String tasktype;
  String taskgroupname;
  String taskname;
  String transid;
  String keyfield;
  String taskdefid;
  String taskstatus;
  String taskid;
  String keyvalue;
  String recordid;

  PendingProcessFlowModel.fromJson(Map<String, dynamic> json)
      : processname = json['processname'].toString() ?? '',
        indexno = json['indexno'].toString() ?? '',
        displayicon = json['displayicon'].toString() ?? '',
        tasktype = json['tasktype'].toString() ?? '',
        taskgroupname = json['taskgroupname'].toString() ?? '',
        taskname = json['taskname'].toString() ?? '',
        transid = json['transid'].toString() ?? '',
        keyfield = json['keyfield'].toString() ?? '',
        taskdefid = json['taskdefid'].toString() ?? '',
        taskstatus = json['taskstatus'].toString() ?? '',
        taskid = json['taskid'].toString() ?? '',
        keyvalue = json['keyvalue'].toString() ?? '',
        recordid = json['recordid'].toString() ?? '';

  Map<String, dynamic> toJson() => {
        'processname': processname,
        'indexno': indexno,
        'displayicon': displayicon,
        'tasktype': tasktype,
        'taskgroupname': taskgroupname,
        'taskname': taskname,
        'transid': transid,
        'keyfield': keyfield,
        'taskdefid': taskdefid,
        'taskstatus': taskstatus,
        'taskid': taskid,
        'keyvalue': keyvalue,
        'recordid': recordid
      };
}
