import 'dart:io';

import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class LogService {
  static Future<String> _localPath() async {
    var directory = await getExternalStorageDirectory();
    directory ??= await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/AxpertLog.txt');
  }

  static getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    Const.APP_VERSION = version;
  }

  static initLogs() async {
    var file = await _localFile();
    try {
      var isTraceOn = await AppStorage().retrieveValue(AppStorage.isLogEnabled) ?? false;
      Const.isLogEnabled = isTraceOn;

      var isExists = await file.exists();
      if (!isExists) {
        if (Const.APP_VERSION == "") {
          await getVersion();
        }
        await file.writeAsString('Axpert Android Log File\n', mode: FileMode.write, flush: true);
        await file.writeAsString('App Version: ${Const.APP_VERSION}\n', mode: FileMode.append, flush: true);
        await file.writeAsString('File Creation Date: ${DateFormat("dd-MMM-yyyy HH:mm:ss").format(DateTime.now())}\n',
            mode: FileMode.append, flush: true);
        await file.writeAsString('------------------------------------------------------------------- \n\n',
            mode: FileMode.append, flush: true);
      }
    } catch (e) {}
  }

  static writeLog({String message = ""}) async {
    if (Const.isLogEnabled) {
      final file = await _localFile();
      var formatedDateTime = DateFormat("dd-MMM-yyyy HH:mm:ss:SSS").format(DateTime.now());
      try {
        await file.writeAsString('$formatedDateTime: $message\n', mode: FileMode.append);
      } catch (e) {}
    }
  }

  static clearLog() async {
    try {
      final file = await _localFile();
      var isExists = await file.exists();
      if (isExists) {
        file.delete();
        initLogs();
      }
    } catch (e) {}
  }
}
