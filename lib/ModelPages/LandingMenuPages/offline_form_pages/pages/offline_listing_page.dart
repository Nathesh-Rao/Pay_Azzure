import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/auto_sync/offline_background_sync_service.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/controller/offline_form_controller.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/form_action_tile.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/widgets/report_action_tile.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_page_model.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OfflineListingPage extends GetView<OfflineFormController> {
  const OfflineListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(OfflineStaticFormController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllPages();
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF8F7F4),
        foregroundColor: MyColors.AXMDark,
        automaticallyImplyLeading: false,
        title: Text("Offline Forms"),
      ),
//       floatingActionButton: FloatingActionButton(onPressed: () async{
//           final String sessionId =
//         await AppStorage().retrieveValue(AppStorage.SESSIONID) ?? "";
//  await  OfflineDbModule.tempCallActivemessageData(queueId: "1783573212667",sessionId: sessionId);
//       }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Visibility(
              visible: OfflineBackgroundSyncService.instance.isSyncing.value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: MyColors.baseBlue.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.baseBlue.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                      )
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: MyColors.baseBlue.withValues(alpha: 0.08),
                      ),
                      child: Row(
                        children: [
                          // Leading Icon
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: MyColors.baseBlue.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.cloud_sync_rounded,
                              color: MyColors.baseBlue,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 12),

                          // Text Hierarchy
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Background sync is active.",
                                  style: GoogleFonts.poppins(
                                    color: MyColors.baseBlue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  OfflineBackgroundSyncService
                                      .instance.statusMessage.value,
                                  style: GoogleFonts.poppins(
                                    color: MyColors.baseBlue
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Trailing Spinner
                          SizedBox(width: 12),
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: MyColors.baseBlue,
                              strokeCap: StrokeCap.round,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _datSourcefetchWidget(),
        ],
      ),
      backgroundColor: Color(0xFFF8F7F4),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Obx(
              () => GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                itemCount: controller.allPages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                // itemBuilder: (context, index) => _pageTile(
                //   controller.allPages[index],
                //   index,
                // ),
                itemBuilder: (_, index) {
                  return _getGridTile(
                    index,
                  );

                  // if (page.transId != "inward_entry") {
                  //   return OfflinePageCardCupertino(
                  //     page: page,
                  //     index: index,
                  //     onTap: () => controller.loadPage(page),
                  //     useColoredTile: true,
                  //   );

                  //   // return CircleAvatar();
                  // } else {
                  //   final rawpage = controller.allRawPages[index];
                  //   return SquareActionTile(
                  //     icon: Icons.pages,
                  //     title: rawpage["caption"],
                  //     onTap: () async {
                  //       await inwardEntryDynamicController.prepareForm(rawpage);
                  //       Get.to(
                  //         () => InwardEntryDynamicPageV1(schema: rawpage),
                  //         transition: Transition.rightToLeft,
                  //       );
                  //     },
                  //   );
                  // }
                },
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:
      //   child: Icon(Icons.pages),
      // ),
    );
  }

  Widget _datSourcefetchWidget() {
    return Obx(() {
      if (!LandingPageController.to.isDataSourcefetchingOnStart.value)
        return SizedBox.shrink();
      final int completed =
          LandingPageController.to.completedDsCountOnStart.value;
      final int total = LandingPageController.to.totalDsCountOnStart.value;
      final double progress = total > 0 ? (completed / total) : 0.0;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: MyColors.baseBlue.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.baseBlue.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 0,
              )
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: MyColors.baseBlue.withValues(alpha: 0.08),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 42,
                    width: 42,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MyColors.baseBlue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Spin(
                            infinite: true,
                            child: Icon(
                              Icons.sync_rounded,
                              color: MyColors.baseBlue,
                              size: 16,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value:
                                progress, // Dynamically updates based on count
                            strokeWidth: 2.5,
                            backgroundColor:
                                MyColors.baseBlue.withValues(alpha: 0.15),
                            color: MyColors.baseBlue,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width:
                          16), // A bit more spacing to accommodate the new circle size

                  // Text Hierarchy
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Syncing DataSources",
                          style: GoogleFonts.poppins(
                            color: MyColors.baseBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Syncing $completed of $total",
                          style: GoogleFonts.poppins(
                            color: MyColors.baseBlue.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _getGridTile(
    int index,
  ) {
    final page = controller.allPages[index];
    final rawPage = controller.allRawPages[index];

    if (page.pageType == "form") {
      // if (page.transId == "inward_entry") {

      return FormActionTile(
        icon: Icons.pages,
        title: rawPage["caption"],
        onTap: () async {
          await controller.prepareForm(rawPage).then((_) {
            Get.toNamed(Routes.OfflineFormPage);
          });
          // Get.to(
          //   () => InwardEntryDynamicPageV1(schema: rawPage),
          //   transition: Transition.rightToLeft,
          // );
        },
      );
      return FormActionTile(
        icon: Icons.pages,
        title: rawPage["caption"],
        onTap: () => controller.loadPage(page),
      );
      // } else {
      //   return OfflinePageCardCupertino(
      //     page: page,
      //     index: index,
      //     onTap: () => controller.loadPage(page),
      //     useColoredTile: true,
      //   );
      // }

      // return OfflinePageCardCupertino(
      //   page: page,
      //   index: index,
      //   onTap: () => controller.loadPage(page),
      //   useColoredTile: true,
      // );
    } else if (page.pageType == "iview") {
      return Obx(
        () => ReportActionTile(
          isDisabled: !controller.isConnected.value,
          icon: Icons.report,
          title: rawPage["caption"],
          onTap: () {
            controller.onReportCardClick(rawPage['transid']);
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class OfflinePageCardCupertino extends StatelessWidget {
  final OfflineFormPageModel page;
  final int index;
  final VoidCallback onTap;
  final bool useColoredTile;

  const OfflinePageCardCupertino({
    super.key,
    required this.page,
    required this.index,
    required this.onTap,
    this.useColoredTile = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = useColoredTile
        ? MyColors.getOfflineColorByIndex(index)
        : Colors.blueGrey.shade600;

    final Color bgColor = accentColor.withOpacity(0.12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- ICON ----------
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.description_outlined,
                size: 24,
                color: accentColor,
              ),
            ),

            const Spacer(),

            // ---------- TITLE ----------
            Text(
              page.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            // ---------- ATTACHMENT INDICATOR ----------
            if (page.attachments)
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 14,
                    color: accentColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Attachments',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
