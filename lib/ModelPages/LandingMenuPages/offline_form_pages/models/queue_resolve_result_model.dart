import 'package:flutter/material.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_constants.dart';

class QueueResolveResultModel {
  final String queueId;
  final int? finalStatus;
  final int successCount;
  final int failedCount;
  final String statusMessage;

  const QueueResolveResultModel({
    required this.queueId,
    this.finalStatus,
    required this.successCount,
    required this.failedCount,
    this.statusMessage = '',
  });

  bool get isSuccess => finalStatus == OfflineDBConstants.QUEUE_STATUS_SUCCESS;
  bool get isPartial => finalStatus == OfflineDBConstants.QUEUE_STATUS_PARTIAL;
  bool get isError => finalStatus == OfflineDBConstants.QUEUE_STATUS_ERROR;
  bool get isNotFound => finalStatus == null;

  String get statusLabel {
    if (isNotFound) return "Not Found";
    if (isSuccess) return "Success";
    if (isPartial) return "Partial";
    if (isError) return "Error";
    return "Unknown";
  }

  Color get statusColor {
    if (isNotFound) return Colors.grey;
    if (isSuccess) return const Color(0xff16A34A);
    if (isPartial) return const Color(0xffF59E0B);
    if (isError) return const Color(0xffDC2626);
    return Colors.grey;
  }

  Color get statusBgColor {
    if (isNotFound) return Colors.grey.shade100;
    if (isSuccess) return const Color(0xffDCFCE7);
    if (isPartial) return const Color(0xffFEF3C7);
    if (isError) return const Color(0xffFEE2E2);
    return Colors.grey.shade100;
  }

  IconData get statusIcon {
    if (isNotFound) return Icons.help_outline_rounded;
    if (isSuccess) return Icons.check_circle_outline_rounded;
    if (isPartial) return Icons.warning_amber_rounded;
    if (isError) return Icons.cancel_outlined;
    return Icons.help_outline_rounded;
  }
}
