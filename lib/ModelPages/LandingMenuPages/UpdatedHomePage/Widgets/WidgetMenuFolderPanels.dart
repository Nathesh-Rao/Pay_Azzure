import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../MenuHomePagePage/Controllers/MenuHomePageController.dart';

class WidgetMenuFolderPanels extends StatelessWidget {
  WidgetMenuFolderPanels({super.key});

  final MenuHomePageController menuHomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: menuHomePageController.list_menuFolderData.length > 0 ? true : false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: menuHomePageController.getMenuFolderPanelWidgetList(),
          ),
        ),
      ),
    );
  }
}
