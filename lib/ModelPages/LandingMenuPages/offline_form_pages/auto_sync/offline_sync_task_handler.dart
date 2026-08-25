import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_storage/get_storage.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';

const String _tag = '[FG_SYNC_TASK]';

// ─── Keys shared between both isolates ───────────────────────────────────────

class SyncDataKeys {
  // payload field keys
  static const String event = 'event';
  static const String current = 'current';
  static const String total = 'total';
  static const String result = 'result';
  static const String lastSyncedAt = 'lastSyncedAt';
  static const String pendingCount = 'pendingCount';
  static const String intervalMinutes = 'intervalMinutes';
  static const String evtAuthFailed = 'auth_failed';
  // events → main isolate
  static const String evtProgress = 'progress';
  static const String evtDone = 'done';
  static const String evtNoInternet = 'no_internet';
  static const String evtError = 'error';

  // commands → task isolate
  static const String cmdTriggerNow = 'trigger_now';
  static const String cmdUpdateInterval = 'update_interval';
}

// ─── Top-level entry point ────────────────────────────────────────────────────

@pragma('vm:entry-point')
void startSyncCallback() {
  FlutterForegroundTask.setTaskHandler(OfflineSyncTaskHandler());
}

// ─── Task Handler ─────────────────────────────────────────────────────────────

class OfflineSyncTaskHandler extends TaskHandler {
  bool _dbInitialized = false;
  bool _isCycleRunning = false;
  String _armUrl = '';
  int _intervalMinutes = 0;
  Timer? _timer;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('#### FG_SYNC_TASK onStart CALLED ####');
    // WidgetsFlutterBinding.ensureInitialized();
    FlutterForegroundTask.sendDataToMain({
      SyncDataKeys.event: 'debug_ping',
      'msg': 'onStart fired in isolate',
    });
    await GetStorage.init();
    _armUrl = await FlutterForegroundTask.getData<String>(key: 'armUrl') ?? '';
    _intervalMinutes =
        await FlutterForegroundTask.getData<int>(key: 'intervalMinutes') ?? 0;
    if (_intervalMinutes == 0) {
      await LogService.writeLog(
          message: '$_tag interval=0 — sync disabled by config. Task exiting.');
      FlutterForegroundTask.stopService();
      return;
    }
    await LogService.writeLog(
        message:
            '$_tag onStart — interval: ${_intervalMinutes}min | armUrl: $_armUrl');

    await _ensureDbInitialized();
    await Future.delayed(const Duration(seconds: 3));
    await _runSyncCycle();

