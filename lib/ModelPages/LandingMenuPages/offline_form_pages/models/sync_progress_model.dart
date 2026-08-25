import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/sync_error_model.dart';

class SyncProgressModel {
  RxInt totalItems = 0.obs;
  RxInt processedItems = 0.obs;
  RxInt successCount = 0.obs;
  RxInt failureCount = 0.obs;

  RxString message = "Initializing...".obs;
  RxString errMessage = "".obs;
  RxString title = "Processing".obs;
  RxBool isLoading = true.obs;
  RxBool isCompleted = false.obs;
  RxBool isCompletedWithError = false.obs;
  RxBool showSyncAuditLogsButton = false.obs;
  List<Map<String, dynamic>> failedRecords = [];
  RxList<SyncErrorModel> syncErrors = <SyncErrorModel>[].obs;
  SyncProgressModel({String initialTitle = "Processing"}) {
    title.value = initialTitle;
  }

  RxBool isAuditPushing = false.obs;
  RxBool isAuditDone = false.obs;
  RxInt auditTotal = 0.obs;
  RxInt auditSynced = 0.obs;
  RxInt auditFailed = 0.obs;
  RxString auditMessage = ''.obs;
  RxBool isSessionError = false.obs;
  void init({required int total, String msg = "Starting..."}) {
    totalItems.value = total;
    processedItems.value = 0;
    successCount.value = 0;
    failureCount.value = 0;
    message.value = msg;
    errMessage.value = '';
    syncErrors.clear();
    isLoading.value = true;
    isCompleted.value = false;
    isCompletedWithError.value = false;
    isAuditPushing.value = false;
    isAuditDone.value = false;
    auditTotal.value = 0;
    auditSynced.value = 0;
    auditFailed.value = 0;
    auditMessage.value = '';
    isSessionError.value = false;
    showSyncAuditLogsButton.value = false;
  }

  void startAuditPhase(int total) {
    auditTotal.value = total;
    auditSynced.value = 0;
    auditFailed.value = 0;
    auditMessage.value = 'Uploading audit logs...';
    isAuditPushing.value = true;
    isAuditDone.value = false;
  }

  void incrementAudit({bool isSuccess = true}) {
    if (isSuccess) {
      auditSynced.value++;
    } else {
      auditFailed.value++;
    }
  }

  void completeAuditPhase() {
    isAuditPushing.value = false;
    isAuditDone.value = true;
    auditMessage.value = '${auditSynced.value} synced'
        '${auditFailed.value > 0 ? ", ${auditFailed.value} failed" : ""}';
  }

  double get auditProgressValue {
    if (auditTotal.value == 0) return 0.0;
    final done = auditSynced.value + auditFailed.value;
    if (done > auditTotal.value) return 1.0;
    return done / auditTotal.value;
  }

  void addFailedRecord(int id, String error) {
    failedRecords.add({
      "id": id,
      "error": error,
      "timestamp": DateFormat('yyyy-MM-dd h:mm a').format(DateTime.now()),
    });
  }

  void clearFailedRecords() {
    failedRecords.clear();
  }

  void complete() {
    isLoading.value = false;
    isCompleted.value = true;
    processedItems.value = totalItems.value;
    message.value = "Process Completed";
  }

  void completeWithError(
      {required String errorMsg, required String statuscode}) {
    isLoading.value = false;
    isCompleted.value = true;
    isCompletedWithError.value = true;
    processedItems.value = totalItems.value;
    title.value = "Error Occurred";
    message.value = "statuscode : $statuscode";
    errMessage.value = errorMsg;
  }

  void updateMessage(String msg) {
    message.value = msg;
  }

  void increment({bool isSuccess = true}) {
    processedItems.value++;
    if (isSuccess) {
      successCount.value++;
    } else {
      failureCount.value++;
    }
  }

  double get progressValue {
    if (totalItems.value == 0) return 0.0;
    if (processedItems.value > totalItems.value) return 1.0;
    return processedItems.value / totalItems.value;
  }

  addErrors({
    required String title,
    required String errorText,
  }) {
    syncErrors.add(SyncErrorModel(title: title, errorText: errorText));
  }
}
