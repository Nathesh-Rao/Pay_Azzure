import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Const.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:axpertflutter/Utils/ServerConnections/ExecuteApi.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'offline_db_constants.dart';
import 'offline_db_module.dart';

import 'package:flutter/services.dart';

class OfflineBundleService {
  static const String bundleExtension = ".axbundle";
  static const String bundleAction = "DB_BUNDLE_OPERATION";
  static const String logTag = "[AX_BUNDLE_LOG]";
  static const String _backupFileName = "last_import_backup.axbundle";
  static const String _backupMetaFileName = "last_import_backup.meta.json";

  static Future<String> _backupFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return join(dir.path, _backupFileName);
  }

  static Future<String> _backupMetaPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return join(dir.path, _backupMetaFileName);
  }

  /// Returns true if a pre-import backup exists.
  static Future<bool> hasBackup() async {
    final path = await _backupFilePath();
    return File(path).exists();
  }

  static Future<Map<String, dynamic>?> getBackupMeta() async {
    final metaPath = await _backupMetaPath();
    final metaFile = File(metaPath);
    if (!await metaFile.exists()) return null;
    try {
      final content = await metaFile.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> backupCurrentDatabase() async {
    LogService.writeLog(
        message: "$logTag [BACKUP_START] Creating pre-import backup...");
    try {
      final dbFile = await OfflineDbModule.getDatabaseFile();
      final archive = Archive();
      final List<String> assetPaths = [];

      final List<Map<String, dynamic>> pendingRequests =
          await OfflineDbModule.getRawPendingRequests();

      for (var row in pendingRequests) {
        final String jsonStr = row[OfflineDBConstants.COL_REQUEST_JSON] ?? "";
        if (jsonStr.isNotEmpty) {
          _findPathsInJson(jsonDecode(jsonStr), assetPaths);
        }
      }

      archive.addFile(ArchiveFile(
          'offline_forms.db', dbFile.lengthSync(), await dbFile.readAsBytes()));

      for (String path in assetPaths.toSet()) {
        final file = File(path);
        if (await file.exists()) {
          archive.addFile(ArchiveFile('assets/${basename(path)}',
              file.lengthSync(), await file.readAsBytes()));
        }
      }

      final zipEncoder = ZipEncoder();
      final encodedZip = zipEncoder.encode(archive);
      final backupPath = await _backupFilePath();
      await File(backupPath).writeAsBytes(encodedZip);

      final user =
          await AppStorage().retrieveValue(AppStorage.USER_NAME) ?? "Unknown";
      final now = DateTime.now();
      final meta = {
        "timestamp": now.toIso8601String(),
        "user": user,
        "displayTime":
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} "
                "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
      };
      await File(await _backupMetaPath()).writeAsString(jsonEncode(meta));

      LogService.writeLog(
          message: "$logTag [BACKUP_SUCCESS] Backup saved to $backupPath");
    } catch (e) {
      LogService.writeLog(message: "$logTag [BACKUP_CRASH] $e");
      rethrow;
    }
  }

  static Future<void> restoreBackup() async {
    final path = await _backupFilePath();
    final backupFile = File(path);
    if (!await backupFile.exists()) {
      throw Exception("No backup found to restore.");
    }
    debugPrint("$logTag [RESTORE_BACKUP] Restoring from $path");
    await importBundleNew(backupFile);
  }

  static Future<File?> createExportBundle() async {
    try {
      LogService.writeLog(
          message:
              "$logTag [EXPORT_START] Packaging DB and underscore-pathed assets...");

      final String user =
          await AppStorage().retrieveValue(AppStorage.USER_NAME) ??
              "UnknownUser";

      final now = DateTime.now();
      final String timestamp =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_"
          "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";

      final dbFile = await OfflineDbModule.getDatabaseFile();
      final archive = Archive();
      final List<String> assetPaths = [];

      final List<Map<String, dynamic>> pendingRequests =
          await OfflineDbModule.getRawPendingRequests();

      for (var row in pendingRequests) {
        final String jsonStr = row[OfflineDBConstants.COL_REQUEST_JSON] ?? "";
        if (jsonStr.isNotEmpty) {
          _findPathsInJson(jsonDecode(jsonStr), assetPaths);
        }
      }

      final uniqueAssets = assetPaths.toSet().toList();
      archive.addFile(ArchiveFile(
          'offline_forms.db', dbFile.lengthSync(), await dbFile.readAsBytes()));

      int addedCount = 0;
      for (String path in uniqueAssets) {
        final file = File(path);
        if (await file.exists()) {
          archive.addFile(ArchiveFile('assets/${basename(path)}',
              file.lengthSync(), await file.readAsBytes()));
          addedCount++;
        } else {
          debugPrint("$logTag [EXPORT_WARN] File not found: $path");
        }
      }

      final zipEncoder = ZipEncoder();
      final encodedZip = zipEncoder.encode(archive);
      final tempDir = await getTemporaryDirectory();
      final String fileName = "Export_${user}_$timestamp$bundleExtension";
      final bundleFile = File('${tempDir.path}/$fileName');
      await bundleFile.writeAsBytes(encodedZip);

      LogService.writeLog(
          message:
              "$logTag [EXPORT_SUCCESS] Bundled $addedCount assets into ${bundleFile.path}");
      return bundleFile;
    } catch (e) {
      LogService.writeLog(message: "$logTag [EXPORT_CRASH] $e");
      return null;
    }
  }

  static Future<void> importBundle(File bundleFile) async {
    try {
      final bytes = await bundleFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final appDocDir = await getApplicationDocumentsDirectory();
      final String currentAppFlutterPath = appDocDir.path;
      final String packageRoot = appDocDir.parent.path;

      String? oldPathToReplace;

      for (final file in archive) {
        if (file.name.startsWith('assets/')) {
          final String fileName = basename(file.name);
          final outFile = File(join(packageRoot, fileName));
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
          LogService.writeLog(
              message: "$logTag [EXTRACT] Physical file: ${outFile.path}");
        }
      }

      for (final file in archive) {
        if (file.name == 'offline_forms.db') {
          final tempDbPath =
              join((await getTemporaryDirectory()).path, 'temp_import.db');
          await File(tempDbPath).writeAsBytes(file.content as List<int>);
          Database tempDb = await openDatabase(tempDbPath);

          final allRecords =
              await tempDb.query(OfflineDBConstants.TABLE_PENDING_REQUESTS);
          for (var row in allRecords) {
            final String? jsonStr =
                row[OfflineDBConstants.COL_REQUEST_JSON] as String?;
            if (oldPathToReplace == null &&
                jsonStr != null &&
                jsonStr.contains('app_flutter_')) {
              oldPathToReplace = _extractRootPath(jsonStr);
              if (oldPathToReplace != null) break;
            }
          }

          if (oldPathToReplace != null) {
            debugPrint(
                "$logTag [REMAP] Replacing: $oldPathToReplace WITH: $currentAppFlutterPath");
            await _remapDatabasePaths(
                tempDb, oldPathToReplace, currentAppFlutterPath);
          }

          await tempDb.close();

          final finalDbPath =
              join(await getDatabasesPath(), 'offline_forms.db');
          await File(tempDbPath).copy(finalDbPath);
          await File(tempDbPath).delete();
        }
      }
    } catch (e) {
      LogService.writeLog(message: "$logTag [IMPORT_CRASH] $e");
      rethrow;
    }
  }

  static Future<void> importDbOnly(File dbFile) async {
    try {
      LogService.writeLog(
          message: "$logTag [IMPORT_DB_ONLY] Starting direct DB replace...");

      final finalDbPath = join(await getDatabasesPath(), 'offline_forms.db');

      await dbFile.copy(finalDbPath);

      await OfflineDbModule.init();

      LogService.writeLog(
          message:
              "$logTag [IMPORT_DB_ONLY_SUCCESS] DB replaced successfully.");
    } catch (e) {
      LogService.writeLog(message: "$logTag [IMPORT_DB_ONLY_CRASH] $e");
      rethrow;
    }
  }

  static Future<void> uploadDBFile() async {
    const String uploadAction = "DB_EXPORT_DB_ONLY";

    try {
      // final File dbFile = await OfflineDbModule.getDatabaseFile();
      // final String user =
      //     await AppStorage().retrieveValue(AppStorage.USER_NAME) ??
      //         "UnknownUser";
      // final now = DateTime.now();
      // final String fileName =
      //     "Export_${user}_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_"
      //     "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.db";

      // List<int> fileBytes = await dbFile.readAsBytes();

      // String base64Db = base64Encode(fileBytes);

      final File dbFile = await OfflineDbModule.getDatabaseFile();
      final String user =
          await AppStorage().retrieveValue(AppStorage.USER_NAME) ??
              "UnknownUser";
      final now = DateTime.now();
      final String fileName =
          "Export_${user}_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_"
          "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.zip";
// 1. Get raw bytes
      List<int> fileBytes = await dbFile.readAsBytes();

      // 2. Create an Archive and add your DB file to it
      final archive = Archive();
      final archiveFile = ArchiveFile(
        'database.db', // This is the name the file will have INSIDE the zip
        fileBytes.length,
        fileBytes,
      );
      archive.addFile(archiveFile);

      // 3. Encode to standard ZIP format
      final List<int> zipBytes = ZipEncoder().encode(archive);

      // 4. Base64 the Zipped result
      String base64Zip = base64Encode(zipBytes);

      final String currentSessionId =
          await AppStorage().retrieveValue(AppStorage.SESSIONID) ?? "";
      final String project =
          await AppStorage().retrieveValue(AppStorage.PROJECT_NAME) ?? "";
      final bool isTraceOn =
          await AppStorage().retrieveValue(AppStorage.isLogEnabled) ?? false;

      final Map<String, dynamic> payload = {
        "ARMSessionId": currentSessionId,
        "publickey": "axofflinemobilelog",
        "project": project,
        "submitdata": {
          "username": user,
          "trace": isTraceOn ? "true" : "false",
          "keyfield": "",
          "dataarray": {
            "data": {
              "mode": "new",
              "keyvalue": "",
              "recordid": "0",
              "dc1": {
                "row1": {
                  "errordt": DateTime.now().toIso8601String(),
                  "username": user,
                  "errorresponse": "Exported db for $user from $project",
                  "payload": "",
                  "axpfile_file": {
                    "file1": {
                      "filename": fileName,
                      "fileasbase64": base64Zip,
                    }
                  }
                }
              }
            }
          }
        }
      };

      final ServerConnections serverConnections = ServerConnections();
      final String url =
          Const.getFullARMUrl(ServerConnections.ARM_EXECUTE_PUBLISHED_API);
      Get.showSnackbar(GetSnackBar(
        icon: CupertinoActivityIndicator(
          color: Colors.white,
        ),
        title: "Uploading DB",
        message: "Packaging DB and uploading DB to the server...",
        backgroundColor: MyColors.blue10,
        isDismissible: false,
      ));
      final dynamic res = await serverConnections.postToServer(
        url: url,
        body: jsonEncode(payload),
        isBearer: true,
        show_errorSnackbar: false,
      );
      Get.back();
      if (res != null && res.isNotEmpty) {
        final decoded = jsonDecode(res);
        LogService.writeLog(message: res);
        if (decoded is Map && decoded['success'] == true) {
          await OfflineDbModule.logAudit(
            action: uploadAction,
            remarks: "Successfully uploaded DB file: $fileName",
          );
          LogService.writeLog(message: "[DB_UPLOAD] Success: $fileName");
        } else {
          await OfflineDbModule.logAudit(
            action: uploadAction,
            isError: true,
            response: res.toString(),
            remarks: "Server rejected DB upload: $fileName",
          );
          LogService.writeLog(message: "[DB_UPLOAD] Server Failed: $res");
          throw Exception(decoded['message'] ?? "Server rejected the upload.");
        }
      } else {
        throw Exception("Server rejected the upload.");
      }
    } catch (e) {
      if (Get.isSnackbarOpen) {
        Get.back();
      }
      await OfflineDbModule.logAudit(
        action: uploadAction,
        isError: true,
        response: e.toString(),
        remarks: "Exception during DB file upload",
      );
      LogService.writeLog(message: "[DB_UPLOAD] Exception: $e");

      rethrow;
    }
  }

  Future<void> replaceDatabase(File newDbFile) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'offline_forms.db');

    // 1️⃣ Close existing DB

    // await db.close();

    // 2️⃣ Delete old DB

    if (await File(path).exists()) {
      await File(path).delete();
    }

    // 3️⃣ Copy new DB file

    await newDbFile.copy(path);

    print("Database replaced successfully");
  }

  // static Future<void> importBundleNew(File bundleFile) async {
  //   try {
  //     final bytes = await bundleFile.readAsBytes();
  //     final archive = ZipDecoder().decodeBytes(bytes);

  //     final appDocDir = await getApplicationDocumentsDirectory();
  //     final String newBasePath = appDocDir.path;

  //     for (final file in archive) {
  //       if (file.name.startsWith('assets/')) {
  //         final String fileName = basename(file.name);
  //         final outFile = File('$newBasePath/$fileName');
  //         await outFile.create(recursive: true);
  //         await outFile.writeAsBytes(file.content as List<int>);
  //         LogService.writeLog(message: "$logTag [EXTRACT] ${outFile.path}");
  //       }
  //     }

  //     for (final file in archive) {
  //       if (file.name == 'offline_forms.db') {
  //         final tempDbPath =
  //             join((await getTemporaryDirectory()).path, 'temp_import.db');
  //         await File(tempDbPath).writeAsBytes(file.content as List<int>);

  //         Database tempDb = await openDatabase(tempDbPath);

  //         String? oldPathToReplace;
  //         final allRecords =
  //             await tempDb.query(OfflineDBConstants.TABLE_PENDING_REQUESTS);

  //         for (var row in allRecords) {
  //           final String? jsonStr =
  //               row[OfflineDBConstants.COL_REQUEST_JSON] as String?;
  //           if (jsonStr == null) continue;

  //           final match =
  //               RegExp(r'(/[^\s"]+/app_flutter_[^/"\s]+)').firstMatch(jsonStr);
  //           if (match != null) {
  //             oldPathToReplace = match.group(1);
  //             break;
  //           }
  //         }

  //         if (oldPathToReplace != null) {
  //           debugPrint("$logTag [REMAP] $oldPathToReplace → $newBasePath");
  //           await _remapDatabasePaths(tempDb, oldPathToReplace, newBasePath);
  //         } else {
  //           LogService.writeLog(
  //               message: "$logTag [REMAP_SKIP] No path found to remap.");
  //         }

  //         await tempDb.close();

  //         final finalDbPath =
  //             join(await getDatabasesPath(), 'offline_forms.db');
  //         await File(tempDbPath).copy(finalDbPath);
  //         await File(tempDbPath).delete();

  //         await OfflineDbModule.init();

  //         LogService.writeLog(
  //             message:
  //                 "$logTag [IMPORT_SUCCESS] DB replaced and re-initialized.");
  //       }
  //     }
  //   } catch (e) {
  //     LogService.writeLog(message: "$logTag [IMPORT_CRASH] $e");
  //     rethrow;
  //   }
  // }

