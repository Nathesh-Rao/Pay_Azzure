import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/UpdatedHomePage/Widgets/WidgetAttendancePanel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/UpdatedHomePage/Widgets/WidgetQuickAccessPanel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/UpdatedHomePage/Widgets/WidgetShortcutPanels.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/UpdatedHomePage/Widgets/WidgetTopHeaderSection.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetSlidingNotification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatedHomePage extends StatelessWidget {
  UpdatedHomePage({super.key});

  // UpdatedHomePageController updatedHomePageController = Get.put(UpdatedHomePageController());
  final MenuHomePageController menuHomePageController = Get.find();
  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                WidgetSlidingNotificationPanel(),
                //Attendance
                WidgetAttendancePanel(),
                //Quick Links
                WidgetQuickAccessPanel(),
                //add your panel here

                //Till here
                //keep it as it is
                SizedBox(height: 100),
              ],
            ),
          )),
    );
  }

  captionOnTapFunction(cardModel) {
    var link_id = cardModel.stransid;
    var validity = false;
    if (link_id.toLowerCase().startsWith('h')) {
      if (link_id.toLowerCase().contains("hp")) {
        link_id = link_id.toLowerCase().replaceAll("hp", "h");
      }
      validity = true;
    } else {
      if (link_id.toLowerCase().startsWith('i')) {
        validity = true;
      } else {
        if (link_id.toLowerCase().startsWith('t')) {
          validity = true;
        } else
          validity = false;
      }
    }
    if (validity) {
      menuHomePageController.openBtnAction("button", link_id);
    }
  }
}
