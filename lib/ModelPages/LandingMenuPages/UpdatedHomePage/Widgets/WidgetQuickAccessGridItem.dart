import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/GridDashboardModel.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetQuickAccessGridItems extends StatelessWidget {
  WidgetQuickAccessGridItems(this.model, {super.key});
  final GridDashboardModel model;
  final MenuHomePageController menuHomePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white.withOpacity(0.1))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: badge.Badge(
                  showBadge: (int.tryParse(model.count) ?? 0) != 0,
                  badgeStyle: badge.BadgeStyle(
                      shape: badge.BadgeShape.circle,
                      elevation: 10,
                      padding: EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
                      badgeColor: Colors.white,
                      borderSide: BorderSide(width: 1, color: MyColors.blue2)),
                  badgeContent: Text(
                    model.count,
                    style: TextStyle(fontSize: 10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                    child: Icon(
                      menuHomePageController.generateIcon(model),
                      color: MyColors.blue2,
                    ),
                  ),
                ),
                // child: Badge(
                //   isLabelVisible: true,
                //   backgroundColor: Colors.white,
                //   textColor: MyColors.blue2,
                //   alignment: Alignment.topRight,
                //   padding: EdgeInsets.zero,
                //   label: Container(
                //     padding: EdgeInsets.all(2),
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         border: Border.all(width: 1, color: MyColors.blue2),
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Text(
                //       "1999",
                //     ),
                //   ),
                //   child: Container(
                //     padding: const EdgeInsets.all(10),
                //     decoration:
                //         BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                //     child: Image.asset(
                //       'assets/images/announce.png',
                //       height: 20,
                //     ),
                //   ),
                // ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Text(
                  CommonMethods.capitalize(model.caption),
                  maxLines: 2,
                  style:
                      GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
