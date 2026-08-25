import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/sync_progress_model.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';

class SyncProgressDialog extends StatelessWidget {
  final SyncProgressModel progressModel;
  final Function? reTry;
  final Function? onComplete;
  final bool showForcePush;
  final String onCompleteTitle;
  const SyncProgressDialog(
      {Key? key,
      required this.progressModel,
      this.reTry,
      this.onComplete,
      this.onCompleteTitle = '',
      this.showForcePush = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildMessage(),
              const SizedBox(height: 20),
              _buildProgress(),
              const SizedBox(height: 8),
              // _errorCards(),
              const SizedBox(height: 8),
              _buildStats(),
              _buildAuditTile(),
              _buildBottomAction(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- ICON ----------------

  Widget _buildIcon() {
    return Obx(() {
      final done = progressModel.isCompleted.value;
      final doneWithError = progressModel.isCompletedWithError.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(done),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: doneWithError
                ? const Color.fromARGB(255, 252, 220, 220)
                : done
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFF2563EB).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: doneWithError
              ? const Icon(Icons.error,
                  size: 28, color: Color.fromARGB(255, 163, 22, 22))
              : done
                  ? const Icon(Icons.check_rounded,
                      size: 28, color: Color(0xFF16A34A))
                  : Lottie.asset("assets/lotties/upload.json", repeat: true),
        ),
      );
    });
  }

  // ---------------- TITLE ----------------

  Widget _buildTitle() {
    return Obx(() => Text(
          progressModel.title.value,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ));
  }

  // ---------------- MESSAGE ----------------

  Widget _buildMessage() {
    return SizedBox(
      height: 36,
      child: Obx(() {
        final text = progressModel.message.value;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            text,
            key: ValueKey(text),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }),
    );
  }

  // ---------------- PROGRESS ----------------

  Widget _buildProgress() {
    return Obx(() {
      if (progressModel.isCompletedWithError.value) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.1),
              // border: Border.all(color: MyColors.AXMGray),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            progressModel.errMessage.value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        );
      }

      return !progressModel.isCompleted.value
          ? Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      LinearProgressIndicator(
                        stopIndicatorRadius: 30,
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 5,
                        backgroundColor: Color(0xFF2563EB).withAlpha(40),
                        color: Color(0xFF2563EB),
                      ),
                      LinearProgressIndicator(
                        stopIndicatorRadius: 30,
                        borderRadius: BorderRadius.circular(10),
                        value: progressModel.progressValue,
                        minHeight: 5,
                        backgroundColor: Colors.transparent,
                        valueColor:
                            const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${progressModel.processedItems.value} / ${progressModel.totalItems.value}",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            )
          : SizedBox.shrink();
    });
  }

  // ---------------- STATS ----------------

  Widget _buildStats() {
    return Obx(
      () => (progressModel.successCount != 0 || progressModel.failureCount != 0)
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem(progressModel.successCount, "Success",
                      const Color(0xFF16A34A)),
                  _statItem(progressModel.failureCount, "Failed",
                      const Color(0xFFDC2626)),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _statItem(RxInt count, String label, Color color) {
    return Obx(() => Row(
          children: [
            Text(
              count.value.toString(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ));
  }

  // ---------------- BUTTON ----------------

  Widget _buildBottomAction() {
    return Obx(() {
      if (!progressModel.isCompleted.value) return const SizedBox.shrink();
      if (progressModel.isAuditPushing.value) return const SizedBox.shrink();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // (progressModel.failureCount.value > 0 && showForcePush)
          //     ? Padding(
          //         padding: const EdgeInsets.only(top: 20),
          //         child: SizedBox(
          //           width: double.infinity,
          //           child: ElevatedButton(
          //             onPressed: () {
          //               OfflineFormController offlineFormController =
          //                   Get.find();

          //               offlineFormController.onForcePushClicked(progressModel);
          //             },
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: MyColors.baseRed,
          //               elevation: 0,
          //               padding: const EdgeInsets.symmetric(vertical: 14),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(12),
          //               ),
          //             ),
          //             child: Text(
          //               "Force push ${progressModel.failureCount.value} records",
          //               style: GoogleFonts.poppins(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : SizedBox.shrink(),

          (onComplete != null)
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onComplete!();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        onCompleteTitle,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),

          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                spacing: (reTry != null && progressModel.failureCount.value > 0)
                    ? 15
                    : 0,
                children: [
                  (reTry != null && progressModel.failureCount.value > 0)
                      ? Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              reTry!();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Retry",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (progressModel.isSessionError.value) {
                          LandingPageController lc = Get.find();
                          lc.showSignOutDialog_sessionExpired();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.AXMDark,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Close",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //
          SizedBox(
            height: 15,
          ),
          progressModel.showSyncAuditLogsButton.value
              ? Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          progressModel.showSyncAuditLogsButton.value = false;
                          // Get.back();
                          // if (progressModel.isSessionError.value) {
                          //   LandingPageController lc = Get.find();
                          //   lc.showSignOutDialog_sessionExpired();
                          // }
                          await OfflineDbModule.pushAuditLogsToServer(
                              isInternetAvailable: true,
                              progress: progressModel);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.blue1,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Upload Audit Logs",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink()
          //     : SizedBox.shrink(),
        ],
      );
    });
  }

  Widget _errorCards() {
    return Obx(() {
      if (progressModel.isCompletedWithError.value) return SizedBox.shrink();
      if (progressModel.syncErrors.isEmpty) return SizedBox.shrink();

      // return SizedBox(
      //   height: 50,
      //   child: Flexible(
      //       child: Text(
      //     progressModel.syncErrors.last.errorText,
      //     maxLines: 3,
      //     overflow: TextOverflow.ellipsis,
      //   )),
      // );

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade100, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.info_outline_rounded,
                color: Colors.red.shade300,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                progressModel.syncErrors.last.errorText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade400,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Widget _buildLoginButton() {
  //   return Obx(() {
  //     if (!progressModel.isCompletedWithError.value) return SizedBox.shrink();
  //     if(progressModel.isSessionError.value)return SizedBox.shrink();
  //   });
  // }

  Widget _buildAuditTile() {
    return Obx(() {
      final pushing = progressModel.isAuditPushing.value;
      final done = progressModel.isAuditDone.value;

      // Only render once the main queue is complete and audit phase began
      if (!progressModel.isCompleted.value) return const SizedBox.shrink();
      if (!pushing && !done) return const SizedBox.shrink();

      final int total = progressModel.auditTotal.value;
      final int synced = progressModel.auditSynced.value;
      final int failed = progressModel.auditFailed.value;
      final String msg = progressModel.auditMessage.value;

      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ───────────────────────────────────────────
              Row(
                children: [
                  // spinning or check icon
                  done
                      ? const Icon(Icons.cloud_done_rounded,
                          size: 16, color: Color(0xFF16A34A))
                      : Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF2563EB).withValues(alpha: 0.2)),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2563EB),
                          ),
                          // child: Lottie.asset(
                          //   "assets/lotties/upload.json",
                          //   repeat: true,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                  const SizedBox(width: 8),
                  Text(
                    'Audit logs',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (total > 0)
                    Text(
                      '${synced + failed} / $total',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),

              // ── Progress bar (only while pushing) ───────────────────
              if (pushing && total > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressModel.auditProgressValue,
                    minHeight: 4,
                    backgroundColor:
                        const Color(0xFF2563EB).withValues(alpha: 0.12),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                  ),
                ),
              ],

              // ── Status message ───────────────────────────────────────
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      msg,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  if (done && failed > 0)
                    Text(
                      '$failed failed',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
