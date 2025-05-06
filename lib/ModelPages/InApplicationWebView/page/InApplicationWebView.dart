import 'dart:async';
import 'dart:io';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_downloader_flutter/file_downloader_flutter.dart';

class InApplicationWebViewer extends StatefulWidget {
  InApplicationWebViewer(this.data);

  String data;

  @override
  State<InApplicationWebViewer> createState() => _InApplicationWebViewerState();
}

class _InApplicationWebViewerState extends State<InApplicationWebViewer> {
  dynamic argumentData = Get.arguments;
  MenuHomePageController menuHomePageController = Get.find();

  // final Completer<InAppWebViewController> _controller = Completer<InAppWebViewController>();
  late InAppWebViewController _webViewController;

  // final _key = UniqueKey();
  var hasAppBar = false;
  bool _progressBarActive = true;
  late StreamSubscription subscription;
  CookieManager cookieManager = CookieManager.instance();
  final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'ico', 'xlsx', 'xls', 'docx', 'doc', 'pdf'];

  @override
  void initState() {
    super.initState();
    try {
      if (argumentData != null) widget.data = argumentData[0];
      if (argumentData != null) hasAppBar = argumentData[1] ?? false;
    } catch (e) {}
    // widget.data = "https://amazon.in"
    print(widget.data);
    clearCookie();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      menuHomePageController.switchPage.value = false;
    });
    //Navigator.pop(context);
  }

  InAppWebViewSettings settings = InAppWebViewSettings(
    transparentBackground: true,
    javaScriptEnabled: true,
    // incognito: true,
    javaScriptCanOpenWindowsAutomatically: true,
    useOnDownloadStart: true,
    useShouldOverrideUrlLoading: true,
    // mediaPlaybackRequiresUserGesture: false,
    useHybridComposition: false,
    hardwareAcceleration: false,
    geolocationEnabled: true,
  );

  void _download(String url) async {
    try {
      print("download Url: $url");
      String fname = url.split('/').last.split('.').first;
      print("download FileName: $fname");
      FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);
    } catch (e) {
      print(e.toString());
    }
  }

  void _download_old(String url) async {
    if (Platform.isAndroid) {
      print("ANDROID download---------------------------->");
      try {
        print("download Url: $url");
        String fname = url.split('/').last.split('.').first;
        print("download FileName: $fname");
        FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);
      } catch (e) {
        print(e.toString());
      }
    }
    // if (Platform.isAndroid) {
    //   final deviceInfo = await DeviceInfoPlugin().androidInfo;
    //   var status;
    //   if (deviceInfo.version.sdkInt > 32) {
    //     status = await Permission.photos.request().isGranted;
    //     print(">32");
    //   } else {
    //     status = await Permission.storage.request().isGranted;
    //   }
    //   if (status) {
    //     Fluttertoast.showToast(
    //         msg: "Download Started...",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.green.shade200,
    //         textColor: Colors.black,
    //         fontSize: 16.0);
    //
    //     await FileDownloader.downloadFile(
    //       url: url,
    //       onProgress: (fileName, progress) {
    //         // print("On Progressssss");
    //       },
    //       onDownloadError: (errorMessage) {
    //         Get.snackbar("Error", "Download file error " + errorMessage,
    //             snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade300, colorText: Colors.white);
    //       },
    //       onDownloadCompleted: (path) {
    //         // print("Download Completed:   $path");
    //         //OpenFile.open(path);
    //         OpenFile.open(path);
    //       },
    //     );
    //   } else {

    if (Platform.isIOS) {
      print("IOS download---------------------------->");
      var status = await Permission.storage.request().isGranted;
      try {
        if (status) {
          Directory documents = await getApplicationDocumentsDirectory();
          print(documents.path);
          String fname = url.split('/').last.split('.').first;
          print("download FileName: $fname");
          FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);
        } else {
          print("Permission Denied");
        }
      } catch (e) {
        print("IOS download error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: hasAppBar == true
            ? AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                centerTitle: false,
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/axAppLogo.png",
                        // height: 25,
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: Builder(builder: (BuildContext context) {
            return Stack(children: <Widget>[
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.data))),
                initialSettings: settings,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onGeolocationPermissionsShowPrompt: (InAppWebViewController controller, String origin) async {
                  var status = await Permission.locationWhenInUse.status;

                  if (status.isGranted) {
                    return GeolocationPermissionShowPromptResponse(
                      origin: origin,
                      allow: true,
                      retain: true,
                    );
                  } else {
                    requestLocationPermission();
                    return GeolocationPermissionShowPromptResponse(
                      origin: origin,
                      allow: false,
                      retain: false,
                    );
                  }
                },
                onDownloadStartRequest: (controller, downloadStartRequest) {
                  LogService.writeLog(
                      message: "onDownloadStartRequest\nwith requested url: ${downloadStartRequest.url.toString()}");
                  print("Download...");
                  print("Requested url: ${downloadStartRequest.url.toString()}");
                  _download(downloadStartRequest.url.toString());
                  // _downloadToDevice("url");
                },
                onConsoleMessage: (controller, consoleMessage) {
                  // LogService.writeLog(message: "onConsoleMessage: ${consoleMessage.toString()}");

                  print("Console Message received...");
                  print(consoleMessage.toString());
                  if (consoleMessage.toString().contains("axm_mainpageloaded")) {
                    try {
                      if (menuHomePageController.switchPage.value == true) {
                        menuHomePageController.switchPage.toggle();
                      } else {
                        Get.back();
                      }
                    } catch (e) {}
                  }
                },
                onProgressChanged: (controller, value) {
                  LogService.writeLog(message: "onProgressChanged: value=> $value");

                  print('Progress---: $value : DT ${DateTime.now()}');
                  if (value == 100) {
                    setState(() {
                      _progressBarActive = false;
                    });
                  }
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  print("Override url: $uri");
                  LogService.writeLog(message: "shouldOverrideUrlLoading: url=> $uri");

                  if (imageExtensions.any((ext) => uri.toString().endsWith(ext))) {
                    _download(uri.toString());
                    // _downloadToDevice("url");

                    return Future.value(NavigationActionPolicy.CANCEL);
                  }
                  return Future.value(NavigationActionPolicy.ALLOW);
                },
              ),
              _progressBarActive
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: SpinKitRotatingCircle(
                          size: 40,
                          itemBuilder: (context, index) {
                            final colors = [MyColors.blue2, MyColors.blue2, MyColors.blue2];
                            final color = colors[index % colors.length];
                            return DecoratedBox(decoration: BoxDecoration(color: color, shape: BoxShape.circle));
                          },
                        ),
                      ))
                  : Stack(),
            ]);
          }),
        ),
        //floatingActionButton: favoriteButton(),
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      // Request permission
      if (await Permission.locationWhenInUse.request().isGranted) {
        print("Location permission granted.");
      } else {
        print("Location permission denied.");
        showPermissionDialog();
      }
    }
  }

  void showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Permission Required"),
          content: Text("This feature requires location access. Please enable location permissions in settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Opens app settings to enable permissions
                Navigator.of(context).pop();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  void clearCookie() async {
    await cookieManager.deleteAllCookies();
    print("Cookie cleared");
  }
}
