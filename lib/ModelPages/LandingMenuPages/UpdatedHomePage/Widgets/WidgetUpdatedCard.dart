import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/CardModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Widgets/WidgetOptionListTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetUpdatedCards extends StatelessWidget {
  WidgetUpdatedCards(this.cardModel, {super.key});
  final CardModel cardModel;
  final AppStorage appStorage = AppStorage();
  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 10),
      // padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey.shade200.withOpacity(0.5))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: Colors.blue.shade900.withOpacity(0.1))),
                padding: EdgeInsets.all(5),
                child: CachedNetworkImage(
                  imageUrl: Const.getFullProjectUrl("images/homepageicon/") + cardModel.caption + '.png',
                  errorWidget: (context, url, error) =>
                      Image.network(Const.getFullProjectUrl('images/homepageicon/default.png')),
                  width: 40,
                ),
                // child: Icon(
                //   Icons.calendar_month,
                //   color: MyColors.blue2,
                //   size: 40,
                // ),
              ),
              Text(
                cardModel.caption,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: HexColor("3E4153"))),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                cardModel.pagecaption.toString(),
                style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12, color: HexColor("3E4153").withOpacity(0.7))),
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 5, right: 5),
              child: Visibility(
                visible:
                    menuHomePageController.actionData[cardModel.caption] == null && cardModel.moreoption.isEmpty ? false : true,
                child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => showMenuDialog(cardModel),
                      icon: Icon(Icons.more_vert),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
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
      // Get.dialog(
      //     Dialog(
      //       backgroundColor: Colors.transparent,
      //       child: SingleChildScrollView(
      //         child: Container(
      //           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      //           // margin: EdgeInsets.only(left: 10, right: 10),
      //           child: Padding(
      //             padding: const EdgeInsets.only(left: 5, right: 5),
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Container(
      //                   height: 20,
      //                 ),
      //                 Container(
      //                   height: 50,
      //                   decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      //                   child: Center(
      //                     child: Text(
      //                       cardModel.caption,
      //                       style: TextStyle(fontSize: 25),
      //                     ),
      //                   ),
      //                 ),
      //                 Column(
      //                   children: [
      //                     for (var item in optionLists) WidgetOptionListTile(item),
      //                   ],
      //                 ),
      //                 // ListView.separated(
      //                 //     physics: NeverScrollableScrollPhysics(),
      //                 //     itemBuilder: (context, index) {
      //                 //       return WidgetOptionListTile(optionLists[index], sessionId, webUrl);
      //                 //     },
      //                 //     separatorBuilder: (context, index) => Container(),
      //                 //     itemCount: optionLists.length),
      //                 Container(
      //                   height: 90,
      //                   // decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.grey))),
      //                   child: cardModel.moreoption.toString() == ""
      //                       ? null
      //                       : SingleChildScrollView(
      //                           scrollDirection: Axis.horizontal,
      //                           child: Padding(
      //                             padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      //                             child: Row(
      //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                               children: decodeMoreOptopns(cardModel.moreoption),
      //                             ),
      //                           ),
      //                         ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     transitionCurve: Curves.elasticOut,
      //     transitionDuration: Duration(milliseconds: 300));
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
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey))
                  : ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5))),
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
                        padding: MaterialStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey))
                    : ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5))),
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
                        padding: MaterialStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey))
                    : ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5))),
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
