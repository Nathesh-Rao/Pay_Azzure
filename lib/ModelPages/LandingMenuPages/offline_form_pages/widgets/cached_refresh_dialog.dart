import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Controllers/MenuDashboaardController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/controller/offline_form_controller.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/queue_resolve_result_model.dart';

// enum CachedRefreshResult {
//   cancelled,
//   refreshed,
//   sessionInvalid,
// }

// class CachedRefreshDialogWidget extends GetView<OfflineFormController> {
//   const CachedRefreshDialogWidget({
//     super.key,
//     required this.refreshQueueRows,
//   });

//   final List<Map<String, dynamic>> refreshQueueRows;

//   @override
//   Widget build(BuildContext context) {
//     // WidgetsBinding.instance.addPostFrameCallback((_) => onSpawn);
//     return Dialog(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 24),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           /// Header
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 15, 16, 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     "Refresh Pending Queues",
//                     style: GoogleFonts.inter(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   borderRadius: BorderRadius.circular(30),
//                   onTap: () {
//                     Get.back(
//                       result: CachedRefreshResult.cancelled,
//                     );
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(4),
//                     child: Icon(
//                       Icons.close_rounded,
//                       size: 20,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),

//           Divider(height: 1),

//           Padding(
//             padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
//             child: Column(
//               children: [
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxHeight: 250,
//                   ),
//                   child: ListView.separated(
//                     physics: BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: refreshQueueRows.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 8),
//                     itemBuilder: (context, index) {
//                       final queueId = refreshQueueRows[index]["queue_id"];

//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(
//                             color: const Color(0xffE5E7EB),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xffEEF5FF),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.query_builder,
//                                 size: 20,
//                                 color: Color(0xff2563EB),
//                               ),
//                             ),
//                             const SizedBox(width: 14),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     "Queue ID",
//                                     style: GoogleFonts.inter(
//                                       fontSize: 11,
//                                       color: Colors.grey.shade600,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     queueId.toString(),
//                                     style: GoogleFonts.inter(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xffEEF5FF),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 "${index + 1}",
//                                 style: GoogleFonts.inter(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w700,
//                                   color: const Color(0xff2563EB),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Obx(
//                   () => FlipInX(
//                     key: ValueKey(controller.isPendingQuesRefreshing.value),
//                     child: controller.isPendingQuesRefreshing.value
//                         ? _infoBox(
//                             icon: Icons.security,
//                             message: "We are refreshing your pending queues\n"
//                                 "Please hold on",
//                             color: Color(0xffF59E0B))
//                         : _infoBox(
//                             icon: Icons.security,
//                             message:
//                                 "We found ${refreshQueueRows.length} pending queues from previous push, "
//                                 "Please continue to refresh the status",
//                             color: Color(0xffF59E0B)),
//                   ),
//                 ),
//                 // const SizedBox(height: 22),

//                 Obx(() => FlipInX(
//                       key: ValueKey(controller.isPendingQuesRefreshing.value),
//                       child: controller.isPendingQuesRefreshing.value
//                           ? SizedBox(
//                               height: 48,
//                               child: Center(
//                                   child: LinearProgressIndicator(
//                                 borderRadius: BorderRadius.circular(100),
//                                 color: Color(0xff212529),
//                               )),
//                             )
//                           : Container(
//                               margin: EdgeInsets.only(top: 22),
//                               width: double.infinity,
//                               height: 48,
//                               child: ElevatedButton.icon(
//                                 onPressed: () async {
//                                   controller.isPendingQuesRefreshing.value =
//                                       true;

//                                   try {
//                                     await OfflineDbModule
//                                         .resolvePendingCachedSaveQueueBatches(
//                                       controller: controller,
//                                     );

//                                     Get.back(
//                                       result: CachedRefreshResult.refreshed,
//                                     );
//                                   } catch (_) {
//                                   } finally {
//                                     controller.isPendingQuesRefreshing.value =
//                                         false;

//                                     Get.back(
//                                       result: CachedRefreshResult.refreshed,
//                                     );
//                                   }
//                                 },
//                                 icon: const Icon(
//                                   Icons.sync_rounded,
//                                   size: 18,
//                                 ),
//                                 label: Text(
//                                   "Refresh and Continue",
//                                   style: GoogleFonts.inter(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xff212529),
//                                   foregroundColor: Colors.white,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     )),
//                 // const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Column(
//       children: [
//         Container(
//           width: 56,
//           height: 56,
//           decoration: BoxDecoration(
//             color: const Color(0xffEEF5FF),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: const Icon(
//             Icons.sync_rounded,
//             size: 28,
//             color: Color(0xff2563EB),
//           ),
//         ),
//         const SizedBox(height: 18),
//         Text(
//           "Refresh Pending Queues?",
//           textAlign: TextAlign.center,
//           style: GoogleFonts.inter(
//             fontSize: 21,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           "This will refresh all pending queues from the server.\n"
//           "Your offline data will remain safe.",
//           textAlign: TextAlign.center,
//           style: GoogleFonts.inter(
//             fontSize: 13,
//             height: 1.55,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _infoBox(
//       {required IconData icon, required String message, required Color color}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(
//         horizontal: 14,
//         vertical: 12,
//       ),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withValues(alpha: 0.5),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             icon,
//             color: color,
//             size: 18,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: GoogleFonts.poppins(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade800,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

enum CachedRefreshResult {
  cancelled,
  refreshed,
  sessionInvalid,
}

class CachedRefreshDialogWidget extends GetView<OfflineFormController> {
  const CachedRefreshDialogWidget({
    super.key,
    required this.refreshQueueRows,
  });

