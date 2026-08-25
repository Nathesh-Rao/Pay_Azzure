import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Enums.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

// class LogService {
//   static Future<String> _localPath() async {
//     final directory = Platform.isAndroid
//         ? await getExternalStorageDirectory()
//         : await getApplicationDocumentsDirectory();

//     return directory!.path;
//   }

//   static Future<File> _localFile() async {
//     final path = await _localPath();
//     return File('$path/AxpertLog.txt');
//   }

//   static getVersion() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     var version = packageInfo.version;
//     Const.APP_VERSION = version;
//   }

//   static initLogs() async {
//     var file = await _localFile();
//     try {
//       var isTraceOn =
//           await AppStorage().retrieveValue(AppStorage.isLogEnabled) ?? false;
//       Const.isLogEnabled = isTraceOn;

//       var isExists = await file.exists();
//       if (!isExists) {
//         if (Const.APP_VERSION == "") {
//           await getVersion();
//         }
//         await file.writeAsString('Axpert Android Log File\n',
//             mode: FileMode.write, flush: true);
//         await file.writeAsString('App Version: ${Const.APP_VERSION}\n',
//             mode: FileMode.append, flush: true);
//         await file.writeAsString(
//             'File Creation Date: ${DateFormat("dd-MMM-yyyy HH:mm:ss").format(DateTime.now())}\n',
//             mode: FileMode.append,
//             flush: true);
//         await file.writeAsString(
//             '------------------------------------------------------------------- \n\n',
//             mode: FileMode.append,
//             flush: true);
//       }
//     } catch (e) {}
//   }

//   static writeOnConsole({String message = ""}) async {
//     _logWithColor("console-log: $message", skyBlue);
//   }

//   static writeLog({String message = ""}) async {
//     _logWithColor(message, yellow);
//     if (Const.isLogEnabled) {
//       final file = await _localFile();
//       var formatedDateTime =
//           DateFormat("dd-MMM-yyyy HH:mm:ss:SSS").format(DateTime.now());
//       try {
//         await file.writeAsString('$formatedDateTime: $message\n',
//             mode: FileMode.append);
//       } catch (e) {}
//     }
//   }

//   static const String yellow = '\u001B[33m';
//   static const String skyBlue = '\u001B[38;5;39m';

//   static clearLog() async {
//     try {
//       final file = await _localFile();
//       var isExists = await file.exists();
//       if (isExists) {
//         file.delete();
//         initLogs();
//       }
//     } catch (e) {}
//   }

//   // Experimental------------->
//   static writeLogAdv({
//     // LogType logType = LogType.REGULAR,
//     String message = '',
//   }) async {
//     if (Const.isLogEnabled) {
//       final file = await _localFile();
//       var formatedDateTime =
//           DateFormat("dd-MMM-yyyy HH:mm:ss:SSS").format(DateTime.now());
//       try {
//         await file.writeAsString('$formatedDateTime: $log\n',
//             mode: FileMode.append);
//       } catch (e) {}
//     }

//     _logWithColor(message, yellow);
//   }

//   static void _logWithColor(String message, String colorCode) {
//     print('$colorCode$message\u001B[0m');
//   }

//   String formatApiLog({
//     required String method,
//     required String url,
//     required String apiName,
//     required Map<String, dynamic> requestBody,
//     required int statusCode,
//     required Map<String, dynamic> responseBody,
//   }) {
//     String line = '═' * 70;
//     String boxLine = '─' * 70;

//     return '''
// ╔$line╗
// ║${'API CALL'.padLeft(36).padRight(70)}║
// ╟$boxLine╢
// ║ [${method.toUpperCase()}] URL: $url
// ║ API Name: $apiName
// ║ Request Body:
// ║ ${requestBody.toString().split('\n').join('\n║ ')}
// ║ Status Code: $statusCode
// ║ Response:
// ║ ${responseBody.toString().split('\n').join('\n║ ')}
// ╚$line╝
//   ''';
//   }
// }

class LogService {
  // static GlobalVariableController gvcontroller = Get.find();
  static Future<String> _localPath() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile() async {
    final path = await _localPath();
    var fullPath = '$path/AxpertLog.txt';
    Const.LOG_FILE_PATH = fullPath;
    // gvcontroller.LOG_PATH.value = fullPath;
    var file = File(fullPath);
    if (!await file.exists()) {
      await file.create();
    }

    return file;
  }

