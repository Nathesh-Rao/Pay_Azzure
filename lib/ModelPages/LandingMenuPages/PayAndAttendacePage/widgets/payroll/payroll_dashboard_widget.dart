import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/Routes.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/widgets/icon_label_widget.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:axpertflutter/Utils/string_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/PayAndLeaveController.dart';
import '../../models/payroll_overview_model.dart';

class PayRollDashBoardWidget extends GetView<PayAndLeaveController> {
  const PayRollDashBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPayrollOverviewDetails();
    });

    return Column(
      children: [
        IconLabelWidget(iconColor: MyColors.maroon, label: "Payslip"),
        10.verticalSpace,
        Obx(
          () => InkWell(
            onTap: () {
              Get.toNamed(Routes.payRollDetails);
            },
            child: Container(
              width: double.infinity,
              height: 202,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.bottomCenter,
                      scale: 2,
                      image: AssetImage("assets/images/reciept.png")),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MyColors.secondaryButtonBorderColorGrey,
                  )),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Net Pay",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          onTap: controller.isAmountVisible.toggle,
                          child: Text(
                            controller.isAmountVisible.value
                                ? "₹${controller.netpay}"
                                // : StringUtils.maskAmount("₹${controller.netpay}"),
                                : "₹********",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff282D46),
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            // padding: EdgeInsets.symmetric(vertical: 15.h),
                            children: List.generate(
                                controller.payBreakupList.length,
                                (index) => _breakTile(
                                    controller.payBreakupList[index])),
                          ),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 5,
                            centerSpaceRadius: 40,
                            startDegreeOffset: 10,
                            sections: List.generate(
                                controller.payDivisionsValue.length,
                                (index) => _pieCrumbs(
                                    controller.payDivisionsValue[index])),
                          ),
                        ),
                        Align(
                          child: Text(
                            // DateUtilsHelper.getShortMonthName(globalVariableController
                            //     .currentEmployeeData!.arvPayperiodc),

                            globalVariableController
                                .currentEmployeeData!.arvPayperiodc
                                .split(" ")
                                .join("\n"),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              // color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ).skeletonLoading(controller.payrollOverviewLoading.value),
          ),
        ),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconLabelWidget(iconColor: MyColors.maroon, label: "Payslip"),
        10.verticalSpace,
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.payRollDetails);
          },
          child: Obx(
            () => Visibility(
              visible: controller.payBreakupList.isNotEmpty,
              child: Container(
                width: double.infinity,
                height: 202,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: MyColors.secondaryButtonBorderColorGrey,
                    )),
                child: Stack(
                  children: [
                    Positioned(
                        bottom: 0,
                        left: 110,
                        child: Image.asset(
                          "assets/images/reciept.png",
                          width: 80,
                        )),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding:
                              EdgeInsets.only(top: 14, bottom: 14, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Net Pay",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                controller.isAmountVisible.value
                                    ? "₹${controller.netpay}"
                                    : StringUtils.maskAmount(
                                        "₹${controller.netpay}"),
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff282D46),
                                ),
                              ),
                              15.verticalSpace,
                              Expanded(
                                  child: Obx(
                                () => ListView(
                                  shrinkWrap: true,
                                  // padding: EdgeInsets.symmetric(vertical: 15.h),
                                  children: List.generate(
                                      controller.payBreakupList.length,
                                      (index) => _breakTile(
                                          controller.payBreakupList[index])),
                                ),
                              )),
                              15.verticalSpace,
                              Text(
                                "Get Payslip",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        )),
                        Expanded(
                            child: SizedBox(
                          child: Obx(
                            () => SizedBox(
                              height: 145,
                              width: 145,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sectionsSpace: 5,
                                      centerSpaceRadius: 50,
                                      startDegreeOffset: 10,
                                      sections: List.generate(
                                          controller.payDivisionsValue.length,
                                          (index) => _pieCrumbs(controller
                                              .payDivisionsValue[index])),
                                    ),
                                  ),
                                  Text(
                                    DateUtilsHelper.getShortMonthName(
                                        globalVariableController
                                            .currentEmployeeData!
                                            .arvPayperiodc),
                                    style: GoogleFonts.poppins(
                                      // color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ).skeletonLoading(controller.payrollOverviewLoading.value),
            ),
          ),
        )
      ],
    );
  }

  PieChartSectionData _pieCrumbs(double value) {
    return PieChartSectionData(
      color: MyColors.getNextColor(),
      value: value,
      showTitle: false,
      radius: 20,
    );
  }

  Widget _breakTile(PayBreakup pay) {
    var isDeduct = pay.addordeduct.toLowerCase().contains("dedu");

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: isDeduct ? MyColors.red : Color(0xff0271F2),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pay.name.split(" ")[0],
                style: GoogleFonts.poppins(
                  // color: Colors.white,
                  fontWeight: FontWeight.w500,

                  fontSize: 10,
                ),
              ),
              Text(
                "${isDeduct ? "-" : ""}" + "${pay.amount.toString()}",
                style: GoogleFonts.poppins(
                  // color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
