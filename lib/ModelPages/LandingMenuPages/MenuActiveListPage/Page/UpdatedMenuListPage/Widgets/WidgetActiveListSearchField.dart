import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../Constants/MyColors.dart';
import '../../../Controllers/UpdatedActiveTaskListController/ActiveTaskListController.dart';
import 'package:get/get.dart';

class WidgetActiveListSearchField extends StatelessWidget {
  const WidgetActiveListSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final ActiveTaskListController activeTaskListController = Get.find();
    return Expanded(
      child: Obx(
        () => TextField(
          controller: activeTaskListController.searchTextController,
          onChanged: activeTaskListController.searchTask,
          decoration: InputDecoration(
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: MyColors.grey9,
                size: 24,
              ),
              suffixIcon: activeTaskListController.taskSearchText.value.isNotEmpty
                  ? InkWell(
                      onTap: activeTaskListController.clearSearch,
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: MyColors.baseRed.withAlpha(150),
                        size: 24,
                      ),
                    )
                  : null,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: "Search...",
              hintStyle: GoogleFonts.poppins(
                color: MyColors.grey6,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 1, color: Color(0xffD0D0D0)))),
        ),
      ),
    );
  }
}
