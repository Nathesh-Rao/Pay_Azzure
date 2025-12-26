import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/app_styles.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'leave_progress_widget.dart';

class LeaveDashBoardLeaveCountWidget extends GetView<PayAndLeaveController> {
  const LeaveDashBoardLeaveCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Obx(
        () => controller.leaveDetailsList.isEmpty
            ? _emptyWidget()
            : Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: MyColors.secondaryButtonBorderColorGrey,
                    )),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.info_rounded,
                            size: 15,
                            color: MyColors.leaveWidgetColorSandal,
                          ),
                        ),
                      ],
                    ),
                    LeaveProgressWidget(),
                    Text(
                      "Leave balance for month",
                      style: AppStyles.leaveActivityMainStyle
                          .copyWith(fontSize: 7),
                    ),
                    Text(
                      DateUtilsHelper.getShortMonthName(
                          DateTime.now().toString()),
                      style: AppStyles.leaveActivityMainStyle
                          .copyWith(fontSize: 14),
                    ),
                    10.verticalSpace,
                  ],
                ),
              ).skeletonLoading((controller.isLeaveDetailsLoading.value ||
                controller.isLeaveOverviewLoading.value)),
      ),
    );
  }

  Widget _emptyWidget() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MyColors.baseRed.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: MyColors.baseRed),
            Text(
              "no leave details found for user ${globalVariableController.USER_NAME}",
              textAlign: TextAlign.center,
              style: AppStyles.actionButtonStyle
                  .copyWith(color: MyColors.baseRed, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
