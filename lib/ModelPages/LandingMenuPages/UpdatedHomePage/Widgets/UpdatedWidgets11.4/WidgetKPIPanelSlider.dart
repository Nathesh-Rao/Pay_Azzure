import 'dart:math';

import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/UpdatedHomePage/Models/KPIListCardModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../Constants/Routes.dart';
import '../../../../../../Constants/Const.dart';
import '../../../../../../Utils/LogServices/LogService.dart';
import '../../../../../../Utils/ServerConnections/InternetConnectivity.dart';
import '../../Models/UpdatedHomeCardDataModel.dart';

class WidgetKPIPanelSlider extends StatelessWidget {
  WidgetKPIPanelSlider({super.key});
  final MenuHomePageController menuHomePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .17;
    List kpicardData = [];
    return Obx(
      () {
        if (menuHomePageController.kpiSliderCardData.isNotEmpty) {
          var kpiList = menuHomePageController.kpiSliderCardData.first;

          kpicardData = kpiList.carddata.map((e) => KpiListModel.fromJson(e)).toList();
        }
        // LogService.writeLog(message: "kpiList => ${kpicardData.length}");

        return Visibility(
            visible: menuHomePageController.kpiSliderCardData.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: SizedBox(
                height: baseSize,
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: kpicardData.length,
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                    itemBuilder: (context, index) => WidgetKPIPanelSliderItem(
                          index: index,
                          cardData: kpicardData[index],
                        )),
              ),
            ));
      },
    );
  }
}

class WidgetKPIPanelSlider1 extends StatelessWidget {
  WidgetKPIPanelSlider1({super.key, required this.cardData});
  final List cardData;
  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .17;
    List kpicardData = [];
    return Obx(
      () {
        if (cardData.isNotEmpty) {
          kpicardData = cardData.map((e) => KpiListModel.fromJson(e)).toList();
        }
        // LogService.writeLog(message: "kpiList => ${kpicardData.length}");

        return Visibility(
            visible: kpicardData.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: SizedBox(
                height: baseSize,
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: kpicardData.length,
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                    itemBuilder: (context, index) => WidgetKPIPanelSliderItem(
                          index: index,
                          cardData: kpicardData[index],
                        )),
              ),
            ));
      },
    );
  }
}

// import 'package:flutter/material.dart';

class WidgetKPIPanelSliderItem extends StatelessWidget {
  WidgetKPIPanelSliderItem({
    super.key,
    required this.index,
    required this.cardData,
  });
  final MenuHomePageController menuHomePageController = Get.find();
  final InternetConnectivity internetConnectivity = Get.find();
//for populating the pseudodata, index is accessing.
  final int index;
  final KpiListModel cardData;
  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .15;
// pseudo data--------->
//     List<String> cardNames = [
//       "KPI Users",
//       "KPI 16/10",
//       "KPI CARD_Release13",
//       "KPI_Release14",
//       "actors",
//     ];
//     List<String> cardData = [
//       "50",
//       "8",
//       "erertetertre",
//       "amit",
//       "1",
//     ];
    List<int> colors = [
      0xff3764FC,
      0xffed5888,
      0xff9469e5,
      0xffef9a97,
      0xffeeac44,
    ];
//---------------------->
    var color = Color(colors[Random().nextInt(colors.length)]);

    return GestureDetector(
      onTap: () {
        // menuHomePageController.
        menuHomePageController.captionOnTapFunctionNew(cardData.link);
      },
      child: Container(
        height: baseSize,
        width: baseSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Stack(
          children: [
            _widgetKPIItemBGElement(context),
            _widgetKPIItemBGElement(context, right: -10, top: 40),
            _widgetKPIItemBGElement(context, right: 30, top: -15),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.ac_unit,
                      size: 20,
                      color: color,
                    ),
                    radius: 15,
                  ),
                  Spacer(),
                  Text(
                    "${cardData.name}",
                    // cardNames[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${cardData.value}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Faded circle widget------------------------------------>
  _widgetKPIItemBGElement(BuildContext context, {double right = -20, double top = -15}) {
    double randomDouble = 0.3 + (0.9 - 0.3) * Random().nextDouble();
    final double baseSize = (MediaQuery.of(context).size.height * .15) / 5 + (randomDouble * 10);
    return Positioned(
      right: right,
      top: top,
      child: CircleAvatar(
        radius: baseSize,
        backgroundColor: Colors.white12,
      ),
    );
  }
}
