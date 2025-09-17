import 'dart:math';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';

import '../../../../../Utils/LogServices/LogService.dart';
import '../../MenuHomePagePage/Models/CardModel.dart';
import '../../MenuHomePagePage/Widgets/WidgetOptionListTile.dart';
import 'WidgetMenuFolderPanelBottomSheet.dart';

class QuickAccessTileWidget extends StatelessWidget {
  QuickAccessTileWidget(this.cardModel, {super.key});
  final MenuHomePageController menuHomePageController = Get.find();
  final CardModel cardModel;
  @override
  Widget build(BuildContext context) {
    final double baseHeight = MediaQuery.of(context).size.height * .25;
    // final double baseWidth = MediaQuery.of(context).size.width - 30;
    // Generate a random color
    var colorList = [
      HexColor("#ecf0ff"),
      HexColor("#e5f5fa"),
      HexColor("#ffe5e2"),
      HexColor("#fcf1d5"),
      HexColor("#f6edfe"),
      HexColor("#d9ecef"),
    ];

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                LogService.writeLog(message: "[i] QuickAccess : Open in webview {${cardModel.stransid}");

                menuHomePageController.captionOnTapFunction(cardModel.stransid);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: colorList[Random().nextInt(colorList.length)], // color.withAlpha(30),
                    foregroundColor: Colors.black,
                    radius: baseHeight / 9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: Const.getFullWebUrl("images/homepageicon/") + cardModel.caption.toString() + '.png',
                        errorWidget: (context, url, error) =>
                            Image.network(Const.getFullWebUrl('images/homepageicon/default.png')),
                        errorListener: (e) {
                          LogService.writeLog(
                              message:
                                  "[IMAGE ERROR] \nImageURL: ${Const.getFullWebUrl("images/homepageicon/") + cardModel.caption.toString() + '.png'}\nError: $e");
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: baseHeight / 7,
                      child: Text(
                        cardModel.caption,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          overflow: TextOverflow.fade,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Visibility(
            visible: menuHomePageController.actionData[cardModel.caption] == null && cardModel.moreoption.isEmpty ? false : true,
            child: InkWell(
              onTap: () => showMenuDialog(cardModel),
              child: Icon(Icons.more_vert),
            ),

            // child:
            //     SizedBox(width: 5, height: 5, child: Icon(Icons.more_vert)),
          ),
        ),
      ],
    );

    // return SizedBox(
    //   width: (baseWidth / 4) - 25,
    //   // color: Colors.amber,
    //   child: Stack(
    //     children: [
    //       Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           InkWell(
    //             onTap: () {
    //               menuHomePageController
    //                   .captionOnTapFunction(cardModel.stransid);
    //             },
    //             borderRadius: BorderRadius.circular(100),
    //             child: CircleAvatar(
    //               backgroundColor: colorList[Random()
    //                   .nextInt(colorList.length)], // color.withAlpha(30),
    //               foregroundColor: Colors.black,
    //               radius: baseHeight / 9,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: CachedNetworkImage(
    //                   imageUrl:
    //                       Const.getFullProjectUrl("images/homepageicon/") +
    //                           cardModel.caption.toString() +
    //                           '.png',
    //                   errorWidget: (context, url, error) => Image.network(
    //                       Const.getFullProjectUrl(
    //                           'images/homepageicon/default.png')),
    //                 ),
    //               ), /*Icon(
    //                     Icons.airplane_ticket,
    //                     color: color,
    //                   ),*/
    //             ),
    //           ),
    //           SizedBox(
    //             height: 5,
    //           ),
    //           SizedBox(
    //             height: baseHeight / 7,
    //             child: Text(
    //               cardModel.caption,
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 overflow: TextOverflow.fade,
    //                 fontSize: 12,
    //                 fontWeight: FontWeight.w500,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Positioned(
    //         top: 0,
    //         right: 0,
    //         child: Visibility(
    //           visible: menuHomePageController.actionData[cardModel.caption] ==
    //                       null &&
    //                   cardModel.moreoption.isEmpty
    //               ? false
    //               : true,
    //           child: InkWell(
    //             onTap: () => showMenuDialog(cardModel),
    //             child: Icon(Icons.more_vert),
    //           ),

