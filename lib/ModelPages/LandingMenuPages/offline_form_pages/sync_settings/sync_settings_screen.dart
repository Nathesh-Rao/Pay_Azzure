// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'sync_settings_controller.dart';

// class SyncSettingsScreen extends StatelessWidget {
//   const SyncSettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SyncSettingsController());
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: const Text('Background Sync'),
//         centerTitle: false,
//         actions: [
//           Obx(() => controller.isSyncing.value
//               ? const Padding(
//                   padding: EdgeInsets.only(right: 16),
//                   child: Center(
//                     child: SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   ),
//                 )
//               : IconButton(
//                   icon: const Icon(Icons.refresh),
//                   tooltip: 'Refresh count',
//                   onPressed: controller.refreshPendingCount,
//                 )),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         children: [
//           // ── Status card ───────────────────────────────────────────────────
//           _SectionCard(
//             children: [
//               _SyncStatusTile(controller: controller),
//               const _Divider(),
//               _PendingCountTile(controller: controller),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // ── Configuration ─────────────────────────────────────────────────
//           _SectionCard(
//             children: [
//               _IntervalDropdownTile(controller: controller),
//             ],
//           ),

//           const SizedBox(height: 24),

//           // ── Manual sync button ────────────────────────────────────────────
//           Obx(() => _SyncNowButton(
//                 isSyncing: controller.isSyncing.value,
//                 onPressed: controller.triggerManualSync,
//               )),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Status tile
// // ─────────────────────────────────────────────────────────────────────────────

// class _SyncStatusTile extends StatelessWidget {
//   const _SyncStatusTile({required this.controller});
//   final SyncSettingsController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final syncing = controller.isSyncing.value;
//       final msg = controller.statusMessage.value;
//       final lastSync = controller.lastSyncedAt.value;

//       return ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         leading: _StatusDot(isSyncing: syncing),
//         title: const Text('Sync Status',
//             style: TextStyle(fontWeight: FontWeight.w600)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 2),
//             Text(msg, style: const TextStyle(fontSize: 13)),
//             if (lastSync != null && lastSync.isNotEmpty) ...[
//               const SizedBox(height: 2),
//               Text(
//                 'Last sync: ${_formatTimestamp(lastSync)}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Theme.of(context).colorScheme.outline,
//                 ),
//               ),
//             ],
//           ],
//         ),
//         trailing: syncing
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : Icon(Icons.check_circle_outline,
//                 color: Theme.of(context).colorScheme.primary, size: 20),
//       );
//     });
//   }

//   String _formatTimestamp(String ts) {
//     try {
//       final dt = DateTime.parse(ts).toLocal();
//       final now = DateTime.now();
//       final time =
//           '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
//       if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
//         return 'Today $time';
//       }
//       final yesterday = now.subtract(const Duration(days: 1));
//       if (dt.year == yesterday.year &&
//           dt.month == yesterday.month &&
//           dt.day == yesterday.day) {
//         return 'Yesterday $time';
//       }
//       return '${dt.day}/${dt.month}/${dt.year} $time';
//     } catch (_) {
//       return ts;
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Pending count tile
// // ─────────────────────────────────────────────────────────────────────────────

// class _PendingCountTile extends StatelessWidget {
//   const _PendingCountTile({required this.controller});
//   final SyncSettingsController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final count = controller.pendingCount.value;
//       final loading = controller.isLoadingCount.value;

//       return ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         leading: Icon(
//           Icons.upload_outlined,
//           color: count > 0
//               ? Theme.of(context).colorScheme.error
//               : Theme.of(context).colorScheme.primary,
//         ),
//         title: const Text('Pending Records',
//             style: TextStyle(fontWeight: FontWeight.w600)),
//         trailing: loading
//             ? const SizedBox(
//                 width: 16,
//                 height: 16,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: count > 0
//                       ? Theme.of(context).colorScheme.errorContainer
//                       : Theme.of(context).colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '$count',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: count > 0
//                         ? Theme.of(context).colorScheme.onErrorContainer
//                         : Theme.of(context).colorScheme.onPrimaryContainer,
//                   ),
//                 ),
//               ),
//       );
//     });
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Interval dropdown tile
// // ─────────────────────────────────────────────────────────────────────────────

// class _IntervalDropdownTile extends StatelessWidget {
//   const _IntervalDropdownTile({required this.controller});
//   final SyncSettingsController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => ListTile(
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//           leading: const Icon(Icons.timer_outlined),
//           title: const Text('Sync Interval',
//               style: TextStyle(fontWeight: FontWeight.w600)),
//           subtitle: const Text('How often records are pushed in background',
//               style: TextStyle(fontSize: 12)),
//           trailing: DropdownButton<String>(
//             value: controller.selectedLabel.value.isEmpty
//                 ? null
//                 : controller.selectedLabel.value,
//             underline: const SizedBox.shrink(),
//             borderRadius: BorderRadius.circular(12),
//             items: SyncSettingsController.intervalOptions.keys
//                 .map((label) => DropdownMenuItem(
//                       value: label,
//                       child: Text(label,
//                           style: const TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w500)),
//                     ))
//                 .toList(),
//             onChanged: (label) {
//               if (label != null) controller.onIntervalChanged(label);
//             },
//           ),
//         ));
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Sync now button
// // ─────────────────────────────────────────────────────────────────────────────

// class _SyncNowButton extends StatelessWidget {
//   const _SyncNowButton({required this.isSyncing, required this.onPressed});
//   final bool isSyncing;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: FilledButton.icon(
//         onPressed: isSyncing ? null : onPressed,
//         icon: isSyncing
//             ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white),
//               )
//             : const Icon(Icons.sync),
//         label: Text(isSyncing ? 'Syncing…' : 'Sync Now'),
//         style: FilledButton.styleFrom(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Reusable helpers
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionCard extends StatelessWidget {
//   const _SectionCard({required this.children});
//   final List<Widget> children;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(
//           color: Theme.of(context).colorScheme.outlineVariant,
//         ),
//       ),
//       child: Column(
//         children: children,
//       ),
//     );
//   }
// }

// class _Divider extends StatelessWidget {
//   const _Divider();

//   @override
//   Widget build(BuildContext context) {
//     return Divider(
//       height: 1,
//       indent: 16,
//       endIndent: 16,
//       color: Theme.of(context).colorScheme.outlineVariant,
//     );
//   }
// }

// class _StatusDot extends StatelessWidget {
//   const _StatusDot({required this.isSyncing});
//   final bool isSyncing;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 400),
//       width: 12,
//       height: 12,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isSyncing
//             ? Theme.of(context).colorScheme.tertiary
//             : Theme.of(context).colorScheme.primary,
//         boxShadow: [
//           BoxShadow(
//             color: (isSyncing
//                     ? Theme.of(context).colorScheme.tertiary
//                     : Theme.of(context).colorScheme.primary)
//                 .withOpacity(0.4),
//             blurRadius: 6,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
