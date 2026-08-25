import 'dart:io';

enum QueueSubmissionStatus {
  success,
  error,
  pending,
  partial,
  refetch,
  sending,
  created,
}

class QueuedPayloadData {
  final File file;
  final String queueId;
  final List<int> axmRecIds;

  QueuedPayloadData({
    required this.file,
    required this.queueId,
    required this.axmRecIds,
  });
}

class BuildQueueResult {
  final String message;
  final Future<void>? uploadTask;

  BuildQueueResult({required this.message, this.uploadTask});
}

class CachedSaveItemModel {
  final QueueSubmissionStatus submissionStatus;
  final String qId;
  final int totalItems;
  final int successItems;
  final int failedItems;
  final bool fcmRecived;
  final String smallStatusMessage;

  const CachedSaveItemModel({
    required this.submissionStatus,
    required this.qId,
    required this.totalItems,
    required this.successItems,
    required this.failedItems,
    required this.fcmRecived,
    required this.smallStatusMessage,
  });

  CachedSaveItemModel copyWith({
    QueueSubmissionStatus? submissionStatus,
    String? qId,
    int? totalItems,
    int? successItems,
    int? failedItems,
    bool? fcmRecived,
    String? smallStatusMessage,
  }) {
    return CachedSaveItemModel(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      qId: qId ?? this.qId,
      totalItems: totalItems ?? this.totalItems,
      successItems: successItems ?? this.successItems,
      failedItems: failedItems ?? this.failedItems,
      fcmRecived: fcmRecived ?? this.fcmRecived,
      smallStatusMessage: smallStatusMessage ?? this.smallStatusMessage,
    );
  }

  CachedSaveItemModel updateStatus(QueueSubmissionStatus status) =>
      copyWith(submissionStatus: status);

  CachedSaveItemModel markFcmReceived() => copyWith(fcmRecived: true);

  CachedSaveItemModel incrementSuccess([int by = 1]) =>
      copyWith(successItems: successItems + by);

  CachedSaveItemModel incrementFailure([int by = 1]) =>
      copyWith(failedItems: failedItems + by);

  CachedSaveItemModel updateCounts({int? success, int? failed}) => copyWith(
        successItems: success,
        failedItems: failed,
      );

  CachedSaveItemModel incrementTotal([int by = 1]) =>
      copyWith(totalItems: totalItems + by);
}
