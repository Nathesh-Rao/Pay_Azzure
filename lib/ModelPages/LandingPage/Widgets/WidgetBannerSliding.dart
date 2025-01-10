import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Controller/LandingPageController.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetBannerSlidingPanel extends StatelessWidget {
  WidgetBannerSlidingPanel({super.key});

  final LandingPageController landingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: landingPageController.list_bannerItem.length > 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * .15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Obx(
              () => GestureDetector(
                onTap: () {
                  print(landingPageController.carouselBannerIndex.value);
                  //landingPageController.fetchAndOpenWebView(landingPageController.carouselIndex.value);
                },
                child: Stack(
                  children: [
                    CarouselSlider(
                      items: landingPageController.list_bannerItem.cast<Widget>().toList(),
                      carouselController: landingPageController.carouselController_banner,
                      options: CarouselOptions(
                        initialPage: landingPageController.carouselBannerIndex.value,
                        height: double.maxFinite,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 10),
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index, reason) {
                          landingPageController.carouselBannerIndex.value = index;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: landingPageController.list_bannerItem.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => landingPageController.carouselController_banner.animateToPage(entry.key),
                            child: Container(
                              width: 10.0,
                              height: 10.0,
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : HexColor("133884"))
                                      .withOpacity(landingPageController.carouselBannerIndex.value == entry.key ? 0.9 : 0.1)),
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
}
