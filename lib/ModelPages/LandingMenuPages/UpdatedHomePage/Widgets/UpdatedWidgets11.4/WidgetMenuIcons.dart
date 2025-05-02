import 'dart:developer';
import 'dart:math';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/UpdatedHomePage/Models/MenuIconsModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/UpdatedHomePage/Models/UpdatedHomeCardDataModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../Constants/Const.dart';
import '../../../Controllers/MenuHomePageController.dart';

class WidgetMenuIcons extends StatefulWidget {
  const WidgetMenuIcons({super.key});

  @override
  State<WidgetMenuIcons> createState() => _WidgetMenuIconsState();
}

class _WidgetMenuIconsState extends State<WidgetMenuIcons> {
  ///NOTE => This container will be having 4 rows and therefore 4 heights depends up on the number of quicklinks available
  ///NOTE => A new way to layout the tile's height and width is needed
  ///NOTE => Ditch Gridview and Use Wrap
  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: menuHomePageController.menuIconsData.isNotEmpty,
          child: Column(
            children: List.generate(menuHomePageController.menuIconsData.length, (index) {
              List<Color> colors = List.generate(
                  menuHomePageController.menuIconsData[index].carddata.length, (index) => MyColors.getRandomColor());
              return MenuIconsPanel(
                card: menuHomePageController.menuIconsData[index],
                colors: colors,
              );
            }),
          ),
        ));
  }
}

class MenuIconsPanel extends StatefulWidget {
  const MenuIconsPanel({super.key, required this.card, required this.colors});

  final UpdatedHomeCardDataModel card;
  final List<Color> colors;

  @override
  State<MenuIconsPanel> createState() => _MenuIconsPanelState();
}

class _MenuIconsPanelState extends State<MenuIconsPanel> {
  final MenuHomePageController menuHomePageController = Get.find();
  final GlobalKey _cardKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  var card_height = Get.height / 3.8;

