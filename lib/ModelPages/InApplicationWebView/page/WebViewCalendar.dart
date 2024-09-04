import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:flutter/material.dart';

class WebViewCalendar extends StatefulWidget {
  final String weburl = Const.getFullProjectUrl('aspx/AxMain.aspx?pname=dcalendar&authKey=AXPERT-') +
      AppStorage().retrieveValue(AppStorage.SESSIONID);

  WebViewCalendar();
  @override
  _WebViewCalendarState createState() => _WebViewCalendarState();
}

class _WebViewCalendarState extends State<WebViewCalendar> {
  @override
  Widget build(BuildContext context) {
    print(widget.weburl);
    return InApplicationWebViewer(widget.weburl);
  }
}