    _startTimer();
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _timer?.cancel();
    _timer = null;
    await LogService.writeLog(message: '$_tag onDestroy. isTimeout=$isTimeout');
  }

  @override
  void onReceiveData(Object data) {
    if (data is! Map) return;
    final String event = data[SyncDataKeys.event] as String? ?? '';

    switch (event) {
      case SyncDataKeys.cmdTriggerNow:
        log('$_tag Manual trigger received.', name: _tag);
        if (!_isCycleRunning) _runSyncCycle();
        break;

      case SyncDataKeys.cmdUpdateInterval:
        final int newInterval =
            data[SyncDataKeys.intervalMinutes] as int? ?? _intervalMinutes;
        if (newInterval != _intervalMinutes) {
          _intervalMinutes = newInterval;
          _startTimer(); // restart timer immediately with new interval
          LogService.writeLog(
              message:
                  '$_tag Interval updated to ${_intervalMinutes}min — timer restarted.');
        }
        break;
    }
  }

  // ── Timer ─────────────────────────────────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: _intervalMinutes), (_) async {
      if (!_isCycleRunning) {
        await LogService.writeLog(
            message: '$_tag Timer fired — running sync cycle.');
        await _runSyncCycle();
      } else {
        await LogService.writeLog(
            message: '$_tag Timer fired — cycle already running, skipping.');
      }
    });
    log('$_tag Timer started. Interval: ${_intervalMinutes}min.', name: _tag);
  }

  // ── Core sync cycle ────────────────────────────────────────────────────────

  Future<void> _runSyncCycle() async {
    _isCycleRunning = true;

    try {
      // await GetStorage.init();

      // 1. Internet check
      if (!await _checkInternet()) {
        await LogService.writeLog(
            message: '$_tag No internet — skipping cycle.');
        _updateNotification(
          title: '📡 Sync Waiting',
          text: 'No connection — will retry in ${_intervalMinutes}min',
        );
        FlutterForegroundTask.sendDataToMain(
            {SyncDataKeys.event: SyncDataKeys.evtNoInternet});
        return;
      }
      final int pending = await OfflineDbModule.getPendingCount();
      if (pending == 0) {
        await LogService.writeLog(
            message: '$_tag Queue empty — nothing to push this cycle.');
        _updateNotification(
          title: '🔵 Sync Service Active',
          text: 'No pending records — next check in ${_intervalMinutes}min',
        );
        return;
      }

      _updateNotification(
        title: '🔄 Syncing',
        text: 'Found $pending records — starting upload...',
      );
      await LogService.writeLog(
          message: '$_tag Starting push cycle. Pending: $pending');

      final String result = await OfflineDbModule.backgroundPushPendingQueue(
        armUrl: _armUrl,
        onProgress: (current, total) {
          _updateNotification(
            title: '🔄 Syncing',
            text: 'Uploading $current / $total records...',
          );
          FlutterForegroundTask.sendDataToMain({
            SyncDataKeys.event: SyncDataKeys.evtProgress,
            SyncDataKeys.current: current,
            SyncDataKeys.total: total,
          });
        },
      );

      await LogService.writeLog(message: '$_tag Push done. Result: $result');
      if (result == '__AUTH_FAILED__') {
        _updateNotification(
          title: '🔴 Session Expired',
          text: 'Please log in again to continue syncing.',
        );
        FlutterForegroundTask.sendDataToMain({
          SyncDataKeys.event: SyncDataKeys.evtAuthFailed,
        });
        return; // ← skip the evtDone block entirely
      }
      // 5. Post-push — NEVER stop service here.
      //    User may save new offline records before the next cycle.
      //    Just update notification + report to main isolate.
      //    Next timer cycle will re-check the queue.
      final int remaining = await OfflineDbModule.getPendingCount();
      final String? lastTs = await OfflineDbModule.getLastSyncedTimestamp();

      _updateNotification(
        title: remaining == 0 ? '✅ Sync Complete' : '⚠️ Sync Partial',
        text: remaining == 0
            ? 'Last sync: ${_formatTime(DateTime.parse(lastTs ?? DateTime.now().toIso8601String()).toLocal())} — next check in ${_intervalMinutes}min'
            : '$remaining records pending — retrying in ${_intervalMinutes}min',
      );

      FlutterForegroundTask.sendDataToMain({
        SyncDataKeys.event: SyncDataKeys.evtDone,
        SyncDataKeys.result: result,
        SyncDataKeys.pendingCount: remaining,
        SyncDataKeys.lastSyncedAt: lastTs ?? '',
      });
    } catch (e) {
      await LogService.writeLog(message: '$_tag Cycle FAILED: $e');
      _updateNotification(
        title: '🔴 Sync Error',
        text: 'Sync failed — retrying in ${_intervalMinutes}min',
      );
      FlutterForegroundTask.sendDataToMain({
        SyncDataKeys.event: SyncDataKeys.evtError,
        SyncDataKeys.result: e.toString(),
      });
    } finally {
      _isCycleRunning = false;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<void> _ensureDbInitialized() async {
    if (_dbInitialized) return;
    await OfflineDbModule.init();
    _dbInitialized = true;
    await LogService.writeLog(message: '$_tag DB initialized in isolate.');
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
    } catch (_) {
      return false;
    }
  }

  void _updateNotification({required String title, required String text}) {
    FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText: text,
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today $time';
    }
    return '${dt.day}/${dt.month} $time';
  }
}
