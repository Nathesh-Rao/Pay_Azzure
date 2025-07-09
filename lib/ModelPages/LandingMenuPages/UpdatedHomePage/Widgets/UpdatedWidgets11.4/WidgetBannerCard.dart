import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../Constants/MyColors.dart';
import '../../Models/BannerCardModel.dart';
import '../../Models/UpdatedHomeCardDataModel.dart';

class WidgetBannerCard extends StatelessWidget {
  WidgetBannerCard({super.key});

  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    CarouselSliderController bannerController = CarouselSliderController();
    return Obx(
      () {
        if (!menuHomePageController.bannerCardData.value.isEmpty) {
          return Visibility(
            visible: menuHomePageController.bannerCardData.isNotEmpty,
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.24,
                  child: CarouselSlider(
                    items: List.generate(
                        menuHomePageController.bannerCardData[0].carddata.length,
                        (index) =>
                            _bannerCard(menuHomePageController.bannerCardData[0].carddata[index], menuHomePageController.bannerCardData[0].cardname)),
                    carouselController: bannerController,
                    options: CarouselOptions(
                      height: double.maxFinite,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        menuHomePageController.updateBannerIndex(index);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(menuHomePageController.bannerCardData[0].carddata.length, (index) {
                      var isSelected = index == menuHomePageController.bannerIndex.value;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        height: isSelected ? 10 : 8,
                        width: isSelected ? 10 : 8,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  _bannerCard(dynamic cardData, String? cardname) {
    var bannerData = BannerCard.fromJson(cardData);

    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFA61E2A), //Color(0xff5c61f1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.bottomRight,
              child: CachedNetworkImage(
                imageUrl: bannerData.image ?? '',
                width: Get.width / 3,
                /*placeholder: (context, url) => Center(
                  child: CircularProgressIndicator.adaptive(), // Show while loading
                ),*/
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/banner_default_slider.png',
                  width: Get.width / 3,
                ),
                fadeInDuration: Duration(milliseconds: 300),
              )),
          Align(
              child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              "assets/images/sliderBG.png",

              // fit: BoxFit.fill,
            ),
          )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardname ?? '',
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: MyColors.white1,
                      ),
                    ),
                    SizedBox(height: 10),

                    Container(
                      width: Get.width * 0.6, // 60% of screen width
                      child: Text(
                        bannerData.title ?? '',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MyColors.white2,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: Get.width / 1.7,
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            bannerData.subtitle ?? '',
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: MyColors.white3.withAlpha(190),
                            ),
                          )),
                        ],
                      ),
                    ),
                    // SizedBox(height: 15),
                    // Visibility(
                    //   visible: bannerData.time != null,
                    //   child: Container(
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(25),
                    //       ),
                    //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    //       child: Text(
                    //         bannerData.time ?? '',
                    //         style: GoogleFonts.urbanist(
                    //           fontWeight: FontWeight.w700,
                    //           fontSize: 10,
                    //           color: MyColors.blue1,
                    //         ),
                    //       )),
                    // ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//NOTE------------------------------------------->

class WidgetBannerCard1 extends StatelessWidget {
  WidgetBannerCard1({super.key, required this.cardModel});

  final UpdatedHomeCardDataModel cardModel;

  @override
  Widget build(BuildContext context) {
    CarouselSliderController bannerController = CarouselSliderController();
    var bannerIndex = 0;
    // return Text("${cardModel.carddata.isEmpty}");
    if (cardModel.carddata.isNotEmpty) {
      return Visibility(
        visible: cardModel.carddata.isNotEmpty,
        child: StatefulBuilder(builder: (context, update) {
          return Column(
            children: [
              SizedBox(
                height: Get.height * 0.24,
                child: CarouselSlider(
                  items: List.generate(cardModel.carddata.length, (index) => _bannerCard(cardModel.carddata[index], cardModel.cardname)),
                  carouselController: bannerController,
                  options: CarouselOptions(
                    height: double.maxFinite,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      // menuHomePageController.updateBannerIndex(index);
                      update(() {
                        bannerIndex = index;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(cardModel.carddata.length, (index) {
                    var isSelected = index == bannerIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      height: isSelected ? 10 : 8,
                      width: isSelected ? 10 : 8,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              )
            ],
          );
        }),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  _bannerCard(dynamic cardData, String? cardname) {
    var bannerData = BannerCard.fromJson(cardData);

    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff5c61f1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.bottomRight,
              child: CachedNetworkImage(
                imageUrl: bannerData.image ?? '',
                width: Get.width / 3,
                /*placeholder: (context, url) => Center(
                  child: CircularProgressIndicator.adaptive(), // Show while loading
                ),*/
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/banner_default_slider.png',
                  width: Get.width / 3,
                ),
                fadeInDuration: Duration(milliseconds: 300),
              )),
          Align(
              child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              "assets/images/sliderBG.png",

              // fit: BoxFit.fill,
            ),
          )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardname ?? '',
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: MyColors.white1,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    bannerData.title ?? '',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: MyColors.blue2,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: Get.width / 2,
                    child: Row(
                      children: [
                        Flexible(
                            child: Text(
                          bannerData.subtitle ?? '',
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: MyColors.white3.withAlpha(190),
                          ),
                        )),
                      ],
                    ),
                  ),
                  // SizedBox(height: 15),
                  // Visibility(
                  //   visible: bannerData.time != null,
                  //   child: Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  //       child: Text(
                  //         bannerData.time ?? '',
                  //         style: GoogleFonts.urbanist(
                  //           fontWeight: FontWeight.w700,
                  //           fontSize: 10,
                  //           color: MyColors.blue1,
                  //         ),
                  //       )),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
