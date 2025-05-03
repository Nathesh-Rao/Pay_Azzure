import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../Constants/MyColors.dart';
import '../../../MenuHomePagePage/Controllers/MenuHomePageController.dart';
import '../../Models/ActivityListModel.dart';
import '../../Models/UpdatedHomeCardDataModel.dart';

class WidgetActivityList extends StatelessWidget {
  WidgetActivityList({super.key});

  ///NOTE => This container will be having 4 rows and therefore 4 heights depends up on the number of quicklinks available
  ///NOTE => A new way to layout the tile's height and width is needed
  ///NOTE => Ditch Gridview and Use Wrap
  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: menuHomePageController.activityListData.isNotEmpty,
        child: Column(
          children: List.generate(menuHomePageController.activityListData.length, (index) {
            List<Color> colors = List.generate(
                menuHomePageController.activityListData[index].carddata.length, (index) => MyColors.getRandomColor());
            return ActivityListPanel(activityListData: menuHomePageController.activityListData[index], colors: colors);
          }),
        ),
      ),
    );
  }
}

class ActivityListPanel extends StatefulWidget {
  const ActivityListPanel({super.key, required this.activityListData, required this.colors});

  final UpdatedHomeCardDataModel activityListData;
  final List<Color> colors;
  // final int index;

  @override
  State<ActivityListPanel> createState() => _ActivityListPanelState();
}

class _ActivityListPanelState extends State<ActivityListPanel> {
  final MenuHomePageController menuHomePageController = Get.find();
  ScrollController scrollController = ScrollController();
  var bHeight = Get.height / 3.22;

  var bHeight1 = Get.height / 3.22;
  var bHeight2 = Get.height / 1.89;
  var isSeeMore = false;

  _onClickSeeMore() {
    setState(() {
      isSeeMore = !isSeeMore;
      if (isSeeMore) {
        // bHeight = bHeight2;
        bHeight =
            (widget.activityListData.carddata.length > 11 ? bHeight2 : _getHeight_card(widget.activityListData.carddata.length));
      } else {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
        bHeight = bHeight1;
      }
    });
  }

  _getHeight_card(itemCount) {
    int crossAxisCount = 2;
    int rowCount = (itemCount / crossAxisCount).ceil();

    double itemHeight = 50;
    double spacing = 5 * (rowCount - 1);

    return rowCount * itemHeight + spacing + 200;
  }

  @override
  Widget build(BuildContext context) {
    var isSeeMoreVisible = widget.activityListData.carddata.length > 2;
    var isSeeAllVisible = widget.activityListData.carddata.length > 4;
    return Card(
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
          // height: menuHomePageController.activityListDataSwitches[widget.index].value ? bHeight2 : bHeight1,
          height: bHeight,
          child: Container(
              height: Get.height / 2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: Column(children: [
                InkWell(
                  onTap: () {
                    _onClickSeeMore();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          // size: 17,
                        ),
                        SizedBox(width: 5),
                        Text(widget.activityListData.cardname ?? '',
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
                Expanded(
                    child: ListView.separated(
                  padding: EdgeInsets.only(top: 15),
                  controller: scrollController,
                  itemCount: widget.activityListData.carddata.length,
                  physics: isSeeMore
                      ? BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        )
                      : NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _tileWidget(widget.activityListData.carddata[index], widget.colors[index]),
                  separatorBuilder: (context, index) => Divider(),
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
                        ],
                      )
                    : SizedBox.shrink()
              ])),
        ));
  }

  Widget _tileWidget(activityListData, Color color) {
    var activityData = ActivityListModel.fromJson(activityListData);

    Color darkenColor(Color color, [double amount = 0.2]) {
      assert(amount >= 0 && amount <= 1);
      return Color.fromARGB(
        color.alpha,
        (color.red * (1 - amount)).round(),
        (color.green * (1 - amount)).round(),
        (color.blue * (1 - amount)).round(),
      );
    }

    return ListTile(
      onTap: () {
        menuHomePageController.captionOnTapFunctionNew(activityData.link);
      },
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(100),
        radius: 18,
        child: Text(
          activityData.title != null ? activityData.title!.getInitials(subStringIndex: 2) : "0",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: darkenColor(color)),
        ),
      ),
      title: Text(
        activityData.title ?? '',
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        // activityData.calledon ?? "",
        activityData.calledon != null ? activityData.calledon!.timeAgo() : '',
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
      trailing: Text(
        activityData.username ?? "",
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: MyColors.text2,
        ),
      ),
    );
  }
}
