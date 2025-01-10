import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Models/MenuFolderModel.dart';
import 'package:flutter/material.dart';

import '../../../../../Constants/MyColors.dart';
import 'WidgetMenuFolderPanelInnerItem.dart';

class WidgetMenuFolderPanelItem extends StatelessWidget {
  const WidgetMenuFolderPanelItem({super.key, required this.panelItems, required this.keyname});

  final List<MenuFolderModel> panelItems;
  final String keyname;

  @override
  Widget build(BuildContext context) {
    final double baseSize = MediaQuery.of(context).size.height * .25;

    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            keyname,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.zero,
            elevation: 2,
            shadowColor: MyColors.color_grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // color: Color(0xffeeeff9),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(15),
              height: panelItems.length > 4 ? baseSize : baseSize / 2,
              width: double.infinity,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                children: generateItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  generateItems() {
    List<Widget> items = List.generate(panelItems.length, (index) => WidgetMenuFolderPanelInnerItem(item: panelItems[index]));

    if (items.length >= 8) {
      items = items.sublist(0, 7);
      items.add(WidgetMenuFolderPanelMoreWidgetItem(
        items: panelItems,
      ));
    } else {
      int itemsToAdd = 8 - items.length;

      items.addAll(
          List.filled(itemsToAdd, WidgetMenuFolderPanelEmptyWidgetItem()));
    }

    return items;
  }
}
