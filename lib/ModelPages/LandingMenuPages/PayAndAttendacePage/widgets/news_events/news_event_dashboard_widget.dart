import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/announcement_model.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/empty_state_widget.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../icon_label_widget.dart';

class NewsEventsDashboardWidget extends GetView<PayAndLeaveController> {
  const NewsEventsDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getInitialData();
    });

    return Column(
      children: [
        Row(
          children: [
            IconLabelWidget(
                iconColor: MyColors.brownRed, label: "News and Events"),
            Spacer(),
            _pageIndicator(),
            10.horizontalSpace,
          ],
        ),
        10.verticalSpace,
        // CarouselSlider.builder(
        //     itemCount: 5,
        //     itemBuilder: (context, index, index2) => newsEventTile(),
        //     options: CarouselOptions(
        //       height: 265.h,
        //       pageSnapping: false,
        //       scrollDirection: Axis.vertical,
        //     )),
        Obx(
          () => SizedBox(
            height: 265,
            child: controller.announcementList.isEmpty
                ? _emptyWidget()
                : Stack(
                    children: [
                      PageView.builder(
                        controller: controller.pageController,
                        scrollDirection: Axis.vertical,
                        itemCount: controller.announcementList.length,
                        itemBuilder: (context, index) =>
                            newsEventTile(controller.announcementList[index]),
                        onPageChanged: (v) {
                          controller.currentIndex.value = v;
                        },
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: _pageIndicator(),
                      // ),
                    ],
                  ),
          ).skeletonLoading(controller.isEventsLoading.value),
        )
      ],
    );
  }

  Widget newsEventTile(AnnouncementModel announcement) => Container(
        height: 265,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5,
              color: MyColors.brownRed,
            )),
        child: Column(
          children: [
            Container(
              height: 182,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.none,
                    image: AssetImage(controller
                        .getImageFromEventType(announcement.eventType)),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Container(
                    height: 182,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withAlpha(100),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.black26,
                    ),
                    child: Center(
                        child: Row(
                      children: [
                        10.horizontalSpace,
                        // Text(
                        //   "This Month",
                        //   style: GoogleFonts.poppins(
                        //     color: Color(0xffFABB18),
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    )),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          foregroundColor: MyColors.baseBlue,
                          child: CircleAvatar(
                            radius: 21,
                            // backgroundImage: AssetImage(
                            //     "assets/icons/common/.png"),
                            child: Icon(Symbols.person_filled_rounded),
                          ),
                        ),
                        10.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement.employee.capitalize ??
                                  announcement.employee,
                              style: GoogleFonts.poppins(
                                color: MyColors.primaryButtonFGColorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              announcement.designation,
                              style: GoogleFonts.poppins(
                                color: MyColors.primaryButtonFGColorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          announcement.eventType,
                          style: GoogleFonts.poppins(
                            color: MyColors.primaryButtonFGColorWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        // Icon(
                        //   Icons.announcement_outlined,
                        //   color: Colors.white,
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Center(
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    20.horizontalSpace,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          // "DEC",
                          DateUtilsHelper.getShortMonthName(
                                  DateUtilsHelper.convertToIso(
                                      announcement.eventDate))
                              .toUpperCase(),
                          style: GoogleFonts.poppins(
                            height: 1.1,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: MyColors.brownRed,
                          ),
                        ),
                        Text(
                          DateUtilsHelper.getDateNumber(
                              DateUtilsHelper.convertToIso(
                                  announcement.eventDate)),
                          style: GoogleFonts.poppins(
                            height: 1.1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: MyColors.brownRed,
                          ),
                        )
                      ],
                    ),
                    10.horizontalSpace,
                    VerticalDivider(
                      color: MyColors.brownRed,
                      indent: 10,
                      endIndent: 10,
                    ),
                    10.horizontalSpace,
                    SizedBox(
                      width: MediaQuery.of(Get.context!).size.width - 150,
                      height: 70,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.location,
                                size: 15,
                              ),
                              8.horizontalSpace,
                              Text(
                                announcement.location,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          5.verticalSpace,
                          Flexible(
                            child: AutoSizeText(
                              announcement.message,
                              maxFontSize: 10,
                              minFontSize: 8,
                              style: GoogleFonts.poppins(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _pageIndicator() {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: MyColors.PayAzzureColor2,
              // borderRadius: BorderRadius.circular(50),
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(
              "${controller.currentIndex.value}",
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: MyColors.baseGray,
              ),
            )),
          ),
          Text(
            "- ${controller.announcementList.length}",
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: MyColors.primaryActionColorDarkBlue,
            ),
          )
        ],
      ),
    );
    // return Container(
    //   width: 50,
    //   height: 50,
    //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
    //   margin: EdgeInsets.only(right: 20),
    //   decoration: BoxDecoration(
    //     color: MyColors.primaryButtonFGColorWhite.withAlpha(50),
    //     borderRadius: BorderRadius.circular(50),
    //   ),
    // );
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
    //   margin: EdgeInsets.only(right: 20),
    //   decoration: BoxDecoration(
    //     color: MyColors.primaryButtonFGColorWhite.withAlpha(50),
    //     borderRadius: BorderRadius.circular(50),
    //   ),
    //   child: ListView(
    //     // mainAxisSize: MainAxisSize.min,
    //     shrinkWrap: true,
    //     children: List.generate(controller.announcementList.length,
    //         (index) => _indicatorWidget(index: index)),
    //   ),

    // child: Obx(
    //   () => FlipInX(
    //     key: ValueKey("${controller.currentIndex.value}-value"),
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeIn,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Container(
    //           width: 5.w,
    //           height: 5.w,
    //           margin: EdgeInsets.symmetric(vertical: 5.w),
    //           decoration: BoxDecoration(
    //             // shape: BoxShape.circle,
    //             borderRadius: BorderRadius.circular(100),
    //             color: AppColors.primaryButtonFGColorWhite,
    //           ),
    //         ),
    //         Container(
    //           width: 17.w,
    //           height: 17.w,
    //           decoration: BoxDecoration(
    //             // shape: BoxShape.circle,
    //             borderRadius: BorderRadius.circular(100),
    //             color: AppColors.primaryButtonFGColorWhite,
    //           ),
    //           child: Center(
    //             child: Text(
    //               (controller.currentIndex.value + 1).toString(),
    //               style: AppStyles.appBarTitleTextStyle.copyWith(
    //                   fontSize: 7.sp,
    //                   color: AppColors.baseRed,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           width: 5.w,
    //           height: 5.w,
    //           margin: EdgeInsets.symmetric(vertical: 5.w),
    //           decoration: BoxDecoration(
    //             // shape: BoxShape.circle,
    //             borderRadius: BorderRadius.circular(100),
    //             color: AppColors.primaryButtonFGColorWhite,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
    // );
  }

  _indicatorWidget({required int index}) {
    return Obx(
      () {
        var isActive = index == controller.currentIndex.value;
        double height = isActive ? 12 : 5;
        var margin = isActive ? 3.5 : 2.5;
        var color =
            isActive ? MyColors.baseRed : MyColors.primaryButtonFGColorWhite;
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          width: 5,
          height: height,
          margin: EdgeInsets.symmetric(vertical: margin),
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(100),
            color: color,
          ),
        );
      },
    );
  }

  Widget _emptyWidget() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.grey1.withAlpha(50),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
          child: EmptyStateWidget(
        label: "No events found for this month",
      )),
    );
  }
}
