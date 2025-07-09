import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:flutter/material.dart';

class WebViewActiveList extends StatefulWidget {
  final String weburl = Const.getFullWebUrl('aspx/AxMain.aspx?pname=hNewActiveList&authKey=AXPERT-') +
      (AppStorage().retrieveValue(AppStorage.SESSIONID) ?? "");

  WebViewActiveList();
  @override
  _WebViewCalendarState createState() => _WebViewCalendarState();
}

class _WebViewCalendarState extends State<WebViewActiveList> {
  @override
  Widget build(BuildContext context) {
    print(widget.weburl);
    return InApplicationWebViewer(widget.weburl);
  }
}
