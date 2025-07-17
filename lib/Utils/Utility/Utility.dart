import 'package:file_downloader_flutter/file_downloader_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../Constants/MyColors.dart';

class Utility {
  static Future<void> downloadFile_inAppWebView({
    required InAppWebViewController controller,
    required DownloadStartRequest downloadStartRequest,
    void Function(String? path)? onDownloadComplete,
    void Function(String? error)? onDownloadError,
  }) async {
    print("downloadFile_inAppWebView started: " + downloadStartRequest.url.toString());
    if (downloadStartRequest.url.toString().startsWith("blob")) {
      print("Blob data");
      // String alertCode = "alert('" + downloadStartRequest.url.toString() + "')";
      String yourCode = "window.URL.revokeObjectURL('" + downloadStartRequest.url.toString() + "');";

      final String functionBody = "var xhr = new XMLHttpRequest();\n"
          "console.log(\"Working\");\n"
          "var blobUrl =\'${downloadStartRequest.url.toString()}\';\n"
          "console.log(blobUrl);\n"
          "xhr.open('GET', blobUrl, true);\n"
          "console.log(\"Opened...\");\n"
          "xhr.responseType = 'blob';\n"
          "console.log(this.status);\n"
          "xhr.onload = function(e) {\n"
          "if (this.status == 200) {\n"
          "var blob = this.response;\n"
          "var reader = new FileReader();\n"
          "reader.readAsDataURL(blob);\n"
          "reader.onloadend = function() {\n"
          "var base64data = reader.result;\n"
          "console.log(base64data);\n"
          "var base64ContentArray = base64data.split(\",\");\n"
          // "var mimeType = base64ContentArray[0].match(/[^:\s*]\w+\/[\w-+\d.]+(?=[;| ])/)[0];\n"
          "var decodedFile = base64ContentArray[1];\n"
          "console.log(\'pdf\');\n"
          "window.flutter_inappwebview.callHandler('blobToBase64Handler', decodedFile, 'pdf');\n"
          " };\n"
          "};\n"
          "};\n"
          "xhr.send();";
      // print(functionBody);
      await controller.evaluateJavascript(source: yourCode).then((result) {
        // print(result?.value.runtimeType); // int
        // print(result?.error.runtimeType); // Null
        print(result.toString());
        _download(downloadStartRequest.url.toString(), onDownloadComplete, onDownloadError);
      });
      // {value: 49, error: null}
    } else {
      _download(downloadStartRequest.url.toString(), onDownloadComplete, onDownloadError);
    }
  }

  static void _download(
      String url, void Function(String? path)? onComplete, void Function(String? error)? onDownloadError) async {
    try {
      print("download Url: $url");
      String fname = url.split('/').last.split('.').first;
      // fname = fname.replaceAll(RegExp(r'%20'), ' ');

      fname = Uri.decodeFull(fname);
      print("download FileName: $fname");

      var path = await FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);

      if (onComplete != null) {
        onComplete(path);
      }
      _showDownloadSnackBar(message: "File downloaded to $path");
    } catch (e) {
      if (onDownloadError != null) {
        onDownloadError(e.toString());
      }
      _showDownloadSnackBar(message: "Something went wrong\n${e.toString()}", isError: true);

      print("Download error: ${e.toString()}");
    }
  }

  static Future<void> _showDownloadSnackBar({required String message, bool isError = false}) async {
    await Get.showSnackbar(GetSnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: !isError ? MyColors.green : MyColors.red,
      icon: Icon(!isError ? Icons.check_circle : Icons.error),
      title: !isError ? "Success" : "Failed",
      message: message,
    ));
  }
}