  final List<Map<String, dynamic>> refreshQueueRows;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isPendingQueResolveComplete.value = false;
      controller.pendingQueResolveResults.clear();
    });
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Obx(() {
        final bool isRefreshing = controller.isPendingQuesRefreshing.value;
        final bool isDone = controller.isPendingQueResolveComplete.value;
        final List<QueueResolveResultModel> results =
            controller.pendingQueResolveResults;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isDone ? "Refresh Complete" : "Refresh Pending Queues",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (!isRefreshing)
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => Get.back(
                        result: isDone
                            ? CachedRefreshResult.refreshed
                            : CachedRefreshResult.cancelled,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close_rounded, size: 20),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              child: Column(
                children: [
                  // ── Queue list / Results list ────────────────────
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 260),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          isDone ? results.length : refreshQueueRows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (isDone) {
                          return _buildResultRow(results[index], index);
                        }
                        final queueId = refreshQueueRows[index]["queue_id"];
                        return _buildQueueRow(queueId.toString(), index);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Info / Summary box ───────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isDone
                        ? _buildSummaryBox(results)
                        : isRefreshing
                            ? _infoBox(
                                icon: Icons.sync_rounded,
                                message:
                                    "Refreshing your pending queues...\nPlease hold on.",
                                color: const Color(0xff2563EB),
                              )
                            : _infoBox(
                                icon: Icons.info_outline_rounded,
                                message:
                                    "Found ${refreshQueueRows.length} pending queue(s) from "
                                    "previous push. Tap below to refresh their status.",
                                color: const Color(0xffF59E0B),
                              ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  if (isRefreshing || isDone)
                    Obx(
                      () => _infoBox(
                        icon: Icons.info_outline_rounded,
                        message: controller.cachedSaveUpdateMessage.value,
                        color: const Color(0xffF59E0B),
                      ),
                    ),

                  const SizedBox(height: 18),

                  // ── Action button ────────────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isRefreshing
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            height: 48,
                            child: Center(
                              child: LinearProgressIndicator(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                color: Color(0xff212529),
                              ),
                            ),
                          )
                        : isDone
                            ? _buildCloseButton()
                            : _buildRefreshButton(),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Queue row (before refresh) ────────────────────────────────────────────
  Widget _buildQueueRow(String queueId, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffEEF5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.query_builder,
              size: 20,
              color: Color(0xff2563EB),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Queue ID",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  queueId,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xffEEF5FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${index + 1}",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xff2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Result row (after refresh) ────────────────────────────────────────────
  Widget _buildResultRow(QueueResolveResultModel result, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: result.statusBgColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: result.statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: result.statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              result.statusIcon,
              size: 20,
              color: result.statusColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  result.queueId,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                if (!result.isNotFound)
                  Text(
                    "${result.successCount} success  •  ${result.failedCount} failed",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (result.isNotFound)
                  Text(
                    result.statusMessage.isEmpty
                        ? "No server response found"
                        : result.statusMessage,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: result.statusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              result.statusLabel,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: result.statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary box (after refresh) ───────────────────────────────────────────
  Widget _buildSummaryBox(List<QueueResolveResultModel> results) {
    final int successCount = results.where((r) => r.isSuccess).length;
    final int partialCount = results.where((r) => r.isPartial).length;
    final int errorCount = results.where((r) => r.isError).length;
    final int notFoundCount = results.where((r) => r.isNotFound).length;

    final StringBuffer summary = StringBuffer();
    if (successCount > 0) summary.write("$successCount success");
    if (partialCount > 0) {
      if (summary.isNotEmpty) summary.write("  •  ");
      summary.write("$partialCount partial");
    }
    if (errorCount > 0) {
      if (summary.isNotEmpty) summary.write("  •  ");
      summary.write("$errorCount error");
    }
    if (notFoundCount > 0) {
      if (summary.isNotEmpty) summary.write("  •  ");
      summary.write("$notFoundCount not found on server");
    }

    final bool allGood = errorCount == 0 && partialCount == 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _infoBox(
          icon: allGood
              ? Icons.check_circle_outline_rounded
              : Icons.warning_amber_rounded,
          message:
              summary.isEmpty ? "All queues processed." : summary.toString(),
          color: allGood ? const Color(0xff16A34A) : const Color(0xffF59E0B),
        ),
        // _infoBox(
        //   icon: allGood
        //       ? Icons.check_circle_outline_rounded
        //       : Icons.warning_amber_rounded,
        //   message:
        //       summary.isEmpty ? "All queues processed." : summary.toString(),
        //   color: allGood ? const Color(0xff16A34A) : const Color(0xffF59E0B),
        // ),
      ],
    );
  }

  // ── Buttons ───────────────────────────────────────────────────────────────
  Widget _buildRefreshButton() {
    return SizedBox(
      key: const ValueKey('refresh'),
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () async {
          controller.isPendingQuesRefreshing.value = true;
          controller.isPendingQueResolveComplete.value = false;
          controller.pendingQueResolveResults.clear();

          try {
            final List<QueueResolveResultModel> results =
                await OfflineDbModule.resolvePendingCachedSaveQueueBatches(
                    controller: controller);

            controller.pendingQueResolveResults.assignAll(results);
            controller.isPendingQueResolveComplete.value = true;
          } catch (e) {
            controller.isPendingQueResolveComplete.value = true;
          } finally {
            controller.isPendingQuesRefreshing.value = false;
          }
        },
        icon: const Icon(Icons.sync_rounded, size: 18),
        label: Text(
          "Refresh and Continue",
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff212529),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      key: const ValueKey('close'),
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => Get.back(result: CachedRefreshResult.refreshed),
        icon: const Icon(Icons.check_rounded, size: 18),
        label: Text(
          "Done",
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff16A34A),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ── Info box ──────────────────────────────────────────────────────────────
  Widget _infoBox({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
