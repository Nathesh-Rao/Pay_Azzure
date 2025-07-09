import 'dart:math';

import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/MenuFolderModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../Constants/const.dart';
import '../../../../../Utils/LogServices/LogService.dart';

import '../../MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'WidgetMenuFolderPanelBottomSheet.dart';

class WidgetMenuFolderPanelInnerItem extends StatelessWidget {
  WidgetMenuFolderPanelInnerItem({super.key, required this.item, this.isFromBottomSheet = false});

  final MenuHomePageController menuHomePageController = Get.find();
  final MenuFolderModel item;
  final bool isFromBottomSheet;

  @override
  Widget build(BuildContext context) {
    final double baseHeight = MediaQuery.of(context).size.height * .25;
    final double baseWidth = MediaQuery.of(context).size.width - 30;
    // Generate a random color
    var colorList = [
      HexColor("#ecf0ff"),
      HexColor("#e5f5fa"),
      HexColor("#ffe5e2"),
      HexColor("#fcf1d5"),
      HexColor("#f6edfe"),
      HexColor("#d9ecef"),
    ];

    return InkWell(
        onTap: () {
          if (isFromBottomSheet) Get.back();
          menuHomePageController
              .captionOnTapFunction(item.target!.substring(item.target!.lastIndexOf('=') + 1, item.target.toString().length));
        },
        child: SizedBox(
          width: (baseWidth / 4) - 30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: colorList[Random().nextInt(colorList.length)], // color.withAlpha(30),
                foregroundColor: Colors.black,
                radius: baseHeight / 9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: Const.getFullWebUrl("images/homepageicon/") + item.caption.toString() + '.png',
                    errorWidget: (context, url, error) =>
                        Image.network(Const.getFullWebUrl('images/homepageicon/default.png')),
                  ),
                ), /*Icon(
                Icons.airplane_ticket,
                color: color,
              ),*/
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: baseHeight / 7,
                child: Text(
                  item.caption.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    overflow: TextOverflow.fade,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

//-------------------------------------------->
class WidgetMenuFolderPanelMoreWidgetItem extends StatelessWidget {
  const WidgetMenuFolderPanelMoreWidgetItem({super.key, required this.items});

  final List<MenuFolderModel> items;

  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .25;

    final double basewidth = MediaQuery.of(context).size.width - 30;
    List<Widget> baseItems = List.generate(
        items.length,
        (index) => WidgetMenuFolderPanelInnerItem(
              item: items[index],
              isFromBottomSheet: true,
            ));
    return SizedBox(
      width: (basewidth / 4) - 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              backgroundColor: Colors.black87,
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
          Text(
            "More",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

//-------------------------------------------->
class WidgetMenuFolderPanelEmptyWidgetItem extends StatelessWidget {
  const WidgetMenuFolderPanelEmptyWidgetItem({super.key});
  @override
  Widget build(BuildContext context) {
    final double basewidth = MediaQuery.of(context).size.width - 30;

    return SizedBox(
      width: (basewidth / 4) - 30,
    );
  }
}
