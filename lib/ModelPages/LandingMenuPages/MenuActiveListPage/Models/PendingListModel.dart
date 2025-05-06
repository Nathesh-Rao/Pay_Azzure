import 'package:get/get.dart';

class PendingListModel {
  String touser;
  String processname;
  String taskname;
  String taskid;
  String tasktype;
  String edatetime;
  String eventdatetime;
  String fromuser;
  String fromrole;
  String displayicon;
  String displaytitle;
  String displaycontent;
  String displaymcontent;
  String displaybuttons;
  String keyfield;
  String keyvalue;
  String transid;
  String priorindex;
  String indexno;
  String subindexno;
  String approvereasons;
  String defapptext;
  String returnreasons;
  String defrettext;
  String rejectreasons;
  String defregtext;
  String recordid;
  String approvalcomments;
  String rejectcomments;
  String returncomments;
  String rectype;
  String msgtype;
  String returnable;
  String initiator;
  String initiator_approval;
  String displaysubtitle;
  String amendment;
  String allowsend;
  String allowsendflg;
  String cmsg_appcheck;
  String cmsg_return;
  String cmsg_reject;
  String showbuttons;
  String hlink_transid;
  String hlink_params;

  var bulkApprove_isSelected = false.obs;

  PendingListModel.fromJson(Map<String, dynamic> json)
      : touser = json['touser'].toString() ?? "",
        processname = json['processname'].toString() ?? "",
        taskname = json['taskname'].toString() ?? "",
        taskid = json['taskid'].toString() ?? "",
        tasktype = json['tasktype'].toString() ?? "",
        edatetime = json['edatetime'].toString() ?? "",
        eventdatetime = json['eventdatetime'].toString() ?? "",
        fromuser = json['fromuser'].toString() ?? "",
        fromrole = json['fromrole'].toString() ?? "",
        displayicon = json['displayicon'].toString() ?? "",
        displaytitle = json['displaytitle'].toString() ?? "",
        displaycontent = json['displaycontent'].toString() ?? "",
        displaymcontent = json['displaymcontent'].toString() ?? "",
        displaybuttons = json['displaybuttons'].toString() ?? "",
        keyfield = json['keyfield'].toString() ?? "",
        keyvalue = json['keyvalue'].toString() ?? "",
        transid = json['transid'].toString() ?? "",
        priorindex = json['priorindex'].toString() ?? "",
        indexno = json['indexno'].toString() ?? "",
        subindexno = json['subindexno'].toString() ?? "",
        approvereasons = json['approvereasons'].toString() ?? "",
        defapptext = json['defapptext'].toString() ?? "",
        returnreasons = json['returnreasons'].toString() ?? "",
        defrettext = json['defrettext'].toString() ?? "",
        rejectreasons = json['rejectreasons'].toString() ?? "",
        defregtext = json['defregtext'].toString() ?? "",
        recordid = json['recordid'].toString() ?? "",
        approvalcomments = json['approvalcomments'].toString() ?? "",
        rejectcomments = json['rejectcomments'].toString() ?? "",
        returncomments = json['returncomments'].toString() ?? "",
        rectype = json['rectype'].toString() ?? "",
        msgtype = json['msgtype'].toString() ?? "",
        returnable = json['returnable'].toString() ?? "",
        initiator = json['initiator'].toString() ?? "",
        initiator_approval = json['initiator_approval'].toString() ?? "",
        displaysubtitle = json['displaysubtitle'].toString() ?? "",
        amendment = json['amendment'].toString() ?? "",
        allowsend = json['allowsend'].toString() ?? "",
        allowsendflg = json['allowsendflg'].toString() ?? "",
        cmsg_appcheck = json['cmsg_appcheck'].toString() ?? "",
        cmsg_return = json['cmsg_return'].toString() ?? "",
        cmsg_reject = json['cmsg_reject'].toString() ?? "",
        showbuttons = json['showbuttons'].toString() ?? "",
        hlink_transid = json['hlink_transid'].toString() ?? "",
        hlink_params = json['hlink_params'].toString() ?? "";

