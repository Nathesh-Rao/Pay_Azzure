import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'WidgetQuickAccessPanelItem.dart';

class WidgetQuickAccessPanel extends StatelessWidget {
  WidgetQuickAccessPanel({super.key});
  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: menuHomePageController.listOfOptionCards.length == 0 ? false : true,
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quick links",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 10),
                // Container(
                //   // decoration: BoxDecoration(
                //   //     borderRadius: BorderRadius.circular(10),
                //   //     border: Border.all(width: 1, color: MyColors.grey.withOpacity(0.3)),
                //   //     color: Colors.grey.shade100),
                //   child: Padding(
                //     padding: EdgeInsets.only(
                //       top: 10,
                //       bottom: 10,
                //     ),
                //     child: GridView.builder(
                //       shrinkWrap: true,
                //       padding: EdgeInsets.zero,
                //       physics: NeverScrollableScrollPhysics(),
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 2,
                //           crossAxisSpacing: 5,
                //           mainAxisSpacing: 5),
                //       // itemCount: menuHomePageController.listOfCards.length,
                //       itemCount:
                //           menuHomePageController.listOfOptionCards.length,
                //       itemBuilder: (context, index) {
                //         // return WidgetCardUpdated(menuHomePageController.listOfCards[index]);
                //         return GestureDetector(
                //           onTap: () {
                //             menuHomePageController.captionOnTapFunction(
                //                 menuHomePageController
                //                     .listOfOptionCards[index].stransid);
                //           },
                //           child: AspectRatio(
                //             aspectRatio: 1 / 1,
                //             child: WidgetUpdatedCards(menuHomePageController
                //                 .listOfOptionCards[index]),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
                Card(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shadowColor: MyColors.color_grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: Color(0xffeeeff9),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: _getHeight(context),

                    width: double.infinity,

                    // child: Wrap(
                    //   spacing: 10,
                    //   runSpacing: 10,
                    //   alignment: WrapAlignment.spaceBetween,
                    //   runAlignment: WrapAlignment.spaceBetween,
                    //   children: generateItems(),
                    // ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 15,
                      ),
                      // itemCount: menuHomePageController.listOfCards.length,
                      itemCount: generateItems().length,
                      itemBuilder: (context, index) {
                        // return WidgetCardUpdated(menuHomePageController.listOfCards[index]);
                        return AspectRatio(aspectRatio: 1 / 1, child: generateItems()[index]);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _getHeight(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.25;
    if (menuHomePageController.listOfOptionCards.length <= 4) {
      return height / 2;
    }
    return height;
  }

  List<Widget> generateItems() {
    List<Widget> items = List.generate(
      menuHomePageController.listOfOptionCards.length,
      (index) => QuickAccessTileWidget(menuHomePageController.listOfOptionCards[index]),
    );

    if (items.length >= 8) {
      items = items.sublist(0, 7);
      items.add(QuickAccessTileMoreWidget(
        menuHomePageController.listOfOptionCards,
      ));
    } else {
      int itemsToAdd = 8 - items.length;

      items.addAll(List.filled(itemsToAdd, QuickAccessTileEmptyeWidget()));
    }

    return items;
  }
/*  captionOnTapFunction(transid) {
    var link_id = transid;
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
  }*/
}