//   static Future<void> importBundleNew(File bundleFile) async {
//     try {
//       final bytes = await bundleFile.readAsBytes();
//       final archive = ZipDecoder().decodeBytes(bytes);

//       final appDocDir = await getApplicationDocumentsDirectory();
//       final String newBasePath = appDocDir.path;

//       String rootPrefix = '';
//       for (final file in archive) {
//         final name = file.name;
//         if (name.contains('/')) {
//           final possibleRoot = name.substring(0, name.indexOf('/') + 1);
//           if (possibleRoot != 'assets/') {
//             rootPrefix = possibleRoot;
//           }
//         }
//         break;
//       }

//       debugPrint("$logTag [ZIP_ROOT_PREFIX] '$rootPrefix'");

//       String normalizeName(String name) {
//         if (rootPrefix.isNotEmpty && name.startsWith(rootPrefix)) {
//           return name.substring(rootPrefix.length);
//         }
//         return name;
//       }

//       // for (final file in archive) {
//       //   final String normalizedName = normalizeName(file.name);

//       //   if (normalizedName.startsWith('assets/')) {
//       //     final String fileName = basename(normalizedName);
//       //     final outFile = File('$newBasePath/$fileName');
//       //     await outFile.create(recursive: true);
//       //     await outFile.writeAsBytes(file.content as List<int>);
//       //     LogService.writeLog(message: "$logTag [EXTRACT] ${outFile.path}");
//       //   }
//       // }

