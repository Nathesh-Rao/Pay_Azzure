import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetSlidingNotificationPanel extends StatelessWidget {
  WidgetSlidingNotificationPanel({super.key});

  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (landingPageController.needRefreshNotification.value == true) {
        landingPageController.needRefreshNotification.value = false;
        return reBuild(context);
      } else
        return reBuild(context);
    });
  }

  reBuild(context) => Visibility(
        visible: landingPageController.getNotificationList(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            shadowColor: MyColors.color_grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              height: MediaQuery.of(context).size.height * .15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [HexColor("#FEFCFF"), HexColor("#F5F5F5")],
                ),
              ),
              child: Obx(
                () => GestureDetector(
                  onTap: () {
                    print(landingPageController.carouselIndex.value);
                    landingPageController.fetchAndOpenWebView(landingPageController.carouselIndex.value);
                  },
                  child: Stack(
                    children: [
                      CarouselSlider(
                        items: landingPageController.list.length > 5
                            ? landingPageController.list.sublist(0, 5)
                            : landingPageController.list,
                        carouselController: landingPageController.carouselController_notify,
                        options: CarouselOptions(
                          initialPage: landingPageController.carouselIndex.value,
                          height: double.maxFinite,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          onPageChanged: (index, reason) {
                            landingPageController.carouselIndex.value = index;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: (landingPageController.list.length > 5
                                  ? landingPageController.list.sublist(0, 5)
                                  : landingPageController.list)
                              .asMap()
                              .entries
                              .map((entry) {
                            return GestureDetector(
                              onTap: () => landingPageController.carouselController_notify.animateToPage(entry.key),
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : HexColor("133884"))
                                        .withOpacity(landingPageController.carouselIndex.value == entry.key ? 0.9 : 0.1)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
