import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/UpdatedHomePage/Widgets/WidgetUpdatedCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class WidgetQuickAccessPanel extends StatelessWidget {
  WidgetQuickAccessPanel({super.key});
  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: menuHomePageController.listOfCards.length == 0 ? false : true,
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
                Container(
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(width: 1, color: MyColors.grey.withOpacity(0.3)),
                  //     color: Colors.grey.shade100),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
                      // itemCount: menuHomePageController.listOfCards.length,
                      itemCount: menuHomePageController.listOfCards.length,
                      itemBuilder: (context, index) {
                        // return WidgetCardUpdated(menuHomePageController.listOfCards[index]);
                        return GestureDetector(
                          onTap: () {
                            captionOnTapFunction(menuHomePageController.listOfCards[index]);
                          },
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: WidgetUpdatedCards(menuHomePageController.listOfCards[index]),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
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
