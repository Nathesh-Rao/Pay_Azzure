import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Widgets/WidgetCard.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNoDataFound.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetSlidingNotification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuHomePage extends StatelessWidget {
  MenuHomePage({super.key});
  final MenuHomePageController menuHomePageController = Get.put(MenuHomePageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetSlidingNotificationPanel(),
        Obx(() => Visibility(
            visible: (menuHomePageController.listOfOptionCards.length == 0 && !menuHomePageController.isLoading.value) ? true : false,
            child: WidgetNoDataFound())),
        Expanded(
          child: Obx(() => Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: menuHomePageController.isLoading.value
                    ? Text("")
                    : GridView.builder(
                        padding: EdgeInsets.only(left: 10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                            childAspectRatio: isTablet() ? 1.5 : 2.8),
                        itemCount: menuHomePageController.listOfOptionCards.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              captionOnTapFunction(menuHomePageController.listOfOptionCards[index]);
                            },
                            child: Container(child: WidgetCard(menuHomePageController.listOfOptionCards[index])),
                          );
                        },
                      ),
              )),
        ),
      ],
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
      // print(
      //     "https://app.buzzily.com/run/aspx/AxMain.aspx?authKey=AXPERT-ARMSESSION-1ed2b2a1-e6f9-4081-b7cc-5ddcf50d8690&pname=" +
      //         cardModel.stransid);
      menuHomePageController.openBtnAction("button", link_id);
    }
  }
}
