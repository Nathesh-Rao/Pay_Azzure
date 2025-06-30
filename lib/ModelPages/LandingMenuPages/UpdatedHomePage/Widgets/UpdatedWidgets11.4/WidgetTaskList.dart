import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../Constants/MyColors.dart';
import '../../Models/TaskListModel.dart';
import '../../Models/UpdatedHomeCardDataModel.dart';

class WidgetTaskList extends StatefulWidget {
  const WidgetTaskList({super.key});

  @override
  State<WidgetTaskList> createState() => _WidgetTaskListState();
}

class _WidgetTaskListState extends State<WidgetTaskList> {
  MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: menuHomePageController.taskListData.isNotEmpty,
        child: Column(
          children: List.generate(menuHomePageController.taskListData.length,
              (index) => TaskListPanel(taskListData: menuHomePageController.taskListData[index])),
        ),
      ),
    );
  }
}

class TaskListPanel extends StatefulWidget {
  const TaskListPanel({super.key, required this.taskListData});
  final UpdatedHomeCardDataModel taskListData;
  @override
  State<TaskListPanel> createState() => _TaskListPanelState();
}

class _TaskListPanelState extends State<TaskListPanel> {
  ///NOTE => tod0 height settings

  MenuHomePageController menuHomePageController = Get.find();
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
        bHeight = (widget.taskListData.carddata.length > 10 ? bHeight2 : _getHeight_card(widget.taskListData.carddata.length));
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
  // @override
  // void initState() {
  //   scrollController.addListener(() {
  //     print("ScrollCO")
  //     if (scrollController.position == scrollController.position.minScrollExtent) {
  //       // setState(() {
  //       //   bHeight = bHeight1;
  //       // });
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var isSeeMoreVisible = widget.taskListData.carddata.length >= 3;
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
          height: bHeight,
          child: Container(
              height: bHeight,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: Column(children: [
                InkWell(
                  onTap: () {
                    if (isSeeMoreVisible) {
                      _onClickSeeMore();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_activity_outlined,
                          // size: 17,
                        ),
                        SizedBox(width: 5),
                        Text(widget.taskListData.cardname ?? "",
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
                  itemCount: widget.taskListData.carddata.length,
                  physics: isSeeMore
                      ? BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        )
                      : NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _tileWidget(widget.taskListData.carddata[index]),
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
                    : SizedBox.shrink(),
              ])),
        ));
  }

  Widget _tileWidget(cardData) {
    var taskData = TaskListModel.fromJson(cardData);

    var isCompleted = taskData.cstatus != null ? taskData.cstatus!.toLowerCase().contains("completed") : false;
    return ListTile(
      onTap: () {
        // menuHomePageController.captionOnTapFunctionNew(taskData.tasktype);
      },
      leading: CircleAvatar(
        backgroundColor: isCompleted ? MyColors.green : MyColors.yellow1,
        radius: 18,
        child: Icon(
          isCompleted ? Icons.done_rounded : Icons.pending_actions,
          color: isCompleted ? MyColors.white1 : MyColors.blue2,
          size: 16,
        ),
      ),
      title: Text(
        taskData.displaytitle ?? '',
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        taskData.displaycontent ?? '',
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
      trailing: Text(
        taskData.eventdatetime != null ? taskData.eventdatetime!.split(" ")[0] : '',
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: MyColors.text2,
        ),
      ),
    );
  }
}
