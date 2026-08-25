import 'dart:developer';
import 'package:axpertflutter/Utils/ServerConnections/ServerConnections.dart';

import 'offline_config_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/Const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:axpertflutter/Utils/ServerConnections/ExecuteApi.dart';

import 'offline_sync_task_handler.dart';

const String _tag = '[BG_SYNC_SERVICE]';
const int _kServiceId = 512;
const int _kDefaultInterval = 10;
const int _kMinInterval = 10;

String _intervalStorageKey(String username, String projectName) =>
    'sync_interval_${username}_$projectName';

class OfflineBackgroundSyncService {
  OfflineBackgroundSyncService._();
  static final OfflineBackgroundSyncService instance =
      OfflineBackgroundSyncService._();

  // ── Observable state — bind in UI with Obx ───────────────────────────────
  final RxString statusMessage = 'Idle'.obs;
  final RxBool isSyncing = false.obs;
  final Rxn<String> lastSyncedAt = Rxn<String>();
  final RxInt pendingCount = 0.obs;
  final RxInt intervalMinutes = _kDefaultInterval.obs;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  // ── One-time setup — call in main() BEFORE runApp ────────────────────────

  static void initCommunicationPort() {
    FlutterForegroundTask.initCommunicationPort();
  }

  void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'offline_sync_channel',
        channelName: 'Offline Sync',
        channelDescription:
            'Uploads pending offline form records to the server.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        playSound: false,
        enableVibration: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        autoRunOnBoot: false,
      ),
    );

    FlutterForegroundTask.addTaskDataCallback(_onTaskData);
    log('$_tag Initialized.', name: _tag);
  }

  // ── Start — call on login if autoSyncEnabled is true ─────────────────────

  Future<void> start() async {
    if (_isRunning) {
      log('$_tag Already running — skipped.', name: _tag);
      return;
    }

    final bool autoSyncEnabled =
        AppStorage().retrieveValue(AppStorage.AUTO_SYNC) ?? false;
    if (!autoSyncEnabled) {
      log('$_tag Auto sync disabled — service not started.', name: _tag);
      await LogService.writeLog(
          message: '$_tag start() aborted — auto sync disabled.');
      return;
    }

    if (!await _checkInternet()) {
      await LogService.writeLog(
          message: '$_tag start() aborted — no internet.');
      return;
    }

    // final int interval = await _loadIntervalFromStorage();
    // intervalMinutes.value = interval;

    final int interval = OfflineConfigService.getCachedInterval();
    if (interval == 0) {
      log('$_tag sync_interval_minutes=0 — sync disabled by server config.',
          name: _tag);
      await LogService.writeLog(
          message: '$_tag start() aborted — sync disabled by server config.');
      _isRunning = false;
      return;
    }
    intervalMinutes.value = interval;

    _isRunning = true;
    isSyncing.value = false;
    _setStatus('Sync service active — checking every ${_labelFor(interval)}');

    // Android 13+ notification permission
    final NotificationPermission perm =
        await FlutterForegroundTask.checkNotificationPermission();
    if (perm != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    final String armUrl =
        Const.getFullARMUrl(ServerConnections.ARM_EXECUTE_PUBLISHED_API);
    await FlutterForegroundTask.saveData(key: 'armUrl', value: armUrl);
    await FlutterForegroundTask.saveData(
        key: 'intervalMinutes', value: interval);

    final bool alreadyRunning = await FlutterForegroundTask.isRunningService;
    if (alreadyRunning) {
      await FlutterForegroundTask.stopService();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    await FlutterForegroundTask.startService(
      serviceId: _kServiceId,
      notificationTitle: '🔵 Sync Service Active',
      notificationText:
          'Monitoring for offline records every ${_labelFor(interval)}',
      callback: startSyncCallback,
    );

    await LogService.writeLog(
        message: '$_tag Service started. Interval: ${interval}min.');
    log('$_tag Foreground service started.', name: _tag);
  }

  // ── Stop ──────────────────────────────────────────────────────────────────

  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
    _reset();
    await LogService.writeLog(message: '$_tag Stopped.');
    log('$_tag Stopped.', name: _tag);
  }

  // ── Auto sync toggle — wire to your existing settings button ─────────────

  Future<bool> setAutoSync({required bool enabled}) async {
    if (!enabled && isSyncing.value) {
      showSyncGuardDialog();
      return false;
    }

    final bool current =
        AppStorage().retrieveValue(AppStorage.AUTO_SYNC) ?? false;
    if (current != enabled) {
      await OfflineDbModule.toggleAutoSync();
    }

    if (enabled) {
      await start();
    } else {
      await stop();
    }

    await LogService.writeLog(
        message: '$_tag Auto sync ${enabled ? "enabled" : "disabled"}.');
    return true;
  }

  bool canProceedWithAction() {
    if (isSyncing.value) {
      showSyncGuardDialog();
      return false;
    }
    return true;
  }

  // ── Interval ──────────────────────────────────────────────────────────────

  Future<int> getIntervalMinutes() async =>
      OfflineConfigService.getCachedInterval();
  // Future<int> getIntervalMinutes() async => _loadIntervalFromStorage();

  Future<void> setIntervalMinutes(int minutes) async {
    final int clamped = minutes.clamp(_kMinInterval, 1440);
    await _saveIntervalToStorage(clamped);
    intervalMinutes.value = clamped;

    if (_isRunning) {
      await FlutterForegroundTask.saveData(
          key: 'intervalMinutes', value: clamped);
      FlutterForegroundTask.sendDataToTask({
        SyncDataKeys.event: SyncDataKeys.cmdUpdateInterval,
        SyncDataKeys.intervalMinutes: clamped,
      });
      _setStatus('Sync interval updated — every ${_labelFor(clamped)}');
      await LogService.writeLog(
          message: '$_tag Interval updated to $clamped min.');
    }
  }

  // ── Manual trigger ────────────────────────────────────────────────────────

  // Future<void> triggerImmediateSync() async {
  //   if (isSyncing.value) return;

  //   final bool running = await FlutterForegroundTask.isRunningService;
  //   if (running) {
  //     FlutterForegroundTask.sendDataToTask(
  //         {SyncDataKeys.event: SyncDataKeys.cmdTriggerNow});
  //     isSyncing.value = true;
  //     _setStatus('Manual sync triggered...');
  //   } else {
  //     _isRunning = false;
  //     await start();
  //   }
  // }

  // ── App lifecycle ─────────────────────────────────────────────────────────

  Future<void> onAppResumed() async {
    final bool running = await FlutterForegroundTask.isRunningService;
    _isRunning = running;
    if (!running) await _refreshStatusFromDb();
    log('$_tag App resumed. serviceRunning=$running', name: _tag);
  }

  // ── Sync Guard Dialog — call from settings toggle or logout ───────────────

  void showSyncGuardDialog({VoidCallback? onForceStop}) {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.sync_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(child: Text('Sync In Progress')),
            ],
          ),
          content: const Text(
            'A sync is currently uploading records to the server.\n\n'
            'Stopping the service or logging out now may cause incomplete '
            'uploads or data loss.\n\n'
            'Please wait for the sync to complete.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Wait'),
            ),
            // TextButton(
            //   onPressed: () async {
            //     Get.back();
            //     await stop();
            //     onForceStop?.call();
            //   },
            //   style: TextButton.styleFrom(foregroundColor: Colors.red),
            //   child: const Text('Force Stop Anyway'),
            // ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ── Data arriving from task isolate ──────────────────────────────────────

  void _onTaskData(Object data) async {
    if (data is! Map) return;
    final String event = data[SyncDataKeys.event] as String? ?? '';

    switch (event) {
      case SyncDataKeys.evtProgress:
        final int cur = data[SyncDataKeys.current] as int? ?? 0;
        final int total = data[SyncDataKeys.total] as int? ?? 0;
        isSyncing.value = true;
        _setStatus('Uploading $cur / $total records...');
        break;

      case SyncDataKeys.evtDone:
        final String result = data[SyncDataKeys.result] as String? ?? '';
        final int remaining = data[SyncDataKeys.pendingCount] as int? ?? 0;
        final String? lastTs = data[SyncDataKeys.lastSyncedAt] as String?;
        isSyncing.value = false;
        pendingCount.value = remaining;
        if (lastTs != null && lastTs.isNotEmpty) lastSyncedAt.value = lastTs;
        _setStatus(remaining > 0
            ? '⚠️ $remaining records pending — retry in ${_labelFor(intervalMinutes.value)}'
            : '✅ All synced — next check in ${_labelFor(intervalMinutes.value)}');
        break;
      case SyncDataKeys.evtAuthFailed:
        final int statusCode = data['statusCode'] as int? ?? 401;
        isSyncing.value = false;
        _setStatus('Session expired — please log in again.');
        await LogService.writeLog(
            message:
                '$_tag Auth failure ($statusCode) received from isolate. Stopping service.');
        await stop();
        break;
      case SyncDataKeys.evtNoInternet:
        isSyncing.value = false;
        _setStatus(
            '📡 No connection — retrying in ${_labelFor(intervalMinutes.value)}');
        break;

      case SyncDataKeys.evtError:
        final String err = data[SyncDataKeys.result] as String? ?? '';
        isSyncing.value = false;
        _setStatus(
            '🔴 Sync error — retrying in ${_labelFor(intervalMinutes.value)}');
        LogService.writeLog(message: '$_tag Error from task: $err');
        break;
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  // Future<int> _loadIntervalFromStorage() async {
  //   try {
  //     final String? username = AppStorage().retrieveValue(AppStorage.USER_NAME);
  //     final String? projectName =
  //         AppStorage().retrieveValue(AppStorage.PROJECT_NAME);
  //     if (username == null || projectName == null) return _kDefaultInterval;

  //     final dynamic stored = AppStorage()
  //         .retrieveValue(_intervalStorageKey(username, projectName));
  //     if (stored == null) return _kDefaultInterval;

  //     return (int.tryParse(stored.toString()) ?? _kDefaultInterval)
  //         .clamp(_kMinInterval, 1440);
  //   } catch (_) {
  //     return _kDefaultInterval;
  //   }
  // }

  Future<void> _saveIntervalToStorage(int minutes) async {
    try {
      final String? username = AppStorage().retrieveValue(AppStorage.USER_NAME);
      final String? projectName =
          AppStorage().retrieveValue(AppStorage.PROJECT_NAME);
      if (username == null || projectName == null) return;
      AppStorage().storeValue(
          _intervalStorageKey(username, projectName), minutes.toString());
    } catch (_) {}
  }

  Future<void> _refreshStatusFromDb() async {
    try {
      final String? ts = await OfflineDbModule.getLastSyncedTimestamp();
      if (ts == null || ts.isEmpty) {
        _setStatus('Not yet synced');
        return;
      }
      lastSyncedAt.value = ts;
      _setStatus('Last sync: ${_formatDateTime(DateTime.parse(ts).toLocal())}');
    } catch (_) {
      _setStatus('Idle');
    }
  }

  void _reset() {
    _isRunning = false;
    isSyncing.value = false;
    lastSyncedAt.value = null;
    pendingCount.value = 0;
    statusMessage.value = 'Idle';
    intervalMinutes.value = _kDefaultInterval;
  }

  void _setStatus(String msg) => statusMessage.value = msg;

  Future<bool> _checkInternet() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
    } catch (_) {
      return false;
    }
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today $time';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.year == yesterday.year &&
        dt.month == yesterday.month &&
        dt.day == yesterday.day) return 'Yesterday $time';
    return '${dt.day}/${dt.month}/${dt.year} $time';
  }

  String _labelFor(int m) {
    if (m < 60) return '$m min';
    if (m == 60) return '1 hour';
    if (m < 1440) return '${m ~/ 60} hours';
    return '24 hours';
  }
}

// ─── App Lifecycle Observer ───────────────────────────────────────────────────

class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver._();
  static final AppLifecycleObserver instance = AppLifecycleObserver._();

  void register() => WidgetsBinding.instance.addObserver(this);
  void unregister() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      OfflineBackgroundSyncService.instance.onAppResumed();
    }
  }
}
