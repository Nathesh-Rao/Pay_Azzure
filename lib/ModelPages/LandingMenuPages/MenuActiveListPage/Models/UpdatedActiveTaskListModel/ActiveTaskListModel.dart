import 'dart:convert';

import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Models/PendingListModel.dart';

class ActiveTaskListModel {
  String? touser;
  dynamic processname;
  dynamic taskname;
  String? taskid;
  dynamic tasktype;
  String? edatetime;
  String? eventdatetime;
  String? fromuser;
  dynamic fromrole;
  dynamic displayicon;
  String? displaytitle;
  dynamic displaymcontent;
  String? displaycontent;
  dynamic displaybuttons;
  dynamic keyfield;
  dynamic keyvalue;
  String? transid;
  double? priorindex;
  double? indexno;
  double? subindexno;
  dynamic approvereasons;
  dynamic defapptext;
  dynamic returnreasons;
  dynamic defrettext;
  dynamic rejectreasons;
  dynamic defregtext;
  double? recordid;
  dynamic approvalcomments;
  dynamic rejectcomments;
  dynamic returncomments;
  String? rectype;
  String? msgtype;
  String? returnable;
  dynamic initiator;
  dynamic initiatorApproval;
  dynamic displaysubtitle;
  dynamic amendment;
  String? allowsend;
  String? allowsendflg;
  dynamic cmsgAppcheck;
  dynamic cmsgReturn;
  dynamic cmsgReject;
  dynamic showbuttons;
  dynamic hlink;
  String? hlinkTransid;
  String? hlinkParams;
  dynamic taskstatus;
  dynamic statusreason;
  dynamic statustext;
  dynamic cancelremarks;
  dynamic cancelledby;
  dynamic cancelledon;
  dynamic cancel;
  dynamic username;
  String? cstatus;

  ActiveTaskListModel({
    this.touser,
    this.processname,
    this.taskname,
    this.taskid,
    this.tasktype,
    this.edatetime,
    this.eventdatetime,
    this.fromuser,
    this.fromrole,
    this.displayicon,
    this.displaytitle,
    this.displaymcontent,
    this.displaycontent,
    this.displaybuttons,
    this.keyfield,
    this.keyvalue,
    this.transid,
    this.priorindex,
    this.indexno,
    this.subindexno,
    this.approvereasons,
    this.defapptext,
    this.returnreasons,
    this.defrettext,
    this.rejectreasons,
    this.defregtext,
    this.recordid,
    this.approvalcomments,
    this.rejectcomments,
    this.returncomments,
    this.rectype,
    this.msgtype,
    this.returnable,
    this.initiator,
    this.initiatorApproval,
    this.displaysubtitle,
    this.amendment,
    this.allowsend,
    this.allowsendflg,
    this.cmsgAppcheck,
    this.cmsgReturn,
    this.cmsgReject,
    this.showbuttons,
    this.hlink,
    this.hlinkTransid,
    this.hlinkParams,
    this.taskstatus,
    this.statusreason,
    this.statustext,
    this.cancelremarks,
    this.cancelledby,
    this.cancelledon,
    this.cancel,
    this.username,
    this.cstatus,
  });