  var card_heightBeforeExpand = 0.0;
  var card_heightAfterExpand = Get.height / 1.89;
  var isSeeMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCardHeight();
    });
  }

  void _getCardHeight() {
    final RenderBox? renderBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        card_heightBeforeExpand = renderBox.size.height + 20;
        card_height = card_heightBeforeExpand;
      });
    }
  }

  _onClickSeeMore() {
    setState(() {
      isSeeMore = !isSeeMore;
      if (isSeeMore) {
        // bHeight = bHeight2;
        card_height = (widget.card.carddata.length > 10 ? card_heightAfterExpand : _getHeight_card(widget.card.carddata.length));
      } else {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
        // bHeight = bHeight1;
        card_height = card_heightBeforeExpand;
      }
    });
  }

  void _onClickSeeAll(cardData, {required String cardName}) async {
    await Get.bottomSheet(
        ignoreSafeArea: true,
        QuickLinksBottomSheet(
          cardData,
          cardName: cardName,
          colors: widget.colors,
        )).then((_) {
      setState(() {
        if (isSeeMore) {
          scrollController.animateTo(scrollController.position.minScrollExtent,
              duration: Duration(milliseconds: 300), curve: Curves.decelerate);
          isSeeMore = !isSeeMore;
          // bHeight = bHeight1;
          card_height = card_heightBeforeExpand;
        }
        ;
      });
    });
  }

  _getHeight_card(itemCount) {
    int crossAxisCount = 3;
    int rowCount = (itemCount / crossAxisCount).ceil();

    double itemHeight = 50;
    double spacing = 10 * (rowCount - 1);

    return rowCount * itemHeight + spacing + 200;
  }

  @override
  Widget build(BuildContext context) {
    var isSeeMoreVisible = widget.card.carddata.length > 6;
    var isSeeAllVisible = widget.card.carddata.length > 12;
    return Card(
      key: _cardKey,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      elevation: 2,
      shadowColor: MyColors.color_grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: double.infinity,
        height: widget.card.carddata.length > 6 ? card_height : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _onClickSeeMore();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      // size: 17,
                    ),
                    SizedBox(width: 5),
                    Text(widget.card.cardname ?? "",
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        )),
                    // Text(card_height.toString(),
                    //     style: GoogleFonts.urbanist(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w700,
                    //     )),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Flexible(
              child: GridView.builder(
                controller: scrollController,
                physics: isSeeMore
                    ? BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                      )
                    : NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 items in a row
                  crossAxisSpacing: 5, // Spacing between columns
                  mainAxisSpacing: 5, // Spacing between rows
                  childAspectRatio: 4 / 3, // Width to height ratio
                ),
                itemCount: widget.card.carddata.length,
                // Number of items
                itemBuilder: (context, index) {
                  return _gridTile(widget.card.carddata[index], widget.colors[index]);
                },
              ),
            ),
            SizedBox(height: 5),
            // Expanded(
            //     child: Wrap(
            //   spacing: 10,
            //   runSpacing: 10,
            //   runAlignment: WrapAlignment.spaceAround,
            //   alignment: WrapAlignment.start,
            //   children: List.generate(isSeeMore ? 12 : 6, (index) => _gridTile(index)),
            // )),
            isSeeMoreVisible
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            _onClickSeeMore();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isSeeMore ? "See less" : "See more",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: MyColors.blue1,
                                  )),
                              Icon(
                                isSeeMore ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: MyColors.blue1,
                                size: 17,
                              )
                            ],
                          ),
                        ),
                      ),
                      isSeeAllVisible
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () {
                                  _onClickSeeAll(widget.card.carddata, cardName: widget.card.cardname ?? "");
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("See all ",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.blue1,
                                        )),
                                    Icon(
                                      Icons.open_in_browser,
                                      color: MyColors.blue1,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _gridTile(cardData, Color color) {
    MenuIconsModel menuIconData = MenuIconsModel.fromJson(cardData);

    return InkWell(
      onTap: () {
        menuHomePageController.captionOnTapFunctionNew(menuIconData.link);
      },
      child: Column(
        children: [
          // Expanded(
          //     child: Row(
          //   children: [
          //     Spacer(),
          //     Icon(Icons.more_vert),
          //   ],
          // )),
          Expanded(
              flex: 5,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: color.withAlpha(50),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      menuIconData.name != null ? menuIconData.name!.getInitials() : "0",
                      style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w700, color: color.darken(0.4)),
                    )
                    //       CachedNetworkImage(
                    //   imageUrl: Const.getFullProjectUrl("images/homepageicon/") + menuIconData.name.toString() + '.png',
                    //   errorWidget: (context, url, error) =>
                    //       Image.network(Const.getFullProjectUrl('images/homepageicon/default.png')),
                    // ),
                    ),
              )),
          // Expanded(flex: 2, child: ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
                height: 30,
                child: Center(
                    child: Text(
                  menuIconData.name ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ))),
          )
        ],
      ),
    );
  }
}

class QuickLinksBottomSheet extends StatelessWidget {
  QuickLinksBottomSheet(this.menuIconsData, {super.key, required this.cardName, required this.colors});

  final dynamic menuIconsData;
  final String cardName;
  final MenuHomePageController menuHomePageController = Get.find();
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: menuIconsData.length > 9 ? Get.height * 0.75 : Get.height / 2.5,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cardName,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(CupertinoIcons.clear_circled_solid))
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          Expanded(
            child: GridView.builder(
              physics: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items in a row
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 4 / 3, // Width to height ratio
              ),
              itemCount: menuIconsData.length,
              // Number of items
              itemBuilder: (context, index) {
                return _gridTile(menuIconsData[index], colors[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridTile(cardData, Color color) {
    MenuIconsModel menuIconData = MenuIconsModel.fromJson(cardData);

    return InkWell(
      onTap: () {
        menuHomePageController.captionOnTapFunctionNew(menuIconData.link);
      },
      child: Column(
        children: [
          // Expanded(
          //     child: Row(
          //   children: [
          //     Spacer(),
          //     Icon(Icons.more_vert),
          //   ],
          // )),
          Expanded(
              flex: 5,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: color.withAlpha(50),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // child: CachedNetworkImage(
                    //   imageUrl: Const.getFullProjectUrl("images/homepageicon/") + menuIconData.name.toString() + '.png',
                    //   errorWidget: (context, url, error) =>
                    //       Image.network(Const.getFullProjectUrl('images/homepageicon/default.png')),
                    // ),
                    child: Text(
                      menuIconData.name != null ? menuIconData.name!.getInitials() : "0",
                      style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w700, color: color.darken(0.4)),
                    )),
              )),
          // Expanded(flex: 2, child: ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
                height: 30,
                child: Center(
                    child: Text(
                  menuIconData.name ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ))),
          )
        ],
      ),
    );
  }
}
