// import 'package:get/get.dart';
// import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_background_sync_service.dart';
// import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';

// class SyncSettingsController extends GetxController {
//   final _sync = OfflineBackgroundSyncService.instance;

//   // ── Forwarded observables (directly bound from service) ──────────────────
//   RxString get statusMessage => _sync.statusMessage;
//   RxBool get isSyncing => _sync.isSyncing;
//   Rxn<String> get lastSyncedAt => _sync.lastSyncedAt;
//   RxInt get intervalMinutes => _sync.intervalMinutes;

//   // ── Local state ──────────────────────────────────────────────────────────
//   final RxInt pendingCount = 0.obs;
//   final RxBool isLoadingCount = false.obs;
//   final RxString selectedLabel = ''.obs;

//   /// Dropdown options: label → minutes
//   static const Map<String, int> intervalOptions = {
//     '15 min': 15,
//     '30 min': 30,
//     '1 hour': 60,
//     '2 hours': 120,
//     '4 hours': 240,
//     '24 hours': 1440,
//   };

//   @override
//   void onInit() {
//     super.onInit();
//     _syncLabelFromInterval();
//     _fetchPendingCount();

//     // Keep label in sync if interval changes externally
//     ever(intervalMinutes, (_) => _syncLabelFromInterval());
//   }

//   // ── Public API ────────────────────────────────────────────────────────────

//   Future<void> onIntervalChanged(String label) async {
//     final int? minutes = intervalOptions[label];
//     if (minutes == null) return;
//     selectedLabel.value = label;
//     await _sync.setIntervalMinutes(minutes);
//   }

//   Future<void> triggerManualSync() async {
//     await _sync.triggerImmediateSync();
//     await _fetchPendingCount();
//   }

//   Future<void> refreshPendingCount() => _fetchPendingCount();

//   // ── Helpers ───────────────────────────────────────────────────────────────

//   void _syncLabelFromInterval() {
//     final int current = intervalMinutes.value;
//     // Find the closest matching label
//     String match = intervalOptions.entries
//         .reduce((a, b) =>
//             (a.value - current).abs() < (b.value - current).abs() ? a : b)
//         .key;
//     selectedLabel.value = match;
//   }

//   Future<void> _fetchPendingCount() async {
//     isLoadingCount.value = true;
//     try {
//       final int count = await OfflineDbModule.getPendingCount();
//       pendingCount.value = count;
//     } catch (_) {
//       pendingCount.value = 0;
//     } finally {
//       isLoadingCount.value = false;
//     }
//   }
// }