//       for (final file in archive) {
//         final String normalizedName = normalizeName(file.name);

//         if (normalizedName.startsWith('assets/')) {
//           final String fileName = basename(normalizedName);

//           final outFile = File(join(newBasePath, fileName));

//           await outFile.create(recursive: true);
//           await outFile.writeAsBytes(file.content as List<int>);
//           LogService.writeLog(message: "$logTag [EXTRACT] ${outFile.path}");
//         }
//       }

//       for (final file in archive) {
//         final String normalizedName = normalizeName(file.name);

//         if (normalizedName == 'offline_forms.db') {
//           final tempDbPath =
//               join((await getTemporaryDirectory()).path, 'temp_import.db');
//           await File(tempDbPath).writeAsBytes(file.content as List<int>);

//           Database tempDb = await openDatabase(tempDbPath);
// ///////////////////////////////////////////////////////////////////
//           // String? oldPathToReplace;
//           // final allRecords =
//           //     await tempDb.query(OfflineDBConstants.TABLE_PENDING_REQUESTS);

//           // for (var row in allRecords) {
//           //   final String? jsonStr =
//           //       row[OfflineDBConstants.COL_REQUEST_JSON] as String?;
//           //   if (jsonStr == null) continue;

//           //   final match =
//           //       RegExp(r'(/[^\s"]+/app_flutter_[^/"\s]+)').firstMatch(jsonStr);
//           //   if (match != null) {
//           //     oldPathToReplace = match.group(1);
//           //     break;
//           //   }
//           // }

