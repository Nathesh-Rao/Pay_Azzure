import 'package:flutter/material.dart';
import 'dart:math';

class WidgetKPIPanelItem extends StatelessWidget {
  const WidgetKPIPanelItem({super.key, required this.index});
//for populating the pseudodata, index is accessing.
  final int index;
  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .15;
// pseudo data--------->
    List<String> cardNames = [
      "KPI Users",
      "KPI 16/10",
      "KPI CARD_Release13",
      "KPI_Release14",
      "actors",
    ];
    List<String> cardData = [
      "50",
      "8",
      "erertetertre",
      "amit",
      "1",
    ];
    List<int> colors = [
      0xff3764FC,
      0xffed5888,
      0xff9469e5,
      0xffef9a97,
      0xffeeac44,
    ];
//---------------------->

    return GestureDetector(
      onTap: () {
        //---
      },
      child: Container(
        height: baseSize,
        width: baseSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(colors[index]),
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
                      Icons.person,
                      size: 20,
                      color: Color(colors[index]),
                    ),
                    radius: 15,
                  ),
                  Spacer(),
                  Text(
                    cardNames[index],
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
                    cardData[index],
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
