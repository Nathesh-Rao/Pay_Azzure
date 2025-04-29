class PendingTaskModel {
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
  String displaymcontent;
  String displaycontent;
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
  String returnable;
  String taskstatus;
  String statusreason;
  String statustext;
  String username;
  String ispending;
  String initiator;
  String initiator_approval;
  String displaysubtitle;
  String allowsend;
  String allowsendflg;
  String cmsg_appcheck;
  String cmsg_return;
  String cmsg_reject;
  String showbuttons;

  PendingTaskModel.fromJson(Map<String, dynamic> json)
      : touser = json['touser'].toString() ?? '',
        processname = json['processname'].toString() ?? '',
        taskname = json['taskname'].toString() ?? '',
        taskid = json['taskid'].toString() ?? '',
        tasktype = json['tasktype'].toString() ?? '',
        edatetime = json['edatetime'].toString() ?? '',
        eventdatetime = json['eventdatetime'].toString() ?? '',
        fromuser = json['fromuser'].toString() ?? '',
        fromrole = json['fromrole'].toString() ?? '',
        displayicon = json['displayicon'].toString() ?? '',
        displaytitle = json['displaytitle'].toString() ?? '',
        displaymcontent = json['displaymcontent'].toString() ?? '',
        displaycontent = json['displaycontent'].toString() ?? '',
        displaybuttons = json['displaybuttons'].toString() ?? '',
        keyfield = json['keyfield'].toString() ?? '',
        keyvalue = json['keyvalue'].toString() ?? '',
        transid = json['transid'].toString() ?? '',
        priorindex = json['priorindex'].toString() ?? '',
        indexno = json['indexno'].toString() ?? '',
        subindexno = json['subindexno'].toString() ?? '',
        approvereasons = json['approvereasons'].toString() ?? '',
        defapptext = json['defapptext'].toString() ?? '',
        returnreasons = json['returnreasons'].toString() ?? '',
        defrettext = json['defrettext'].toString() ?? '',
        rejectreasons = json['rejectreasons'].toString() ?? '',
        defregtext = json['defregtext'].toString() ?? '',
        recordid = json['recordid'].toString() ?? '',
        approvalcomments = json['approvalcomments'].toString() ?? '',
        rejectcomments = json['rejectcomments'].toString() ?? '',
        returncomments = json['returncomments'].toString() ?? '',
        returnable = json['returnable'].toString() ?? '',
        taskstatus = json['taskstatus'].toString() ?? '',
        statusreason = json['statusreason'].toString() ?? '',
        statustext = json['statustext'].toString() ?? '',
        username = json['username'].toString() ?? '',
        ispending = json['ispending'].toString() ?? '',
        initiator = json['initiator'].toString() ?? '',
        initiator_approval = json['initiator_approval'].toString() ?? '',
        displaysubtitle = json['displaysubtitle'].toString() ?? '',
        allowsend = json['allowsend'].toString() ?? '',
        allowsendflg = json['allowsendflg'].toString() ?? '',
        cmsg_appcheck = json['cmsg_appcheck'].toString() ?? '',
        cmsg_return = json['cmsg_return'].toString() ?? '',
        cmsg_reject = json['cmsg_reject'].toString() ?? '',
        showbuttons = json['showbuttons'].toString() ?? '';

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
        'displaymcontent': displaymcontent,
        'displaycontent': displaycontent,
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
        'returnable': returnable,
        'taskstatus': taskstatus,
        'statusreason': statusreason,
        'statustext': statustext,
        'username': username,
        'ispending': ispending,
        'initiator': initiator,
        'initiator_approval': initiator_approval,
        'displaysubtitle': displaysubtitle,
        'allowsend': allowsend,
        'allowsendflg': allowsendflg,
        'cmsg_appcheck': cmsg_appcheck,
        'cmsg_return': cmsg_return,
        'cmsg_reject': cmsg_reject,
        'showbuttons': showbuttons,
      };
}