  factory ActiveTaskListModel.fromRawJson(String str) => ActiveTaskListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  PendingListModel toPendingListModel() => PendingListModel(
        touser: touser ?? "",
        processname: processname ?? "",
        taskname: taskname ?? "",
        taskid: taskid ?? "",
        tasktype: tasktype ?? "",
        edatetime: edatetime ?? "",
        eventdatetime: eventdatetime ?? "",
        fromuser: fromuser ?? "",
        fromrole: fromrole ?? "",
        displayicon: displayicon ?? "",
        displaytitle: displaytitle ?? "",
        displaycontent: displaycontent ?? "",
        displaymcontent: displaymcontent ?? "",
        displaybuttons: displaybuttons ?? "",
        keyfield: keyfield ?? "",
        keyvalue: keyvalue ?? "",
        transid: transid ?? "",
        priorindex: priorindex.toString(),
        indexno: indexno.toString(),
        subindexno: subindexno.toString(),
        approvereasons: approvereasons ?? "",
        defapptext: defapptext ?? "",
        returnreasons: returnreasons ?? "",
        defrettext: defrettext ?? "",
        rejectreasons: rejectreasons ?? "",
        defregtext: defregtext ?? "",
        recordid: recordid.toString(),
        approvalcomments: approvalcomments ?? "",
        rejectcomments: rejectcomments ?? "",
        returncomments: returncomments ?? "",
        rectype: rectype ?? "",
        msgtype: msgtype ?? "",
        returnable: returnable ?? "",
        initiator: initiator ?? "",
        initiator_approval: initiatorApproval ?? "",
        displaysubtitle: displaysubtitle ?? "",
        amendment: amendment ?? "",
        allowsend: allowsend ?? "",
        allowsendflg: allowsendflg ?? "",
        cmsg_appcheck: cmsgAppcheck ?? "",
        cmsg_return: cmsgReturn ?? "",
        cmsg_reject: cmsgReject ?? "",
        showbuttons: showbuttons ?? "",
        hlink_transid: hlinkTransid ?? "",
        hlink_params: hlinkParams ?? "",
      );
  factory ActiveTaskListModel.fromJson(Map<String, dynamic> json) => ActiveTaskListModel(
        touser: json["touser"],
        processname: json["processname"],
        taskname: json["taskname"],
        taskid: json["taskid"],
        tasktype: json["tasktype"],
        edatetime: json["edatetime"],
        eventdatetime: json["eventdatetime"],
        fromuser: json["fromuser"],
        fromrole: json["fromrole"],
        displayicon: json["displayicon"],
        displaytitle: json["displaytitle"],
        displaymcontent: json["displaymcontent"],
        displaycontent: json["displaycontent"],
        displaybuttons: json["displaybuttons"],
        keyfield: json["keyfield"],
        keyvalue: json["keyvalue"],
        transid: json["transid"],
        priorindex: json["priorindex"],
        indexno: json["indexno"],
        subindexno: json["subindexno"],
        approvereasons: json["approvereasons"],
        defapptext: json["defapptext"],
        returnreasons: json["returnreasons"],
        defrettext: json["defrettext"],
        rejectreasons: json["rejectreasons"],
        defregtext: json["defregtext"],
        recordid: json["recordid"],
        approvalcomments: json["approvalcomments"],
        rejectcomments: json["rejectcomments"],
        returncomments: json["returncomments"],
        rectype: json["rectype"],
        msgtype: json["msgtype"],
        returnable: json["returnable"],
        initiator: json["initiator"],
        initiatorApproval: json["initiator_approval"],
        displaysubtitle: json["displaysubtitle"],
        amendment: json["amendment"],
        allowsend: json["allowsend"],
        allowsendflg: json["allowsendflg"],
        cmsgAppcheck: json["cmsg_appcheck"],
        cmsgReturn: json["cmsg_return"],
        cmsgReject: json["cmsg_reject"],
        showbuttons: json["showbuttons"],
        hlink: json["hlink"],
        hlinkTransid: json["hlink_transid"],
        hlinkParams: json["hlink_params"],
        taskstatus: json["taskstatus"],
        statusreason: json["statusreason"],
        statustext: json["statustext"],
        cancelremarks: json["cancelremarks"],
        cancelledby: json["cancelledby"],
        cancelledon: json["cancelledon"],
        cancel: json["cancel"],
        username: json["username"],
        cstatus: json["cstatus"],
      );

  Map<String, dynamic> toJson() => {
        "touser": touser,
        "processname": processname,
        "taskname": taskname,
        "taskid": taskid,
        "tasktype": tasktype,
        "edatetime": edatetime,
        "eventdatetime": eventdatetime,
        "fromuser": fromuser,
        "fromrole": fromrole,
        "displayicon": displayicon,
        "displaytitle": displaytitle,
        "displaymcontent": displaymcontent,
        "displaycontent": displaycontent,
        "displaybuttons": displaybuttons,
        "keyfield": keyfield,
        "keyvalue": keyvalue,
        "transid": transid,
        "priorindex": priorindex,
        "indexno": indexno,
        "subindexno": subindexno,
        "approvereasons": approvereasons,
        "defapptext": defapptext,
        "returnreasons": returnreasons,
        "defrettext": defrettext,
        "rejectreasons": rejectreasons,
        "defregtext": defregtext,
        "recordid": recordid,
        "approvalcomments": approvalcomments,
        "rejectcomments": rejectcomments,
        "returncomments": returncomments,
        "rectype": rectype,
        "msgtype": msgtype,
        "returnable": returnable,
        "initiator": initiator,
        "initiator_approval": initiatorApproval,
        "displaysubtitle": displaysubtitle,
        "amendment": amendment,
        "allowsend": allowsend,
        "allowsendflg": allowsendflg,
        "cmsg_appcheck": cmsgAppcheck,
        "cmsg_return": cmsgReturn,
        "cmsg_reject": cmsgReject,
        "showbuttons": showbuttons,
        "hlink": hlink,
        "hlink_transid": hlinkTransid,
        "hlink_params": hlinkParams,
        "taskstatus": taskstatus,
        "statusreason": statusreason,
        "statustext": statustext,
        "cancelremarks": cancelremarks,
        "cancelledby": cancelledby,
        "cancelledon": cancelledon,
        "cancel": cancel,
        "username": username,
        "cstatus": cstatus,
      };
}
