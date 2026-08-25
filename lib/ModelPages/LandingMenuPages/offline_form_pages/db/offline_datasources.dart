import 'dart:convert';
import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:axpertflutter/Utils/ServerConnections/ExecuteApi.dart';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfflineDatasources {
  static final http.Client _client = http.Client();

  // API ENDPOINTS
  static const String API_FETCH_OFFLINE_PAGES = '/api/offline/pages';
  // static const String API_SUBMIT_OFFLINE_FORM_REST =
  //     'https://agileqa.agilecloud.biz/qaaxpert11.4basescripts/ASBTStructRest.dll/datasnap/rest/TASBTstruct/savedata';

// static const String API_SUBMIT_OFFLINE_FORM = ExecuteApi.API_ARM_EXECUTE_PUBLISHED;
  static String API_FETCH_DATASOURCE(String name) {
    return '/api/datasource/$name';
  }

  static String baseUrl = '';

  // COMMON HEADERS
  static Map<String, String> _jsonHeader({String? bearerToken}) {
    if (bearerToken != null && bearerToken.isNotEmpty) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };
    }
    return {
      'Content-Type': 'application/json',
    };
  }

  // GET CALL
  static Future<String?> get({
    required String endpoint,
    String? bearerToken,
  }) async {
    try {
      final uri = Uri.parse(baseUrl + endpoint);
      final response = await _client.get(
        uri,
        headers: _jsonHeader(bearerToken: bearerToken),
      );

      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // POST CALL
  static Future<String?> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? bearerToken,
  }) async {
    try {
      final uri = Uri.parse(baseUrl + endpoint);
      final response = await _client.post(
        uri,
        headers: _jsonHeader(bearerToken: bearerToken),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // static Future<String?> fetchDatasource({
  //   required String datasourceName,
  //   required String sessionId,
  //   required String username,
  //   required String appName,
  //   Map<String, dynamic>? sqlParams,
  // }) async {
  //   final url =
  //       Const.getFullARMUrl(ServerConnections.API_GET_DATASOURCE_RESPONSE);

  //   final body = {
  //     "ARMSessionId": sessionId,
  //     "username": username,
  //     "appname": appName,
  //     "datasource": datasourceName,
  //     "sqlParams": sqlParams ?? {},
  //   };
  //   debugPrint("DATA_SOURCE body=> $body");

  //   return await ServerConnections().postToServer(
  //     url: url,
  //     isBearer: true,
  //     body: jsonEncode(body),
  //   );
  // }

  static Future<Map<String, String>> fetchDatasourceBulk({
    required List<String> datasourceNames,
    required String sessionId,
    required String username,
    required String appName,
    Map<String, dynamic>? sqlParams,
  }) async {
    const String tag = "[FETCH_DS_BULK]";
    if (datasourceNames.isEmpty) return {};

    final url = Const.getFullARMUrl(ServerConnections.ARM_AXLIST);
    var isTraceOn =
        await AppStorage().retrieveValue(AppStorage.isLogEnabled) ?? false;
    final Map<String, dynamic> body = {
      "ARMSessionId": sessionId,
      "action": "view",
      "ADSNames": datasourceNames,
      "trace": isTraceOn,
      "pageno": 1,
      "pagesize": 0,
      "getallrecordscount": false,
      "CachePermissions": true,
      "sqlparams": sqlParams ?? {},
    };

    debugPrint("DATA_SOURCE_BULK body=> $body");
    LogService.writeLog(
      message:
          "$tag REQUEST ds=$datasourceNames url=$url body=${jsonEncode(body)}",
    );

    final dynamic responseStr = await ServerConnections().postDsToServer(
      url: url,
      isBearer: true,
      body: jsonEncode(body),
    );

    final String serverResponse = responseStr?.toString() ?? "";
    LogService.writeLog(
      message:
          "$tag RAW_RESPONSE ds=$datasourceNames response_len=${serverResponse.length}",
    );

    if (serverResponse.isEmpty ||
        ServerConnections.isDsErrorResponse(serverResponse)) {
      LogService.writeLog(
        message:
            "$tag NON_SUCCESS_RESPONSE ds=$datasourceNames — returning {}.",
      );
      return {};
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(serverResponse);
    } catch (e) {
      LogService.writeLog(
          message: "$tag DECODE_FAILED ds=$datasourceNames — $e");
      return {};
    }

    final result = decoded['result'];
    if (result is! Map<String, dynamic> || result['success'] != true) {
      LogService.writeLog(
        message: "$tag NOT_SUCCESS ds=$datasourceNames — "
            "message=${result is Map ? result['message'] : result}.",
      );
      return {};
    }

    final dsWrappers = result['data'];
    if (dsWrappers is! List) {
      LogService.writeLog(
        message:
            "$tag NO_DS_WRAPPERS ds=$datasourceNames — result.data not a List.",
      );
      return {};
    }

    final Map<String, String> out = {};
    for (final wrapper in dsWrappers) {
      if (wrapper is! Map<String, dynamic>) continue;
      final String? adsname = wrapper['adsname']?.toString();
      if (adsname == null || adsname.isEmpty) continue;
      if (wrapper.containsKey('error')) {
        LogService.writeLog(
            message:
                "$tag DS_ERROR adsname=$adsname error=${wrapper['error']}");
        continue;
      }
      final rows = wrapper['data'];
      final List rowsList = rows is List ? rows : [];

      out[adsname] = jsonEncode({
        "result": {
          "message": "success",
          "data": rowsList,
          "success": true,
        },
      });
    }

    LogService.writeLog(
      message: "$tag PARSED_OK requested=${datasourceNames.length} "
          "returned=${out.keys.toList()} missing="
          "${datasourceNames.where((d) => !out.containsKey(d)).toList()}",
    );

    return out;
  }
}
