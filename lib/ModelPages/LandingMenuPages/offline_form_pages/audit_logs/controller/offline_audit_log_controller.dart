import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_constants.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';

class DateOption {
  final String value; // "yyyy-MM-dd"
  final String label; // "17 Feb 2026"
  const DateOption({required this.value, required this.label});
}

class AuditLogController extends GetxController {
  // ─── State ────────────────────────────────────────────────────────────────

  final RxList<Map<String, dynamic>> allLogs = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredLogs =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  // Section 1
  final RxString selectedFilter = "All".obs;
  final Rxn<String> selectedUsername = Rxn<String>();

  // Section 2
  final Rxn<String> selectedAction = Rxn<String>();
  final Rxn<String> selectedDate = Rxn<String>(); // "yyyy-MM-dd"

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    loadLogs();
  }

  // ─── Data ─────────────────────────────────────────────────────────────────

  Future<void> loadLogs() async {
    isLoading.value = true;
    final data = await OfflineDbModule.getAuditLogs();
    allLogs.assignAll(data);
    applyFilters();
    isLoading.value = false;
  }

  void applyFilters() {
    filteredLogs.assignAll(allLogs.where((log) {
      // --- status ---
      final bool isError = log[OfflineDBConstants.COL_IS_ERROR] == 1;
      bool matchesStatus = true;
      if (selectedFilter.value == "Success") matchesStatus = !isError;
      if (selectedFilter.value == "Error") matchesStatus = isError;

      // --- username ---
      final bool matchesUsername = selectedUsername.value == null ||
          log[OfflineDBConstants.COL_USERNAME] == selectedUsername.value;

      // --- action ---
      final bool matchesAction = selectedAction.value == null ||
          log[OfflineDBConstants.COL_ACTION] == selectedAction.value;

      // --- date ---
      bool matchesDate = true;
      if (selectedDate.value != null) {
        final raw = log[OfflineDBConstants.COL_CREATED_AT]?.toString() ?? "";
        try {
          final logDate = DateTime.parse(raw);
          final logDateStr = intl.DateFormat('yyyy-MM-dd').format(logDate);
          matchesDate = logDateStr == selectedDate.value;
        } catch (_) {
          matchesDate = false;
        }
      }

      return matchesStatus && matchesUsername && matchesAction && matchesDate;
    }).toList());
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    applyFilters();
  }

  void setUsername(String? username) {
    selectedUsername.value = username;
    applyFilters();
  }

  void setAction(String? action) {
    selectedAction.value = action;
    applyFilters();
  }

  void setDate(String? date) {
    selectedDate.value = date;
    applyFilters();
  }

  Future<void> confirmClear() async {
    final bool? ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Clear History?",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text("This will wipe all audit logs permanently."),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
            ),
            onPressed: () => Get.back(result: true),
            child:
                const Text("Clear All", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok == true) {
      await OfflineDbModule.clearAuditLogs();
      await loadLogs();
    }
  }

  // ─── Computed lists ───────────────────────────────────────────────────────

  List<String> get uniqueActions => allLogs
      .map((e) => e[OfflineDBConstants.COL_ACTION].toString())
      .toSet()
      .toList();

  List<String> get uniqueUsernames => allLogs
      .map((e) => e[OfflineDBConstants.COL_USERNAME].toString())
      .toSet()
      .toList();

  List<DateOption> get uniqueDates {
    final seen = <String>{};
    final result = <DateOption>[];
    for (final log in allLogs) {
      final raw = log[OfflineDBConstants.COL_CREATED_AT]?.toString() ?? "";
      try {
        final dt = DateTime.parse(raw);
        final key = intl.DateFormat('yyyy-MM-dd').format(dt);
        if (seen.add(key)) {
          result.add(DateOption(
            value: key,
            label: intl.DateFormat('dd MMM yyyy').format(dt),
          ));
        }
      } catch (_) {}
    }
    result.sort((a, b) => b.value.compareTo(a.value));
    return result;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String formatDate(String date) {
    try {
      final DateTime dt = DateTime.parse(date);
      return intl.DateFormat('EEE, dd MMM • hh:mm a').format(dt);
    } catch (_) {
      return date;
    }
  }

  String prettyJson(String input) {
    try {
      final decoded = jsonDecode(input);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(decoded);
    } catch (_) {
      return input;
    }
  }
}
