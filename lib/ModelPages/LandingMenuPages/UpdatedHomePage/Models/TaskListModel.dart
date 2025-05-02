import 'dart:convert';

class TaskListModel {
  final String? touser;
  final String? fromuser;
  final String? taskname;
  final String? eventdatetime;
  final String? displaytitle;
  final String? displaycontent;
  final String? tasktype;
  final String? rectype;
  final String? msgtype;
  final dynamic taskstatus;
  final String? cstatus;

  TaskListModel({
    required this.touser,
    required this.fromuser,
    required this.taskname,
    required this.eventdatetime,
    required this.displaytitle,
    required this.displaycontent,
    required this.tasktype,
    required this.rectype,
    required this.msgtype,
    required this.taskstatus,
    required this.cstatus,
  });

  factory TaskListModel.fromRawJson(String str) => TaskListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
        touser: json["touser"],
        fromuser: json["fromuser"],
        taskname: json["taskname"],
        eventdatetime: json["eventdatetime"],
        displaytitle: json["displaytitle"],
        displaycontent: json["displaycontent"],
        tasktype: json["tasktype"],
        rectype: json["rectype"],
        msgtype: json["msgtype"],
        taskstatus: json["taskstatus"],
        cstatus: json["cstatus"],
      );

  Map<String, dynamic> toJson() => {
        "touser": touser,
        "fromuser": fromuser,
        "taskname": taskname,
        "eventdatetime": eventdatetime,
        "displaytitle": displaytitle,
        "displaycontent": displaycontent,
        "tasktype": tasktype,
        "rectype": rectype,
        "msgtype": msgtype,
        "taskstatus": taskstatus,
        "cstatus": cstatus,
      };
}