  static setLogValue(value) async {
    await AppStorage().storeValue(AppStorage.isLogEnabled, value) ?? false;
  }

  static getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    var version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    var versionInfo =
        version + "." + Const.APP_RELEASE_ID + "_" + Const.APP_RELEASE_DATE;
    return versionInfo;
  }

  static initLogs() async {
    setLogValue(false);
    var file = await _localFile();
    try {
      var isTraceOn =
          await AppStorage().retrieveValue(AppStorage.isLogEnabled) ?? false;
      Const.isLogEnabled = isTraceOn;

      var isExists = await file.parent.exists();
      if (!isExists) {
        await file.parent.create(recursive: true);
      }
      // if (!await file.exists()) {
      //   await file.create();
      // }
      print("offline_trace init file exists? $isExists\nPath: ${file.path}");
      print("offline_trace init file exists? $isExists\nPath: ${file.path}");
      log("init file exists? $isExists\nPath: ${file.path}",
          name: 'offline_trace');
      if (isExists) {
        // if (Const.APP_VERSION == "") {
        //   await getVersion();
        // }
        await file.writeAsString('Axpert Android Log File\n',
            mode: FileMode.write, flush: true);
        await file.writeAsString('App Version: ${await getVersionName()}\n',
            mode: FileMode.append, flush: true);
        await file.writeAsString(
            'File Creation Date: ${DateFormat("dd-MMM-yyyy HH:mm:ss").format(DateTime.now())}\n',
            mode: FileMode.append,
            flush: true);
        await file.writeAsString(
            '------------------------------------------------------------------- \n\n',
            mode: FileMode.append,
            flush: true);
      }
    } catch (e) {
      print("offline_trace init error $e");
      log("init error $e", name: 'offline_trace');
    }
  }

  static writeOnConsole({String message = ""}) async {
    return;

    _logWithColor("console-log: $message", skyBlue);
  }

  static printLongString(String text) {
    final RegExp pattern =
        RegExp('.{1,800}'); // Slices into 800-character chunks
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  static writeLog({String message = ""}) async {
    _logWithColor(message, yellow);
    if (Const.isLogEnabled) {
      final file = await _localFile();
      var formatedDateTime =
          DateFormat("dd-MMM-yyyy HH:mm:ss:SSS").format(DateTime.now());
      try {
        await file.writeAsString('$formatedDateTime: $message\n',
            mode: FileMode.append);
      } catch (e) {}
    }
  }

  static const String yellow = '\u001B[33m';
  static const String skyBlue = '\u001B[38;5;39m';

  static clearLog() async {
    print(
      "offline_trace Clear log called",
    );
    log("Clear log called", name: 'offline_trace');

    try {
      final file = await _localFile();
      var isExists = await file.exists();
      print("offline_trace Clear log Exists? : $isExists \nPath: ${file.path}");
      log("Clear log Exists? : $isExists \nPath: ${file.path}",
          name: 'offline_trace');

      if (isExists) {
        file.delete();
        initLogs();
      }
    } catch (e) {
      print(
        "offline_trace Clear log error $e",
      );
      log("Clear log error $e", name: 'offline_trace');
    }
  }

  // Experimental------------->
  static writeLogAdv({
    LogType logType = LogType.REGULAR,
    String message = '',
  }) async {
    if (Const.isLogEnabled) {
      final file = await _localFile();
      var formatedDateTime =
          DateFormat("dd-MMM-yyyy HH:mm:ss:SSS").format(DateTime.now());
      try {
        await file.writeAsString('$formatedDateTime: $log\n',
            mode: FileMode.append);
      } catch (e) {}
    }

    _logWithColor(message, yellow);
  }

  static void _logWithColor(String message, String colorCode) {
    print('$colorCode$message\u001B[0m');
  }

  String formatApiLog({
    required String method,
    required String url,
    required String apiName,
    required Map<String, dynamic> requestBody,
    required int statusCode,
    required Map<String, dynamic> responseBody,
  }) {
    String line = '═' * 70;
    String boxLine = '─' * 70;

    return '''
╔$line╗
║${'API CALL'.padLeft(36).padRight(70)}║
╟$boxLine╢
║ [${method.toUpperCase()}] URL: $url
║ API Name: $apiName
║ Request Body:
║ ${requestBody.toString().split('\n').join('\n║ ')}
║ Status Code: $statusCode
║ Response:
║ ${responseBody.toString().split('\n').join('\n║ ')}
╚$line╝
  ''';
  }
}
