import 'dart:math';

import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetKPIPanelItem.dart';
import 'package:flutter/material.dart';

class Widgetkpipanel extends StatelessWidget {
  const Widgetkpipanel({super.key});

  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .15;

    return Visibility(
        child: Padding(
      padding: EdgeInsets.only(top: 5),
      child: SizedBox(
        height: baseSize,
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 15),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
            itemBuilder: (context, index) => WidgetKPIPanelItem(index: index)),
      ),
    ));
  }
}
