import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Controllers/UpdatedActiveTaskListController/ActiveTaskListController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/UpdatedMenuListPage/Widgets/WidgetActiveListBulkApprovalDialog.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuActiveListPage/Page/UpdatedMenuListPage/Widgets/WidgetActiveListSearchField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Controllers/CompletedListController.dart';
import '../../Controllers/PendingListController.dart';
import 'Widgets/WidgetActiveListTile.dart';

class ActiveListPage extends StatelessWidget {
  ActiveListPage({super.key});
  ActiveTaskListController activeTaskListController = Get.find();
  final PendingListController pendingListController = Get.put(PendingListController());
  final CompletedListController completedListController = Get.put(CompletedListController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activeTaskListController.init();
    });
    return Scaffold(
      backgroundColor: MyColors.grey2,
      floatingActionButton: _floatingActionButton(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10, left: 10.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetActiveListSearchField(),
                Obx(() => _iconButtons(Icons.filter_alt, activeTaskListController.openFilterPrompt,
                    isActive: activeTaskListController.isFilterOn.value)),
                // _iconButtons(Icons.select_all_rounded, () {}),
                _iconButtons(Icons.done_all, () async {
                  pendingListController.bulkCommentController.clear();
                  await pendingListController.getBulkApprovalCount();
                  Get.dialog(WidgetActiveListBulkApprovalDialog());
                }),
              ],
            ),
          ),
          Obx(
            () => activeTaskListController.isListLoading.value
                ? LinearProgressIndicator(
                    minHeight: 1,
                    borderRadius: BorderRadius.circular(100),
                  )
                : SizedBox.shrink(),
          ),
          Expanded(
              child: Obx(
            () => Visibility(
              visible: activeTaskListController.activeTaskMap.keys.isNotEmpty,
              child: ListView(
                controller: activeTaskListController.taskListScrollController,
                // padding: EdgeInsets.only(top: 20),
                physics: BouncingScrollPhysics(),
                children: List.generate(
                  activeTaskListController.activeTaskMap.keys.length,
                  (index) {
                    var _key = activeTaskListController.activeTaskMap.keys.toList()[index];
                    var _currentList = activeTaskListController.activeTaskMap[_key];

                    return ExpandedTile(
                      contentseparator: 0,
                      theme: ExpandedTileThemeData(
                        titlePadding: EdgeInsets.all(0),
                        contentPadding: EdgeInsets.all(0),
                        headerColor: MyColors.grey2,
                        headerSplashColor: MyColors.grey1,
                        contentBackgroundColor: Colors.white,
                        contentSeparatorColor: Colors.white,
                      ),
                      controller: ExpandedTileController(isExpanded: true),
                      title: Text(
                        _key.toString(),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      content: Column(
                        children: List.generate(_currentList!.length, (i) => WidgetActiveLisTile(model: _currentList[i])),
                      ),
                      onTap: () {
                        // debugPrint("tapped!!");
                      },
                      onLongTap: () {
                        // debugPrint("long tapped!!");
                      },
                    );
                  },
                ),
              ),
            ),
          )),
          _bottomTextInfoWidget(),
        ],
      ),
    );
  }

  Widget _iconButtons(IconData icon, Function() onTap, {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          border: isActive ? Border.all(color: MyColors.blue9) : null,
          color: isActive ? null : Color(0xffF1F1F1).darken(0.05),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? MyColors.blue9 : MyColors.grey9,
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return Obx(
      () => activeTaskListController.activeTaskList.isEmpty
          ? SizedBox.shrink()
          : FloatingActionButton(
              backgroundColor: MyColors.blue9,
              foregroundColor: MyColors.white1,
              child: activeTaskListController.isListLoading.value
                  ? Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: MyColors.white1,
                            strokeWidth: 2,
                            strokeCap: StrokeCap.round,
                          )),
                    )
                  : Icon(activeTaskListController.isRefreshable.value ? Icons.refresh_rounded : Icons.arrow_upward_rounded),
              onPressed: activeTaskListController.refreshList,
            ),
    );
  }

  Widget _bottomTextInfoWidget() {
    return Obx(() => activeTaskListController.showFetchInfo.value
        ? Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "No more records to display",
              style: GoogleFonts.poppins(
                color: MyColors.baseRed,
              ),
            ),
          )
        : SizedBox.shrink());
  }
}