//           // if (oldPathToReplace != null) {
//           //   debugPrint("$logTag [REMAP] $oldPathToReplace → $newBasePath");
//           //   await _remapDatabasePaths(tempDb, oldPathToReplace, newBasePath);
//           // } else {
//           //   LogService.writeLog(
//           //       message: "$logTag [REMAP_SKIP] No path to remap.");
//           // }

//           // ... inside importBundleNew, right after opening tempDb ...

//           String? oldPrefix;
//           final allRecords =
//               await tempDb.query(OfflineDBConstants.TABLE_PENDING_REQUESTS);

//           // Step 1: Find the old device's root path up to "app_flutter"
//           for (var row in allRecords) {
//             final String? jsonStr =
//                 row[OfflineDBConstants.COL_REQUEST_JSON] as String?;
//             if (jsonStr == null) continue;

//             final match =
//                 RegExp(r'(")(/[^"]+?/app_flutter)(?=[_/])').firstMatch(jsonStr);
//             if (match != null) {
//               oldPrefix = match.group(2);
//               break;
//             }
//           }

//           if (oldPrefix != null) {
//             debugPrint(
//                 "$logTag [REMAP] Re-aligning DB paths to physical files...");

//             await tempDb.execute('''
//               UPDATE ${OfflineDBConstants.TABLE_PENDING_REQUESTS}
//               SET ${OfflineDBConstants.COL_REQUEST_JSON} = REPLACE(${OfflineDBConstants.COL_REQUEST_JSON}, ?, ?)
//             ''', ['${oldPrefix}_', '$newBasePath/app_flutter_']);

