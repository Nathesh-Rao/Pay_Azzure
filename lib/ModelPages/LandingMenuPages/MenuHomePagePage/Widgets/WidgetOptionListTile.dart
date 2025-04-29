import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/CardOptionModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetOptionListTile extends StatelessWidget {
  final CardOptionModel cardOptionModel;

  WidgetOptionListTile(CardOptionModel this.cardOptionModel, {super.key});

  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Visibility(
                visible: cardOptionModel.cardicon.toString() == "" ? false : true,
                child: Icon(showIcons(cardOptionModel.cardicon.toString()))),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    cardOptionModel.caption,
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 14, color: HexColor("#444444"))),
                  ),
                ),
              ),
            ),
            shouldShowLinkText(cardOptionModel)
                ? Expanded(
                    child: TextButton(
                        onPressed: () {
                          Get.back();
                          menuHomePageController.openBtnAction("button", cardOptionModel.link);
                        },
                        child: Text(
                          cardOptionModel.text,
                        )),
                  )
                : Expanded(
                    child: Center(
                      child: Text(cardOptionModel.text),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  shouldShowLinkText(CardOptionModel cardOptionModel) {
    if (cardOptionModel.link.startsWith('h')) {
      return true;
    } else {
      if (cardOptionModel.link.startsWith('i')) {
        return true;
      } else {
        if (cardOptionModel.link.startsWith('t')) {
          return true;
        } else
          return false;
      }
    }
  }

  IconData? showIcons(String cardicon) {
    switch (cardicon) {
      case "access_time":
        return Icons.access_time;
      case "addchart":
        return Icons.addchart;
      default:
        return Icons.access_time;
    }
  }
}
