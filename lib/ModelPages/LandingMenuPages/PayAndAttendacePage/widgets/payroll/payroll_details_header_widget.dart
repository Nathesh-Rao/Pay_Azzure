import 'package:axpertflutter/Constants/CommonMethods.dart';
import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/controller/PayAndLeaveController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/PayAndAttendacePage/models/payroll_overview_model.dart';
import 'package:axpertflutter/Utils/date_utils.dart';
import 'package:axpertflutter/Utils/string_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PayrollDetailsHeaderWidget extends GetView<PayAndLeaveController> {
  const PayrollDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 335,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3334A0),
            Color(0xFF12133A),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 15),
            child: Row(
              children: [
                Text(
                  "Net Pay",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          // Spacer(),
          Obx(
            () => Row(
              children: [
                20.horizontalSpace,
                Text(
                  controller.isAmountVisible.value
                      ? "₹${controller.netpay}"
                      : StringUtils.maskAmount("₹${controller.netpay}"),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Obx(
                  () => GestureDetector(
                    onTap: controller.isAmountVisible.toggle,
                    child: Icon(
                      controller.isAmountVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white30,
                    ),
                  ),
                ),
                20.horizontalSpace,
              ],
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              20.horizontalSpace,
              Text(
                "June 25",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 125,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 30,
                                sections: List.generate(
                                    controller.payDivisionsValue.length,
                                    (index) => _pieCrumbs(
                                        controller.payDivisionsValue[index])),
                              ),
                            ),
                            Text(
                              // DateUtilsHelper.getShortMonthName(
                              //     globalVariableController
                              //         .currentEmployeeData!.arvPayperiodc),
                              globalVariableController
                                  .currentEmployeeData!.arvPayperiodc
                                  .split(" ")[0]
                                  .toUpperCase(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 6,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Obx(
                          // () => Wrap(
                          //   spacing: 20,
                          //   runSpacing: 20,
                          //   children: List.generate(
                          //       controller.payBreakupList.length,
                          //       (index) =>
                          //           _breakTile(controller.payBreakupList[index])),
                          // ),

                          () => GridView.builder(
                              itemCount: controller.payBreakupList.length,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7, crossAxisCount: 2),
                              itemBuilder: (context, index) => _breakTile(
                                  controller.payBreakupList[index]))),
                    )),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              20.horizontalSpace,
              _actionButton(label: "Payslip", icon: Icons.download),
              // 20.horizontalSpace,
              // _actionButton(label: "Form 16", icon: Icons.download),
              // 20.horizontalSpace,
              // _actionButton(label: "{action}", icon: Icons.download),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _actionButton({required String label, required IconData icon}) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(
              icon,
              size: 15,
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  PieChartSectionData _pieCrumbs(double value) {
    return PieChartSectionData(
      color: MyColors.getNextColor(),
      value: value,
      showTitle: false,
      radius: 20,
    );
  }

  Widget _breakTile1(PayBreakup leave) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Icon(
          Icons.circle,
          size: 16,
          color: Color(0xff0271F2),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leave.name.split(" ")[0],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            Text(
              leave.amount.toString(),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
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
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
              Text(
                "${isDeduct ? "-" : ""}" + "${pay.amount.toString()}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
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