//             await tempDb.execute('''
//               UPDATE ${OfflineDBConstants.TABLE_PENDING_REQUESTS}
//               SET ${OfflineDBConstants.COL_REQUEST_JSON} = REPLACE(${OfflineDBConstants.COL_REQUEST_JSON}, ?, ?)
//             ''', ['$oldPrefix/', '$newBasePath/']);

//             LogService.writeLog(
//                 message:
//                     "$logTag [REMAP_SUCCESS] Paths aligned perfectly with extraction.");
//           } else {
//             LogService.writeLog(
//                 message: "$logTag [REMAP_SKIP] No path found to remap.");
//           }

//           await tempDb.close();

//           await OfflineDbModule.init();

//           LogService.writeLog(
//               message:
//                   "$logTag [IMPORT_SUCCESS] DB replaced and re-initialized.");
//         }
//       }
//     } catch (e) {
//       LogService.writeLog(message: "$logTag [IMPORT_CRASH] $e");
//       rethrow;
//     }
//   }

  static Future<void> importBundleNew(File bundleFile) async {
    try {
      final bytes = await bundleFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final appDocDir = await getApplicationDocumentsDirectory();
      final String newBasePath = appDocDir.path;

      String rootPrefix = '';
      for (final file in archive) {
        final name = file.name;
        if (name.contains('/')) {
          final possibleRoot = name.substring(0, name.indexOf('/') + 1);
          if (possibleRoot != 'assets/') {
            rootPrefix = possibleRoot;
          }
        }
        break;
      }

      debugPrint("$logTag [ZIP_ROOT_PREFIX] '$rootPrefix'");

      String normalizeName(String name) {
        if (rootPrefix.isNotEmpty && name.startsWith(rootPrefix)) {
          return name.substring(rootPrefix.length);
        }
        return name;
      }

      // 1. Extract files and specifically track their names
      List<String> extractedFileNames = [];

      for (final file in archive) {
        final String normalizedName = normalizeName(file.name);

        if (normalizedName.startsWith('assets/')) {
          final String fileName = basename(normalizedName);
          final outFile = File(join(newBasePath, fileName));

          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
          extractedFileNames.add(fileName); // Track the exact filename

          LogService.writeLog(message: "$logTag [EXTRACT] ${outFile.path}");
        }
      }

      // 2. Process and Remap Database
      for (final file in archive) {
        final String normalizedName = normalizeName(file.name);

        if (normalizedName == 'offline_forms.db') {
          final tempDbPath =
              join((await getTemporaryDirectory()).path, 'temp_import.db');
          await File(tempDbPath).writeAsBytes(file.content as List<int>);

          Database tempDb = await openDatabase(tempDbPath);

          LogService.writeLog(
              message:
                  "$logTag [REMAP] Starting exact file remapping in Dart...");
          final allRecords =
              await tempDb.query(OfflineDBConstants.TABLE_PENDING_REQUESTS);

          int remapCount = 0;

          // 3. BULLETPROOF JSON REMAP
          for (var row in allRecords) {
            final int id = row[OfflineDBConstants.COL_ID] as int;
            String? jsonStr =
                row[OfflineDBConstants.COL_REQUEST_JSON] as String?;
            if (jsonStr == null) continue;

            bool changed = false;

            for (String fileName in extractedFileNames) {
              // Finds ANY absolute path inside the JSON that ends with this exact filename
              // e.g., matches "/data/user/0/com.old.app/app_flutter_123.jpg"
              final regex =
                  RegExp(r'"(/[^\"]*?' + RegExp.escape(fileName) + r')"');

              if (regex.hasMatch(jsonStr!)) {
                // The actual correct path where we just extracted the file
                final newFullPath = join(newBasePath, fileName);

                // Replace the old messed up path with the exact new one
                jsonStr = jsonStr.replaceAllMapped(
                    regex, (match) => '"$newFullPath"');
                changed = true;
              }
            }

            if (changed) {
              await tempDb.update(
                OfflineDBConstants.TABLE_PENDING_REQUESTS,
                {OfflineDBConstants.COL_REQUEST_JSON: jsonStr},
                where: '${OfflineDBConstants.COL_ID} = ?',
                whereArgs: [id],
              );
              remapCount++;
            }
          }

          LogService.writeLog(
              message:
                  "$logTag [REMAP] Successfully remapped $remapCount records.");

          await tempDb.close();

          final finalDbPath =
              join(await getDatabasesPath(), 'offline_forms.db');
          await File(tempDbPath).copy(finalDbPath);
          await File(tempDbPath).delete();

          await OfflineDbModule.init();

          LogService.writeLog(
              message:
                  "$logTag [IMPORT_SUCCESS] DB replaced and re-initialized.");
        }
      }
    } catch (e) {
      LogService.writeLog(message: "$logTag [IMPORT_CRASH] $e");
      rethrow;
    }
  }

  static void _findPathsInJson(dynamic data, List<String> paths) {
    if (data is Map) {
      data.forEach((key, value) => _findPathsInJson(value, paths));
    } else if (data is List) {
      for (var item in data) {
        _findPathsInJson(item, paths);
      }
    } else if (data is String && data.startsWith('/')) {
      paths.add(data);
    }
  }

  static String? _extractRootPath(String jsonStr) {
    final match = RegExp(r'(/[^\s]+)/app_flutter(?=_)').firstMatch(jsonStr);
    return match?.group(0);
  }

  static Future<void> _remapDatabasePaths(
      Database db, String oldRoot, String newRoot) async {
    await db.execute('''
      UPDATE ${OfflineDBConstants.TABLE_PENDING_REQUESTS}
      SET ${OfflineDBConstants.COL_REQUEST_JSON} = REPLACE(${OfflineDBConstants.COL_REQUEST_JSON}, ?, ?)
    ''', [oldRoot, newRoot]);
  }

  // static Future<void> _remapDatabasePaths(
  //     Database db, String oldRoot, String newRoot) async {
  //   String cleanOld = oldRoot.endsWith('/') ? oldRoot : '$oldRoot/';
  //   String cleanNew = newRoot.endsWith('/') ? newRoot : '$newRoot/';

  //   await db.execute('''
  //   UPDATE ${OfflineDBConstants.TABLE_PENDING_REQUESTS}
  //   SET ${OfflineDBConstants.COL_REQUEST_JSON} = REPLACE(${OfflineDBConstants.COL_REQUEST_JSON}, ?, ?)
  // ''', [cleanOld, cleanNew]);

  //   log("EXTRACT  REMAP DONE: $cleanOld -> $cleanNew", name: "AX_BUNDLE_LOG");
  // }

  static Future<void> deleteBackup() async {
    try {
      final backupPath = await _backupFilePath();
      final metaPath = await _backupMetaPath();

      final backupFile = File(backupPath);
      final metaFile = File(metaPath);

      if (await backupFile.exists()) {
        await backupFile.delete();
        debugPrint("$logTag [BACKUP_DELETE] Deleted backup: $backupPath");
      }

      if (await metaFile.exists()) {
        await metaFile.delete();
        LogService.writeLog(
            message: "$logTag [BACKUP_DELETE] Deleted metadata: $metaPath");
      }
    } catch (e) {
      LogService.writeLog(
          message: "$logTag [BACKUP_DELETE_WARN] Failed to delete backup: $e");
    }
  }
}

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();

