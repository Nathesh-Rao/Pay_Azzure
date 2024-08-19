import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/CardModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/UpdatedHomePage/Widgets/WidgetQuickAccessGridItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WidgetShortcutPanel extends StatelessWidget {
  WidgetShortcutPanel({super.key});
  final MenuHomePageController menuHomePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: menuHomePageController.listOfGridCardItems.length,
            padding: EdgeInsets.only(top: 0, bottom: 5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // number of items in each row
              mainAxisSpacing: 0, // spacing between rows
              crossAxisSpacing: 0, // spacing between columns
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    captionOnTapFunction(CardModel(stransid: menuHomePageController.listOfGridCardItems[index].url));
                  },
                  child: WidgetQuickAccessGridItems(menuHomePageController.listOfGridCardItems[index]));
            },
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
