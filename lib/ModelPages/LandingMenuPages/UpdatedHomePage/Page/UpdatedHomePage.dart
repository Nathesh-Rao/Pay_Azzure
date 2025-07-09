import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetBannerSliding.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetSlidingNotification.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../LandingPage/Widgets/WidgetKPIPanel.dart';
import '../Widgets/UpdatedWidgets11.4/WidgetActivityList.dart';
import '../Widgets/UpdatedWidgets11.4/WidgetBannerCard.dart';
import '../Widgets/UpdatedWidgets11.4/WidgetKPIList.dart';
import '../Widgets/UpdatedWidgets11.4/WidgetKPIPanelSlider.dart';
import '../Widgets/UpdatedWidgets11.4/WidgetMenuIcons.dart';
import '../Widgets/UpdatedWidgets11.4/WidgetNewsCard.dart';
import '../Widgets/UpdatedWidgets11.4/WidgetTaskList.dart';
import '../Widgets/WidgetAttendancePanel.dart';
import '../Widgets/WidgetMenuFolderPanels.dart';
import '../Widgets/WidgetQuickAccessPanel.dart';
import '../Widgets/WidgetShortcutPanels.dart';
import '../Widgets/WidgetTopHeaderSection.dart';

class UpdatedHomePage extends StatelessWidget {
  UpdatedHomePage({super.key});

  // UpdatedHomePageController updatedHomePageController = Get.put(UpdatedHomePageController());
  final MenuHomePageController menuHomePageController = Get.find();
  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    LogService.writeLog(message: "[>] UpdatedHomePage");
    return Scaffold(
      backgroundColor: Color(0xffebeff2),
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
                    child: Container(
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        gradient: MyColors.updatedUIBackgroundGradient,
                        // borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetTopHeaderSection(),
                          WidgetShortcutPanel(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildLoadingIndicator(),
                //Banner panel
                // WidgetBannerSlidingPanel(),
                //::: WidgetSlidingNotificationPanel(),
                //NOTE=== AXPERT 11.4 New UI Widgets ====>
                WidgetBannerCard(),
                WidgetKPIPanelSlider(),
                WidgetTaskList(),
                WidgetKPIList(),
                WidgetNewsCard(),
                WidgetMenuIcons(),
                WidgetActivityList(),

                // WidgetBannerCard(),
                //NOTE===================================>
                //KPI panel
                // Widgetkpipanel(),
                //Attendance
                // WidgetAttendancePanel(),
                //Quick Links
                // WidgetQuickAccessPanel(),
                //Home configuration panels
                // WidgetMenuFolderPanels(),

                //add your panel here
                //Till here
                //keep it as it is
                SizedBox(height: 100),
              ],
            ),
          )),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     FloatingActionButton(
      //         child: Icon(Icons.refresh),
      //         onPressed: () {
      //           menuHomePageController.pseudoCallGet();
      //         }),
      //     FloatingActionButton(
      //         child: Icon(Icons.clear_all),
      //         onPressed: () {
      //           menuHomePageController.pseudoCallClear();
      //         })
      //   ],
      // ),
    );
  }

  Widget _buildLoadingIndicator() {
    return  Obx(
          () => menuHomePageController.isLoading.value
          ? Padding(
        padding: EdgeInsets.only(top: 1),
        child: LinearProgressIndicator(
          minHeight: 1,
          borderRadius: BorderRadius.circular(100),
        ),
      )
          : SizedBox.shrink(),
    );
  }
}
