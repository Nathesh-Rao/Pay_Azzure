// class  {}
import 'dart:convert';
import 'package:http/http.dart' as http;

class SubmitdataApiresponsemodel {
  final bool success;
  final String message;

  final String? recordId;

  /// actual HTTP response status
  final int statusCode;

  final bool isValidationError;
  final bool isServerError;
  final bool isSessionError;

  final String rawBody;

  SubmitdataApiresponsemodel({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.rawBody,
    this.recordId,
    this.isValidationError = false,
    this.isServerError = false,
    this.isSessionError = false,
  });

  factory SubmitdataApiresponsemodel.fromHttpResponse(http.Response response) {
    final int httpStatusCode = response.statusCode;
    final String body = response.body;

    /// Empty body
    if (body.isEmpty) {
      return SubmitdataApiresponsemodel(
        success: false,
        message: "Empty response from server",
        statusCode: httpStatusCode,
        rawBody: body,
        isServerError: true,
      );
    }

    try {
      final Map<String, dynamic> json = jsonDecode(body);

      /// =========================================================
      /// CASE 1 - SUCCESS
      /// =========================================================

      if (json['success'] == true && json['result'] is String) {
        final result = json['result'] as String;

        String? extractedRecordId;

        if (result.contains('recordid=')) {
          extractedRecordId = result.split('recordid=').last.trim();
        }

        return SubmitdataApiresponsemodel(
          success: true,
          message: result,
          recordId: extractedRecordId,
          statusCode: httpStatusCode,
          rawBody: body,
        );
      }

      /// =========================================================
      /// CASE 2 - VALIDATION ERROR
      /// =========================================================

      if (json['success'] == false && json['message'] != null) {
        return SubmitdataApiresponsemodel(
          success: false,
          message: json['message'].toString(),
          statusCode: httpStatusCode,
          rawBody: body,
          isValidationError: true,
        );
      }

      /// =========================================================
      /// CASE 3 - SERVER ERROR
      /// =========================================================

      if (json['result'] is Map<String, dynamic> &&
          json['result']['statuscode'] != null) {
        final resultObj = json['result'];

        return SubmitdataApiresponsemodel(
          success: false,
          message: resultObj['message']?.toString() ?? "Server Error",
          statusCode: httpStatusCode,
          rawBody: body,
          isServerError: true,
        );
      }

      /// =========================================================
      /// CASE 4 - SESSION ERROR
      /// =========================================================

      if (json['result'] is Map<String, dynamic> &&
          json['result']['success'] == false) {
        final resultObj = json['result'];

        return SubmitdataApiresponsemodel(
          success: false,
          message: resultObj['message']?.toString() ?? "Session Error",
          statusCode: httpStatusCode,
          rawBody: body,
          isSessionError: true,
        );
      }

      /// =========================================================
      /// FALLBACK
      /// =========================================================

      return SubmitdataApiresponsemodel(
        success: false,
        message: "Invalid Response Format",
        statusCode: httpStatusCode,
        rawBody: body,
      );
    } catch (e) {
      return SubmitdataApiresponsemodel(
        success: false,
        message: "Response parse error: $e",
        statusCode: httpStatusCode,
        rawBody: body,
        isServerError: true,
      );
    }
  }

  factory SubmitdataApiresponsemodel.failure({
    required String message,
    required int statusCode,
  }) {
    return SubmitdataApiresponsemodel(
      success: false,
      message: message,
      statusCode: statusCode,
      rawBody: '',
      isServerError: true,
    );
  }
}