  Map<String, dynamic> toJson() => {
        'touser': touser,
        'processname': processname,
        'taskname': taskname,
        'taskid': taskid,
        'tasktype': tasktype,
        'edatetime': edatetime,
        'eventdatetime': eventdatetime,
        'fromuser': fromuser,
        'fromrole': fromrole,
        'displayicon': displayicon,
        'displaytitle': displaytitle,
        'displaycontent': displaycontent,
        'displaymcontent': displaymcontent,
        'displaybuttons': displaybuttons,
        'keyfield': keyfield,
        'keyvalue': keyvalue,
        'transid': transid,
        'priorindex': priorindex,
        'indexno': indexno,
        'subindexno': subindexno,
        'approvereasons': approvereasons,
        'defapptext': defapptext,
        'returnreasons': returnreasons,
        'defrettext': defrettext,
        'rejectreasons': rejectreasons,
        'defregtext': defregtext,
        'recordid': recordid,
        'approvalcomments': approvalcomments,
        'rejectcomments': rejectcomments,
        'returncomments': returncomments,
        'rectype': rectype,
        'msgtype': msgtype,
        'returnable': returnable,
        'initiator': initiator,
        'initiator_approval': initiator_approval,
        'displaysubtitle': displaysubtitle,
        'amendment': amendment,
        'allowsend': allowsend,
        'allowsendflg': allowsendflg,
        'cmsg_appcheck': cmsg_appcheck,
        'cmsg_return': cmsg_return,
        'cmsg_reject': cmsg_reject,
        'showbuttons': showbuttons,
        'hlink_transid': hlink_transid,
        'hlink_params': hlink_params,
      };
}

// class ActiveListModel_Old {
//   String? touser;
//   String? processname;
//   String? taskname;
//   String? taskid;
//   String? tasktype;
//   String? eventdatetime;
//   String? fromuser;
//   String? displayicon;
//   String? displaytitle;
//   String? displaycontent;
//   String? displaybuttons;
//   String? keyfield;
//   String? keyvalue;
//   String? transid;
//   double? recordid;
//   String? rectype;
//   String? msgtype;
//   String? returnable;
//   String? displaysubtitle;
//   String? allowsend;
//   String? allowsendflg;
//
//   ActiveListModel_Old({
//     this.touser,
//     this.processname,
//     this.taskname,
//     this.taskid,
//     this.tasktype,
//     this.eventdatetime,
//     this.fromuser,
//     this.displayicon,
//     this.displaytitle,
//     this.displaycontent,
//     this.displaybuttons,
//     this.keyfield,
//     this.keyvalue,
//     this.transid,
//     this.recordid,
//     this.rectype,
//     this.msgtype,
//     this.returnable,
//     this.displaysubtitle,
//     this.allowsend,
//     this.allowsendflg,
//   });
//
//   ActiveListModel_Old.fromJson(dynamic json) {
//     touser = json['touser'];
//     processname = json['processname'];
//     taskname = json['taskname'];
//     taskid = json['taskid'];
//     tasktype = json['tasktype'];
//     eventdatetime = json['eventdatetime'];
//     fromuser = json['fromuser'];
//     displayicon = json['displayicon'];
//     displaytitle = json['displaytitle'];
//     displaycontent = json['displaycontent'];
//     displaybuttons = json['displaybuttons'];
//     keyfield = json['keyfield'];
//     keyvalue = json['keyvalue'];
//     transid = json['transid'];
//     recordid = json['recordid'];
//     rectype = json['rectype'];
//     msgtype = json['msgtype'];
//     returnable = json['returnable'];
//     displaysubtitle = json['displaysubtitle'];
//     allowsend = json['allowsend'];
//     allowsendflg = json['allowsendflg'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['touser'] = touser;
//     map['processname'] = processname;
//     map['taskname'] = taskname;
//     map['taskid'] = taskid;
//     map['tasktype'] = tasktype;
//     map['eventdatetime'] = eventdatetime;
//     map['fromuser'] = fromuser;
//     map['displayicon'] = displayicon;
//     map['displaytitle'] = displaytitle;
//     map['displaycontent'] = displaycontent;
//     map['displaybuttons'] = displaybuttons;
//     map['keyfield'] = keyfield;
//     map['keyvalue'] = keyvalue;
//     map['transid'] = transid;
//     map['recordid'] = recordid;
//     map['rectype'] = rectype;
//     map['msgtype'] = msgtype;
//     map['returnable'] = returnable;
//     map['displaysubtitle'] = displaysubtitle;
//     map['allowsend'] = allowsend;
//     map['allowsendflg'] = allowsendflg;
//     return map;
//   }
// }
