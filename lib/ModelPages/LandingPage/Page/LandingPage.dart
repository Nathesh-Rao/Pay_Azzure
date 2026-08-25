import 'dart:async';

import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/InApplicationWebView/page/InApplicationWebView.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/AttendanceController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/controller/offline_form_controller.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetBottomNavigation.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetDrawer.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetLandingAppBarUpdated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../InApplicationWebView/controller/webview_controller.dart';
import '../../LandingMenuPages/MenuActiveListPage/Controllers/UpdatedActiveTaskListController/ActiveTaskListController.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final LandingPageController landingPageController = Get.find();
  final MenuHomePageController menuHomePageController =
      Get.put(MenuHomePageController());
  final WebViewController webViewController = Get.find();
  final OfflineFormController offlineFormController = Get.find();
  final ActiveTaskListController _c = Get.put(ActiveTaskListController());
  final PayAndLeaveController _p = Get.put(PayAndLeaveController());
  final AttendanceController _a = Get.put(AttendanceController());
  Timer? _holdTimer;
  Widget _getDrawerWidget(BuildContext context) {
    if (landingPageController.bottomIndex.value == 5) {
      return _buildDrawer(context);
    } else {
      return WidgetDrawer();
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final bg = const Color(0xFFF8F7F4);
    return Drawer(
      backgroundColor: bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            GestureDetector(
              onTapDown: (_) {
                _holdTimer = Timer(const Duration(seconds: 3), () {
                  HapticFeedback.mediumImpact();
                  offlineFormController.actionClearAll();
                });
              },
              onTapUp: (_) {
                if (_holdTimer?.isActive ?? false) {
                  _holdTimer?.cancel();
                }
              },
              onTapCancel: () {
                if (_holdTimer?.isActive ?? false) {
                  _holdTimer?.cancel();
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Text(
                  "Offline Data Manager",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColors.AXMDark,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                children: [
                  _sectionHeader("Sync"),
                  _simpleRow(
                    icon: Icons.sync,
                    color: MyColors.blue2,
                    title: "Sync All",
                    subtitle: "Push pending & refetch everything",
                    onTap: offlineFormController.actionSyncAll,
                  ),
                  _simpleRow(
                    icon: Icons.description,
                    color: Colors.indigo,
                    title: "Refetch Forms",
                    subtitle: "Reload offline forms",
                    onTap: offlineFormController.actionRefetchForms,
                  ),
                  _simpleRow(
                    icon: Icons.storage,
                    color: Colors.teal,
                    title: "Refetch Datasources",
                    subtitle: "Reload lookup data",
                    onTap: offlineFormController.actionRefetchDatasources,
                  ),
                  _simpleRow(
                    icon: Icons.unarchive_rounded,
                    color: Colors.teal,
                    title: "Export Database",
                    subtitle: "Backup offline DB for debugging",
                    onTap: offlineFormController.actionExportDatabase,
                  ),
                  _simpleRow(
                    icon: Icons.archive_rounded,
                    color: Colors.deepOrange,
                    title: "Import Database",
                    subtitle: "Restore or overwrite local DB file",
                    onTap: offlineFormController.actionImportDatabase,
                  ),
                  // _simpleRow(
                  //   icon: Icons.restart_alt_rounded,
                  //   color: Colors.brown,
                  //   title: "Sync Settings",
                  //   subtitle: "configure your background sync",
                  //   onTap: () {
                  //     // Get.to(() => SyncSettingsScreen());
                  //   },
                  // ),
                  const Divider(),
                  _sectionHeader("Queue"),
                  // Obx(() => _simpleRow(
                  //       icon: Icons.upload_file,
                  //       color: Colors.deepOrange,
                  //       title: "Push Pending Uploads",
                  //       subtitle: "Upload queued data to server",
                  //       onTap: offlineFormController.actionPushPending,
                  //       badge: offlineFormController.pendingCount.value != 0
                  //           ? offlineFormController.pendingCount.value
                  //               .toString()
                  //           : null,
                  //     )),

                  Obx(() => _simpleRow(
                        icon: Icons.upload,
                        color: Colors.green,
                        title: "Push Pending records",
                        subtitle: "Upload pending records to server",
                        onTap:
                            offlineFormController.actionPushPendingByCachedSave,
                        badge: offlineFormController.pendingCount.value != 0
                            ? offlineFormController.pendingCount.value
                                .toString()
                            : null,
                      )),
                  Obx(() => _simpleRow(
                        icon: Icons.refresh_sharp,
                        color: Colors.deepOrange,
                        title: "Queue status",
                        subtitle: "Refresh pending queues from server",
                        onTap: offlineFormController.actionRefreshQueues,
                        badge:
                            offlineFormController.pendingQueuesCount.value != 0
                                ? offlineFormController.pendingQueuesCount.value
                                    .toString()
                                : null,
                      )),

                  Obx(
                    () => globalVariableController.USER_ROLE.value == 'default'
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  _sectionHeader("Admin Panel"),
                                ],
                              ),
                              // _simpleRow(
                              //   icon: Icons.delete_outline,
                              //   color: Colors.redAccent,
                              //   title: "Clear Forms Cache",
                              //   subtitle: "Remove offline forms",
                              //   onTap: offlineFormController.actionClearForms,
                              // ),
                              // _simpleRow(
                              //   icon: Icons.delete_sweep,
                              //   color: Colors.red,
                              //   title: "Clear Datasources Cache",
                              //   subtitle: "Remove cached datasources",
                              //   onTap: offlineFormController
                              //       .actionClearDatasources,
                              // ),
                              _simpleRow(
                                icon: Icons.clear_all,
                                color: Colors.brown,
                                title: "Clear Pending Queue",
                                subtitle: "Delete all pending submissions",
                                onTap: offlineFormController.actionClearPending,
                              ),
                              // _simpleRow(
                              //   icon: Icons.history_edu_rounded,
                              //   color: Colors.blueGrey,
                              //   title: "View Audit Logs",
                              //   subtitle:
                              //       "Track user actions and system events",
                              //   onTap: () => Get.to(() => AuditLogPage()),
                              // ),

                              const Divider(),
                              Row(
                                children: [
                                  _sectionHeader("Danger zone"),
                                ],
                              ),
                              _simpleRow(
                                icon: Icons.warning,
                                color: Colors.red.shade900,
                                title: "Clear ALL Offline Data",
                                subtitle: "Deletes everything except user",
                                onTap: offlineFormController.actionClearAll,
                                isDanger: true,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    // : Center(
                    //     child:
                    //         Text(globalVariableController.USER_ROLE.value)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: MyColors.AXMGray,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _simpleRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
    bool isDisabled = false,
    String? badge,
  }) {
    final Color iconColor = isDisabled ? Colors.grey.shade400 : color;

    final Color titleColor = isDisabled
        ? Colors.grey.shade400
        : (isDanger ? Colors.red : MyColors.AXMDark);

    final Color subTitleColor =
        isDisabled ? Colors.grey.shade300 : MyColors.AXMGray;

    return Badge(
      isLabelVisible: badge != null,
      offset: Offset(-50, 0),
      backgroundColor: MyColors.maroon,
      label: Text(badge.toString()),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 10),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        enabled: !isDisabled,
        leading: Icon(icon, size: 20, color: iconColor),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: titleColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: subTitleColor,
          ),
        ),
        trailing: isDisabled ? null : const Icon(Icons.chevron_right, size: 18),
        onTap: isDisabled ? null : onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return; // already popped, no action needed

          if (webViewController.currentIndex.value == 1) {
            // If WebView is visible, go back to Home instead of closing app
            webViewController.currentIndex.value = 0;
          } else {
            // If already on Home, allow normal app close
            final shouldPop = await landingPageController.onWillPop();
            /*if (shouldPop) {
                  // Completely close the app
                  SystemNavigator.pop();
                }*/
          }
        },
        child: IndexedStack(
          index: webViewController.currentIndex.value,
          children: [
            Scaffold(
              appBar: WidgetLandingAppBarUpdated(),
              // appBar: WidgetLandingAppBar(),
              drawer: _getDrawerWidget(context),
              bottomNavigationBar: AppBottomNavigation(),
              body: /*WillPopScope(
                onWillPop: landingPageController.onWillPop,
                child:*/
                  Obx(
                () => Stack(
                  children: [
                    landingPageController.getPage(),
                  ],
                ),
              ),
              /* menuHomePageController.switchPage.value == true
                        ? InApplicationWebViewer(menuHomePageController.webUrl)
                        : landingPageController.getPage(),
                    ),*/
            ),
            //  ),
            Obx(() =>
                InApplicationWebViewer(webViewController.currentUrl.value)),
          ],
        ),
      ),
    );
  }
}
