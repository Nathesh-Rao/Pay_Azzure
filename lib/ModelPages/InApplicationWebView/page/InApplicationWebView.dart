import 'dart:async';
import 'dart:io';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/controller/webview_controller.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_downloader_flutter/file_downloader_flutter.dart';

import '../../../Constants/Const.dart';
import '../../../Constants/Routes.dart';
import '../../../Utils/Utility/Utility.dart';
import '../../LandingPage/Controller/LandingPageController.dart';

class InApplicationWebViewer extends StatefulWidget {
  InApplicationWebViewer(this.data);

  WebViewController webViewController = Get.find();
  String data;

  @override
  State<InApplicationWebViewer> createState() => _InApplicationWebViewerState();
}

class _InApplicationWebViewerState extends State<InApplicationWebViewer> {
  dynamic argumentData = Get.arguments;
  MenuHomePageController menuHomePageController = Get.find();
  LandingPageController landingPageController = Get.find();
  Map<int, InAppWebViewController> windowControllers = {};
  BuildContext? context_popUpScreen;

  // final Completer<InAppWebViewController> _controller = Completer<InAppWebViewController>();
  // late InAppWebViewController _webViewController;

  // final _key = UniqueKey();
  var hasAppBar = false;
  late StreamSubscription subscription;
  CookieManager cookieManager = CookieManager.instance();
  final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'ico', 'xlsx', 'xls', 'docx', 'doc', 'pdf'];
  bool isCalendarPage = false;
  bool _showButton = false;
  bool _handled = false;
  bool _longPressActive = false;
  double _startY = 0;
  Timer? _longPressTimer;

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
    _longPressTimer?.cancel(); // kill timer safely
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
    domStorageEnabled: true,
    useShouldOverrideUrlLoading: true,
    // mediaPlaybackRequiresUserGesture: false,
    useHybridComposition: false,
    hardwareAcceleration: false,
    geolocationEnabled: true,
    clearCache: false,

    supportMultipleWindows: true,
  );

  perform_backButtonClick() async {
    if (isCalendarPage) {
      widget.webViewController.closeWebView();
      return true;
    }

    bool handledInWeb = await widget.webViewController.inAppWebViewController.value!.evaluateJavascript(source: """
      (function() {
        var btn = document.querySelector('.appBackBtn');
        if (btn) {
          btn.click();
          return true;   //handled inside web
        }
        return false;    //button not found
      })();
    """) ?? false;

    if (!handledInWeb) {
      widget.webViewController.closeWebView();
      return true;
    }

    return false;
  }

  void _download(String url) async {
    try {
      print("download Url: $url");
      String fname = url.split('/').last.split('.').first;
      print("download FileName: $fname");
      await FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);
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

  Future<void> _onLongSwipe() async {
    print("Longpress");
    if (_handled) return;
    _handled = true;

    setState(() => _showButton = true);

    // auto hide after 3 sec
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _showButton = false);
      _handled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (await _webViewController.canGoBack()) {
        // _webViewController.goBack();
        if (widget.webViewController.currentIndex == 1) {
          bool val = perform_backButtonClick();
          return Future.value(val);
          /*widget.webViewController.closeWebView();
          if (widget.webViewController.inAppWebViewController.value == null) return Future.value(true);

          if (await widget.webViewController.inAppWebViewController.value!.canGoBack()) {
            widget.webViewController.inAppWebViewController.value!.goBack();
            return Future.value(false);
          } else {
            //return Future.value(false);
            return Future.value(true);
          }*/
        }
        return Future.value(true);
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
        // : AppBar(
        //     actions: [Icon(Icons.cancel)],
        //   ),

            : null,
        body: SafeArea(
          child: Builder(builder: (BuildContext context) {
            return Stack(children: <Widget>[
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.data))),
                initialSettings: settings,
                onWebViewCreated: (controller) {
                  // _webViewController = controller;
                  widget.webViewController.inAppWebViewController.value = controller;
                },
                onLoadStart: (controller, url) {
                  url.toString().toLowerCase().contains("dcalendar") ? isCalendarPage = true : isCalendarPage = false;

                  setState(() {
                    widget.webViewController.isProgressBarActive.value = true;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    widget.webViewController.isProgressBarActive.value = false;
                  });
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
                  LogService.writeLog(message: "onDownloadStartRequest\nwith requested url: ${downloadStartRequest.url.toString()}");
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
                      // if (menuHomePageController.switchPage.value == true) {
                      //   menuHomePageController.switchPage.toggle();
                      // } else {
                      //   Get.back();
                      // }

                      widget.webViewController.closeWebView();
                    } catch (e) {}
                  }
                },
                onProgressChanged: (controller, value) {
                  LogService.writeLog(message: "onProgressChanged: value=> $value");

                  print('Progress---: $value : DT ${DateTime.now()}');
                  if (value == 100) {
                    setState(() {
                      widget.webViewController.isProgressBarActive.value = false;
                    });
                  }
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  print("Override url: $uri");
                  LogService.writeLog(message: "shouldOverrideUrlLoading: url=> $uri");
                  if (uri.toString().toLowerCase().contains("sess.aspx")) {
                    await controller
                        .loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri(uri.toString() + "?axmain=true"),
                      ),
                    )
                        .then((_) {});
                    //showSignOutDialog();
                    landingPageController.showSignOutDialog_sessionExpired();
                  }

                  if (imageExtensions.any((ext) => uri.toString().endsWith(ext))) {
                    _download(uri.toString());
                    // _downloadToDevice("url");

                    return Future.value(NavigationActionPolicy.CANCEL);
                  }
                  return Future.value(NavigationActionPolicy.ALLOW);
                },
                onCreateWindow: (controller, createWindowRequest) async {
                  final windowId = createWindowRequest.windowId;
                  print("newWindowCreated");
                  if (windowId != null) {
                    // // Open a new window for the given windowId
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => NewWindowPage(
                    //       windowId: windowId,
                    //       onWindowCreated: (newController) {
                    //         windowControllers[windowId] = newController;
                    //         context_popUpScreen = context;
                    //       },
                    //     ),
                    //   ),
                    // );

                    Get.to(
                            () => NewWindowPage(
                          windowId: windowId,
                          onWindowCreated: (newController) {
                            windowControllers[windowId] = newController;
                            context_popUpScreen = context;
                          },
                        ),
                        transition: Transition.cupertino,
                        duration: Duration(milliseconds: 500));
                    return true; // Allow the window creation
                  }
                  return false;
                },
              ),
              Positioned.fill(
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (event) {
                    _startY = event.position.dy;
                    _longPressTimer = Timer(const Duration(milliseconds: 300), () {
                      _longPressActive = true;
                    });
                  },
                  onPointerMove: (event) {
                    if (_longPressActive) {
                      final dy = event.position.dy - _startY;
                      if (dy > 100 && !_handled) {
                        // _onLongSwipeTriggered();
                        _onLongSwipe();
                      }
                    }
                  },
                  onPointerUp: (_) {
                    _longPressTimer?.cancel();
                    _longPressActive = false;
                  },
                ),
              ),
              Obx(
                    () => widget.webViewController.isProgressBarActive.value
                    ? Container(
                    color: Colors.white,
                    child: Center(
                      child: SpinKitRotatingCircle(
                        size: 40,
                        itemBuilder: (context, index) {
                          final colors = [MyColors.PayAzzureColor2, MyColors.PayAzzureColor2, MyColors.PayAzzureColor2];
                          final color = colors[index % colors.length];
                          return DecoratedBox(decoration: BoxDecoration(color: color, shape: BoxShape.circle));
                        },
                      ),
                    ))
                    : Stack(),
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Visibility(visible: false, child: GestureDetector(onTap: perform_backButtonClick, child: Icon(Icons.cancel)))),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _showButton ? 20.0 : -100.0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _showButton ? 1.0 : 0.0,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        widget.webViewController.closeWebView();
                      },
                      child: const Icon(Icons.home, size: 32),
                    ),
                  ),
                ),
              ),
              Obx(
                    () => widget.webViewController.isFileDownloading.value
                    ? Container(
                  color: Colors.black.withValues(alpha: 0.6), // dim background
                  child: Center(
                    child: Lottie.asset(
                      "assets/lotties/download.json",
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                    : Stack(),
              ),
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

  void showSignOutDialog() {
    widget.webViewController..signOut(url: Const.getFullWebUrl("aspx/AxMain.aspx?signout=true"));
    Get.defaultDialog(
      barrierDismissible: false,
      titleStyle: TextStyle(color: MyColors.PayAzzureColor2),
      titlePadding: EdgeInsets.only(
        top: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      title: "Session Expired",
      middleText: "Your session has expired. Please log in again to continue.",
      confirm: ElevatedButton(
          onPressed: () async {
            landingPageController.signOut_withoutDialog();
          },
          child: Text("Login")),
    );
  }
}

class NewWindowPage extends StatefulWidget {
  final int windowId;
  final Function(InAppWebViewController) onWindowCreated;

  const NewWindowPage({
    required this.windowId,
    required this.onWindowCreated,
  });

  @override
  _NewWindowPageState createState() => _NewWindowPageState();
}

class _NewWindowPageState extends State<NewWindowPage> {
  late InAppWebViewController newWebViewController;

  @override
  Widget build(BuildContext context) {
    print("new-Window => ${widget.windowId}");
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('New Window'),
      // ),
      body: SafeArea(
        child: InAppWebView(
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
            ),
            windowId: widget.windowId,
            // Associate this WebView with the windowId
            onWebViewCreated: (controller) {
              newWebViewController = controller;
              widget.onWindowCreated(controller);
            },
            onConsoleMessage: (controller, consoleMessage) {
              print("Console Message_new_window $consoleMessage");
            },
            onDownloadStartRequest: (controller, downloadStartRequest) async {
              await Utility.downloadFile_inAppWebView(
                  controller: controller,
                  downloadStartRequest: downloadStartRequest,
                  onDownloadComplete: (path) {
                    Get.until((route) => route.settings.name == Routes.LandingPage);
                    print("Download path => $path");
                  },
                  onDownloadError: (e) {
                    Get.until((route) => route.settings.name == Routes.LandingPage);
                    print("Download Error => $e");
                  });
            }

          // onPageCommitVisible: (controller,consolemsg){
          //
          // },
        ),
      ),
    );
  }
}
