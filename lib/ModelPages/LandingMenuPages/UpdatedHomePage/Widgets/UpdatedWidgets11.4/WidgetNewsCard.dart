import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../Constants/MyColors.dart';
import '../../../../../../Constants/Const.dart';
import '../../../MenuHomePagePage/Controllers/MenuHomePageController.dart';
import '../../Models/NewsCardModel.dart';
import '../../Models/UpdatedHomeCardDataModel.dart';

class WidgetNewsCard extends StatefulWidget {
  const WidgetNewsCard({super.key});

  @override
  State<WidgetNewsCard> createState() => _WidgetNewsCardState();
}

class _WidgetNewsCardState extends State<WidgetNewsCard> {
  ///NOTE => This container will be having 4 rows and therefore 4 heights depends up on the number of quicklinks available
  ///NOTE => A new way to layout the tile's height and width is needed
  ///NOTE => Ditch Gridview and Use Wrap
  MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: menuHomePageController.newsCardData.isNotEmpty,
        child: Column(
          children: List.generate(menuHomePageController.newsCardData.length,
              (index) => NewsPanel(newsCardData: menuHomePageController.newsCardData[index])),
        ),
      ),
    );
  }
}

class NewsPanel extends StatefulWidget {
  const NewsPanel({super.key, required this.newsCardData});

  final UpdatedHomeCardDataModel newsCardData;

  @override
  State<NewsPanel> createState() => _NewsPanelState();
}

class _NewsPanelState extends State<NewsPanel> {
  MenuHomePageController menuHomePageController = Get.find();

  ScrollController scrollController = ScrollController();
  final GlobalKey _cardKey = GlobalKey();
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
        card_heightBeforeExpand = renderBox.size.height;
        card_height = card_heightBeforeExpand;
      });
    }
  }

  _onClickSeeMore() {
    setState(() {
      isSeeMore = !isSeeMore;
      if (isSeeMore) {
        card_height = (widget.newsCardData.carddata.length > 10
            ? card_heightAfterExpand
            : _getHeight_card(widget.newsCardData.carddata.length));
      } else {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
        card_height = card_heightBeforeExpand;
      }
    });
  }

  _getHeight_card(itemCount) {
    int crossAxisCount = 1;
    int rowCount = (itemCount / crossAxisCount).ceil();

    double itemHeight = 50;
    double spacing = 5 * (rowCount - 1);

    return (rowCount * (itemHeight + spacing)) + 150;
  }

  @override
  Widget build(BuildContext context) {
    var isSeeMoreVisible = widget.newsCardData.carddata.length > 2;
    // var isSeeAllVisible = widget.newsCardData.carddata.length > 4;
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
          // height: null,
          height: widget.newsCardData.carddata.length > 2 ? card_height : null,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(
              onTap: () {
                _onClickSeeMore();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.newspaper,
                      // size: 15,
                    ),
                    SizedBox(width: 5),
                    // Text(card_height.toString(),
                    //     style: GoogleFonts.urbanist(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w700,
                    //     )),
                    Text(widget.newsCardData.cardname ?? "",
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Flexible(
                child: ListView.separated(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: widget.newsCardData.carddata.length,
              physics: isSeeMore
                  ? BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    )
                  : NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _tileWidget(widget.newsCardData.carddata[index]),
              separatorBuilder: (context, index) => Divider(height: 0, thickness: 1),
            )),
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
                      // Padding(
                      //   padding: const EdgeInsets.all(10),
                      //   child: InkWell(
                      //     onTap: () {
                      //       // _onClickSeeAll();
                      //     },
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text("See all ",
                      //             style: GoogleFonts.urbanist(
                      //               fontSize: 12,
                      //               fontWeight: FontWeight.w700,
                      //               color: MyColors.blue1,
                      //             )),
                      //         Icon(
                      //           Icons.open_in_browser,
                      //           color: MyColors.blue1,
                      //           size: 15,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                : SizedBox.shrink()
          ]),
        ));
  }

  Widget _tileWidget(newsCardData) {
    var newsData = NewsCardModel.fromJson(newsCardData);
    return InkWell(
      onTap: () {
        menuHomePageController.captionOnTapFunctionNew(newsData.link);
      },
      child: Container(
        height: 100,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
                child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: MyColors.grey,
                borderRadius: BorderRadius.circular(5),
                // image: DecorationImage(
                //   image: ,
                //   fit: BoxFit.cover,
                // ),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: newsData.image ?? '',
                errorWidget: (context, url, error) => Image.network(Const.getFullProjectUrl('images/homepageicon/default.png')),
              ),
            )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          newsData.title ?? '',
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          newsData.subtitle ?? '',
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          newsData.time ?? '',
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: MyColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
