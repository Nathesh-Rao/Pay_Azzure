import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetDrawer extends StatelessWidget {
  WidgetDrawer({super.key});
  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Drawer(
          child: SafeArea(
            child: ListView(
              children: ListTile.divideTiles(context: context, tiles: landingPageController.getDrawerTileList()).toList(),
            ),
          ),
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Drawer(
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           DrawerHeader(
  //               decoration: BoxDecoration(
  //                   // gradient: LinearGradient(
  //                   //     colors: [MyColors.blue2, MyColors.blue1],
  //                   //     begin: Alignment.bottomCenter,
  //                   //     end: Alignment.topCenter,
  //                   //     stops: [0.3, 0.8]),
  //                   ),
  //               curve: Curves.easeInOut,
  //               child: Column(
  //                 children: [
  //                   Padding(
  //                       padding: const EdgeInsets.only(left: 50, right: 50),
  //                       child: Image.asset(
  //                         'assets/images/axpert_name.png',
  //                         width: 100,
  //                       )),
  //                   SizedBox(height: 20),
  //                   Text("data")
  //                 ],
  //               )),
  //           Expanded(
  //             child: Container(
  //               height: double.maxFinite,
  //               width: double.maxFinite,
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 itemBuilder: (context, index) => ListTile(title: Text("Hello")),
  //                 itemCount: 30,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
