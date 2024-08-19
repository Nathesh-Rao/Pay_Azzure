import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuMorePage/Models/MenuItemModel.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import '../../LandingMenuPages/MenuMorePage/Controllers/MenuMorePageController.dart';

class WidgetDrawer extends StatelessWidget {
  WidgetDrawer({super.key});

  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        ClipRRect(
          clipper: getClipped(),
          child: Drawer(
            child: SafeArea(
              child: ListView(
                children:  ListTile.divideTiles(context: context, tiles: landingPageController.getDrawerTileList()).toList(),
              ),
            ),
          ),
        ));
  }


}

class getClipped extends CustomClipper<RRect> {
  @override
  getClip(Size size) {
    return RRect.fromLTRBAndCorners(0, 0, size.width, size.height, bottomRight: Radius.circular(40));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return true;
  }
}
