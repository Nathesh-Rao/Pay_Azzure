import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:flutter/material.dart';
import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:flutter/material.dart';

class WebViewFromBottomBar extends StatelessWidget {
  final String url;

  const WebViewFromBottomBar({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final String weburl = Const.getFullProjectUrl(url) + AppStorage().retrieveValue(AppStorage.SESSIONID);
    print(weburl);
    return InApplicationWebViewer(weburl);
  }
}
