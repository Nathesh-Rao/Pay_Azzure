import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetDisplayProfileDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetLandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  WidgetLandingAppBar({super.key});
  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/axpert_full.png",
              height: 25,
            ),
            // Text(
            //   "xpert",
            //   style: TextStyle(fontFamily: 'Gellix-Black', color: HexColor("#133884"), fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
      centerTitle: false,
      actions: [
        Obx(() => IconButton(
              onPressed: () {
                landingPageController.showNotifications();
              },
              icon: Badge(
                isLabelVisible: landingPageController.showBadge.value,
                label: Text(landingPageController.badgeCount.value.toString()),
                child: Icon(Icons.notifications_active_outlined),
              ),
            )),
        // IconButton(onPressed: () {}, icon: Icon(Icons.dashboard_customize_outlined)),
        InkWell(
          onTap: () {
            Get.dialog(WidgetDisplayProfileDetails());
          },
          child: Icon(Icons.person_pin, color: MyColors.black, size: 35),
          // child: CircleAvatar(
          //   // backgroundImage: AssetImage('assets/images/profpic.jpg'),
          //   backgroundColor: Colors.blue,
          //   backgroundImage: AssetImage("assets/images/axpert.png"),
          // ),
        ),
        SizedBox(
          width: 8,
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