//   static Database? _database;

//   DatabaseHelper._init();

//   /// Get database instance

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDB('offline_forms.db');

//     return _database!;
//   }

//   /// Initialize database

//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();

//     final path = join(dbPath, fileName);

//     return await openDatabase(path);
//   }

//   /// FIRST INSTALL: Copy DB from assets if not exists

//   Future<void> copyDatabaseFromAssets() async {
//     final dbPath = await getDatabasesPath();

//     final path = join(dbPath, 'offline_forms.db');

//     if (await File(path).exists()) {
//       print("Database already exists");
//       return;
//     }

//     ByteData data = await rootBundle.load('assets/database/offline_forms.db');

//     List<int> bytes =
//         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//     await File(path).writeAsBytes(bytes, flush: true);

//     print("Database copied from assets");
//   }

//   /// Replace existing database with new file

//   Future<void> replaceDatabase(File newDbFile) async {
//     final dbPath = await getDatabasesPath();

//     final path = join(dbPath, 'offline_forms.db');

//     // 1️⃣ Close existing DB

//     await close();

//     // 2️⃣ Delete old DB

//     if (await File(path).exists()) {
//       await File(path).delete();
//     }

//     // 3️⃣ Copy new DB file

//     await newDbFile.copy(path);

//     print("Database replaced successfully");
//   }

//   /// Close database properly

//   Future<void> close() async {
//     final db = _database;

//     if (db != null) {
//       await db.close();

//       _database = null;
//     }
//   }
// }