    //           // child:
    //           //     SizedBox(width: 5, height: 5, child: Icon(Icons.more_vert)),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  showMenuDialog(CardModel cardModel) async {
    //call api if needed
    // if (cardModel.caption.toLowerCase().contains("attendance")) {
    //   await menuHomePageController.getPunchINData();
    // }
    //ends
    List optionLists =
        menuHomePageController.actionData[cardModel.caption] == null ? [] : menuHomePageController.actionData[cardModel.caption];
    if (!optionLists.isEmpty || !cardModel.moreoption.isEmpty) {
      showGeneralDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: Colors.transparent.withOpacity(0.6),
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return Transform.scale(
            scale: animation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  // margin: EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                          child: Center(
                            child: Text(
                              cardModel.caption,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            for (var item in optionLists) WidgetOptionListTile(item),
                          ],
                        ),
                        // ListView.separated(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     itemBuilder: (context, index) {
                        //       return WidgetOptionListTile(optionLists[index], sessionId, webUrl);
                        //     },
                        //     separatorBuilder: (context, index) => Container(),
                        //     itemCount: optionLists.length),
                        Container(
                          height: 90,
                          // decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.grey))),
                          child: cardModel.moreoption.toString() == ""
                              ? null
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: decodeMoreOptopns(cardModel.moreoption),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container();
        },
      );
    } else {
      Get.snackbar("Oops!", "Nothing to Show",
          backgroundColor: Colors.grey,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1));
    }
  }

  decodeMoreOptopns(String moreOptionText) {
    List<Widget> widgeList = [];
    var widget;
    List<String> mainList;
    moreOptionText = moreOptionText.replaceAll("{", "");
    print("moreOptionText: $moreOptionText");
    mainList = moreOptionText.split("}");
    mainList.remove("");
    for (String item in mainList) {
      item = item.trim();
      var stIndex = item.indexOf("\"");
      var endIndex;
      while (stIndex >= 0) {
        endIndex = item.indexOf("\"", stIndex + 1);
        var subStr = item.substring(stIndex + 1, endIndex);
        var newSubStr = subStr.replaceAll(' ', '^');
        item = item.replaceAll(subStr, newSubStr);
        stIndex = item.indexOf("\"", endIndex + 1);
      }
      var singleList = item.split(' ');
      var btnType = "", btnName = "", btnOpen = "", btnexeJs = "";
      btnType = singleList[1];
      //if (singleList.indexOf("button") >= 0) btnType = singleList[singleList.indexOf("button") - 1];
      if (singleList.indexOf("open") >= 0) btnOpen = singleList[singleList.indexOf("open") + 1];
      if (singleList.indexOf("title") >= 0) btnName = singleList[singleList.indexOf("title") + 1];
      if (singleList.indexOf("exejs") >= 0) btnexeJs = singleList[singleList.indexOf("exejs") + 1];

      btnName = btnName.replaceAll('^', ' ');
      btnName = btnName.replaceAll('\"', '');
      btnexeJs = btnexeJs.replaceAll('^', ' ');

      if (btnName != "") {
        // widget = Container();
        if (btnName.toUpperCase() == "PUNCH IN") {
          widget = ElevatedButton(
              style: !menuHomePageController.isShowPunchIn.value
                  ? ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                      backgroundColor: WidgetStateColor.resolveWith((states) => Colors.grey))
                  : ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5))),
              onPressed: menuHomePageController.isShowPunchIn.value
                  ? () {
                      menuHomePageController.onClick_PunchIn();
                    }
                  : null,
              // onPressed: () {
              //   // if (btnOpen != "") Get.back();
              //   // menuHomePageController.openBtnAction(btnType, btnOpen);
              // },
              child: FittedBox(fit: BoxFit.fitWidth, child: Text(btnName)));
        } else {
          if (btnName.toUpperCase() == "PUNCH OUT") {
            widget = ElevatedButton(
                style: !menuHomePageController.isShowPunchOut.value
                    ? ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.grey))
                    : ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5))),
                onPressed: menuHomePageController.isShowPunchOut.value
                    ? () {
                        menuHomePageController.onClick_PunchOut();
                      }
                    : null,
                // onPressed: () {
                //   // if (btnOpen != "") Get.back();
                //   // menuHomePageController.openBtnAction(btnType, btnOpen);
                // },
                child: FittedBox(fit: BoxFit.fitWidth, child: Text(btnName)));
          } else {
            widget = ElevatedButton(
                style: btnOpen == ""
                    ? ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.grey))
                    : ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5))),
                onPressed: () {
                  if (btnOpen != "") Get.back();
                  menuHomePageController.openBtnAction(btnType, btnOpen);
                },
                child: FittedBox(fit: BoxFit.fitWidth, child: Text(btnName)));
          }
        }

        widgeList.add(widget);
        widgeList.add(SizedBox(width: 10));
      }
    }
    return widgeList;
  }
}

//-------------------------------------------->
class QuickAccessTileMoreWidget extends StatelessWidget {
  const QuickAccessTileMoreWidget(
    this.listOfOptionCards, {
    super.key,
  });
  final RxList listOfOptionCards;
  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .25;
    List<Widget> baseItems = List.generate(listOfOptionCards.length, (index) => QuickAccessTileWidget(listOfOptionCards[index]));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Get.bottomSheet(
              WidgetMenuFolderPanelBottomSheet(
                baseItems: baseItems,
              ),
              isScrollControlled: true,
            );
          },
          borderRadius: BorderRadius.circular(100),
          splashColor: Colors.white60,
          child: CircleAvatar(
            foregroundColor: Colors.white,
            backgroundColor: MyColors.PayAzzureColor2,
            radius: baseSize / 9,
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: SizedBox(
            height: baseSize / 7,
            child: Text(
              "More",
              style: TextStyle(
                overflow: TextOverflow.fade,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );

    // return SizedBox(
    //   width: (basewidth / 4) - 30,
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       InkWell(
    //         onTap: () {
    //           Get.bottomSheet(WidgetMenuFolderPanelBottomSheet(
    //             baseItems: baseItems,
    //           ));
    //         },
    //         borderRadius: BorderRadius.circular(100),
    //         splashColor: Colors.white60,
    //         child: CircleAvatar(
    //           foregroundColor: Colors.white,
    //           backgroundColor: Colors.black87,
    //           radius: baseSize / 9,
    //           child: Icon(
    //             Icons.keyboard_arrow_down_rounded,
    //             size: 30,
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 5,
    //       ),
    //       Text(
    //         "More",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           fontSize: 12,
    //           fontWeight: FontWeight.w500,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

//-------------------------------------------->
class QuickAccessTileEmptyeWidget extends StatelessWidget {
  const QuickAccessTileEmptyeWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: baseSize / 9,
          ),
        ),
        SizedBox(
          height: (baseSize / 7) + 5,
        ),
      ],
    );
  }
}
