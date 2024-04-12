import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Controllers/MenuDashboaardController.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Widgets/WidgetCharts.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetNoDataFound.dart';
import 'package:axpertflutter/ModelPages/LandingPage/Widgets/WidgetSlidingNotification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuDashboardPage extends StatelessWidget {
  MenuDashboardPage({super.key});
  final MenuDashboardController menuDashboardController = Get.put(MenuDashboardController());
  final index = 2;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(visible: false, child: WidgetSlidingNotificationPanel()),
        SizedBox(height: 5),
        Visibility(visible: menuDashboardController.chartList.length == 0 ? true : false, child: WidgetNoDataFound()),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              itemCount: menuDashboardController.chartList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 30),
              itemBuilder: (context, index) {
                return WidgetCharts(menuDashboardController.chartList[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

/*

Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
                  child: Theme(
                    data: ThemeData().copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(menuDashboardController.chartList[index].cardname,
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('495057')))),
                      children: [
                        SizedBox(height: 3),
                        Container(height: 1, color: Colors.grey.withOpacity(0.4)),
                        Container(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),

                            // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                            legend: Legend(
                                isVisible: true, isResponsive: true, toggleSeriesVisibility: true, position: LegendPosition.top),
                            series: <ChartSeries<dynamic, String>>[
                              ColumnSeries(
                                  dataSource: menuDashboardController.chartList[index].dataList,
                                  xValueMapper: (datum, index) => datum.x_axis,
                                  yValueMapper: (datum, index) => double.parse(datum.value),
                                  dataLabelSettings: DataLabelSettings(isVisible: true))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
                  child: Theme(
                    data: ThemeData().copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text("Chart Title",
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('495057')))),
                      children: [
                        SizedBox(height: 3),
                        Container(height: 1, color: Colors.grey.withOpacity(0.4)),
                        Container(
                          height: 300,
                          child: SfCircularChart(
                            // title: ChartTitle(text: "Circular DataSheet"),
                            legend: Legend(
                                isVisible: true,
                                overflowMode: LegendItemOverflowMode.wrap,
                                isResponsive: true,
                                position: LegendPosition.bottom,
                                orientation: LegendItemOrientation.horizontal,
                                toggleSeriesVisibility: true),
                            series: <CircularSeries>[
                              RadialBarSeries(
                                dataLabelSettings: DataLabelSettings(isVisible: true),
                                dataSource: data,
                                xValueMapper: (datum, index) => datum.x,
                                yValueMapper: (datum, index) => datum.y,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
 */
