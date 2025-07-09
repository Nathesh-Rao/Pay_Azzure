import 'package:axpertflutter/Constants/AppStorage.dart';
import 'package:axpertflutter/Constants/const.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuDashboardPage/Models/ChartCardModel.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/MenuHomePagePage/Controllers/MenuHomePageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WidgetCharts extends StatelessWidget {
  WidgetCharts(this.cardModel, {super.key});
  final ChartCardModel cardModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(border: Border.all(width: 2, color: HexColor('EDF0F8')), borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(cardModel.cardname,
              style:
                  GoogleFonts.nunito(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: HexColor('495057')))),
          children: [
            SizedBox(height: 3),
            Container(height: 2, color: HexColor('EDF0F8')),
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              child: chooseChart(cardModel),
            )
          ],
        ),
      ),
    );
  }
}

Widget chooseChart(ChartCardModel cardModel) {
  switch (cardModel.cardtype.toString().toLowerCase()) {
    case 'chart':
      {
        if (validate(cardModel)) {
          switch (cardModel.charttype.toString().toLowerCase()) {
            case 'bar':
              return getBarChart(cardModel);
            case 'stacked-bar':
              return getStackedBarChart(cardModel);
            case 'donut':
              return getDonutChart(cardModel);
            case 'semi-donut':
              return getSemiDonutChart(cardModel);
            case 'pie':
              return getPieChart(cardModel);
            case 'line':
              return getLineChart(cardModel);
            case 'column':
              return getColumnChart(cardModel);
            case 'stacked-column':
              return getStackedColumnChart(cardModel);
            case 'stacked-percentage-column':
              return getPercentageColumnChart(cardModel);
            default:
              return Text("");
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text("No Valid data found."),
          );
        }
      }
    case 'kpi':
      return getKpi(cardModel);
    default:
      return Text("");
  }
}

Widget getKpi(ChartCardModel cardModel) {
  ChartData cd = cardModel.dataList[0];
  return Container(
    decoration: BoxDecoration(
      color: getColorFromName(cardModel.cardbgclr),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Padding(
      padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            cd.value.toString() == "null" ? cd.count : cd.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget getColumnChart(ChartCardModel cardModel) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.rotate45),

    // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
    legend: Legend(isVisible: true, isResponsive: true, toggleSeriesVisibility: true, position: LegendPosition.top),
    series: <CartesianSeries<dynamic, String>>[
      ColumnSeries(
          onPointTap: (pointInteractionDetails) {
            openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
          },
          dataSource: cardModel.dataList,
          xValueMapper: (datum, index) => datum.x_axis,
          yValueMapper: (datum, index) => double.parse(datum.value),
          dataLabelSettings: DataLabelSettings(isVisible: true))
    ],
  );
}

Widget getStackedColumnChart(ChartCardModel cardModel) {
  List<List<ChartData>> newList = getExtractedData(cardModel.dataList);
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.rotate45),

    // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
    legend: Legend(isVisible: true, isResponsive: true, toggleSeriesVisibility: true, position: LegendPosition.top),
    series: <CartesianSeries<dynamic, String>>[
      for (var item in newList)
        StackedColumnSeries(
            onPointTap: (pointInteractionDetails) {
              openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
            },
            dataSource: item,
            xValueMapper: (datum, index) => datum.x_axis,
            yValueMapper: (datum, index) => double.parse(datum.value),
            dataLabelSettings: DataLabelSettings(isVisible: true)),
    ],
  );
}

Widget getPercentageColumnChart(ChartCardModel cardModel) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.rotate45),
    primaryYAxis: CategoryAxis(
      maximum: 100,
      minimum: 0,
      interval: 25,
    ),

    // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
    legend: Legend(isVisible: true, isResponsive: true, toggleSeriesVisibility: true, position: LegendPosition.top),
    series: <CartesianSeries<dynamic, String>>[
      ColumnSeries(
          onPointTap: (pointInteractionDetails) {
            openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
          },
          isTrackVisible: true,
          trackColor: Colors.grey.withOpacity(0.4),
          dataSource: cardModel.dataList,
          dataLabelMapper: (datum, index) => "${datum.value}%",
          xValueMapper: (datum, index) => datum.x_axis,
          yValueMapper: (datum, index) => double.parse(datum.value),
          dataLabelSettings: DataLabelSettings(isVisible: true)),
    ],
  );
}

Widget getLineChart(ChartCardModel cardModel) {
  return SfCartesianChart(
    enableAxisAnimation: true,
    primaryXAxis: CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.rotate45),
    tooltipBehavior: TooltipBehavior(enable: true),
    // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
    legend: Legend(isVisible: true, isResponsive: true, toggleSeriesVisibility: true, position: LegendPosition.top),
    series: <CartesianSeries<dynamic, String>>[
      LineSeries(
          onPointTap: (pointInteractionDetails) {
            openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
          },
          markerSettings: MarkerSettings(isVisible: true),
          enableTooltip: true,
          name: cardModel.dataList[0].data_label == "" ? "Data" : cardModel.dataList[0].data_label,
          dataSource: cardModel.dataList,
          xValueMapper: (datum, index) => datum.x_axis,
          yValueMapper: (datum, index) => double.parse(datum.value),
          dataLabelSettings: DataLabelSettings(isVisible: true))
    ],
  );
}

Widget getPieChart(ChartCardModel cardModel) {
  return SfCircularChart(
    // title: ChartTitle(text: "Circular DataSheet"),
    legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        isResponsive: true,
        position: LegendPosition.bottom,
        orientation: LegendItemOrientation.horizontal,
        toggleSeriesVisibility: true),
    series: <CircularSeries>[
      PieSeries(
        onPointTap: (pointInteractionDetails) {
          openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
        },
        dataLabelSettings: DataLabelSettings(isVisible: true),
        dataSource: cardModel.dataList,
        explode: true,
        explodeIndex: 0,
        xValueMapper: (datum, index) => datum.data_label,
        yValueMapper: (datum, index) => double.parse(datum.value),
      )
    ],
  );
}

Widget getBarChart(ChartCardModel cardModel) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.rotate45),

    // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
    legend: Legend(isVisible: true, isResponsive: true, toggleSeriesVisibility: true, position: LegendPosition.top),
    series: <CartesianSeries<dynamic, String>>[
      BarSeries(
          onPointTap: (pointInteractionDetails) {
            openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
          },
          name: cardModel.dataList[0].data_label == '' ? " Data" : cardModel.dataList[0].data_label,
          dataSource: cardModel.dataList,
          color: Colors.green.shade800,
          xValueMapper: (datum, index) => datum.x_axis,
          yValueMapper: (datum, index) => double.parse(datum.value),
          dataLabelSettings: DataLabelSettings(isVisible: true))
    ],
  );
}

Widget getStackedBarChart(ChartCardModel cardModel) {
  List<List<ChartData>> newList = getExtractedData(cardModel.dataList);
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.rotate45),

    // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
    legend: Legend(isVisible: true, isResponsive: true, toggleSeriesVisibility: true, position: LegendPosition.top),
    series: <CartesianSeries<dynamic, String>>[
      for (var item in newList)
        StackedBarSeries(
            onPointTap: (pointInteractionDetails) {
              openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
            },
            name: cardModel.dataList[0].data_label == '' ? " Data" : cardModel.dataList[0].data_label,
            dataSource: item,
            color: Colors.green.shade800,
            xValueMapper: (datum, index) => datum.x_axis,
            yValueMapper: (datum, index) => double.parse(datum.value),
            dataLabelSettings: DataLabelSettings(isVisible: true))
    ],
  );
}

Widget getDonutChart(ChartCardModel cardModel) {
  return SfCircularChart(
    // title: ChartTitle(text: "Circular DataSheet"),
    legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        isResponsive: true,
        position: LegendPosition.bottom,
        orientation: LegendItemOrientation.horizontal,
        toggleSeriesVisibility: true),
    series: <CircularSeries>[
      DoughnutSeries(
        onPointTap: (pointInteractionDetails) {
          openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
        },
        dataLabelSettings: DataLabelSettings(isVisible: true),
        dataSource: cardModel.dataList,
        xValueMapper: (datum, index) => datum.data_label,
        yValueMapper: (datum, index) => double.parse(datum.value),
      )
    ],
  );
}

Widget getSemiDonutChart(ChartCardModel cardModel) {
  return SfCircularChart(
    // title: ChartTitle(text: "Circular DataSheet"),

    legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        isResponsive: true,
        position: LegendPosition.bottom,
        orientation: LegendItemOrientation.horizontal,
        toggleSeriesVisibility: true),
    series: <CircularSeries>[
      DoughnutSeries(
          onPointTap: (pointInteractionDetails) {
            openWebPage(cardModel.dataList[pointInteractionDetails.pointIndex!]);
          },
          dataLabelSettings: DataLabelSettings(isVisible: true),
          dataSource: cardModel.dataList,
          xValueMapper: (datum, index) => datum.data_label,
          yValueMapper: (datum, index) => double.parse(datum.value),
          startAngle: 270,
          endAngle: 90)
    ],
  );
}

getColorFromName(cardbgclr) {
  switch (cardbgclr.toString().toLowerCase()) {
    case 'light-pink':
      return Colors.pink.shade500;
    case 'red':
      return Colors.red;
    case 'cyan':
      return Colors.cyan;
    case 'purple':
      return Colors.purple.shade300;
    case 'cream':
      return HexColor('FFFDD0');
    default:
      return Colors.red;
  }
}

List<List<ChartData>> getExtractedData(List<ChartData> oriList) {
  List<List<ChartData>> multiList = [];
  Set uniqueXaxis = {};
  int max = 0;
  Map<String, List<ChartData>> mapper = {};
  for (var item in oriList) {
    if (uniqueXaxis.contains(item.x_axis)) {
      var list = mapper[item.x_axis] ?? [];
      list.add(item);
      mapper[item.x_axis] = list;
      if (max < list.length) max = list.length;
    } else {
      uniqueXaxis.add(item.x_axis);
      List<ChartData> list = [];
      list.add(item);
      mapper[item.x_axis] = list;
    }
  }

  for (int i = 0; i < max; i++) {
    List<ChartData> singleList = [];
    for (var item in uniqueXaxis) {
      ChartData data;
      List<ChartData> list = mapper[item.toString()] ?? [];
      try {
        data = list[i];
        singleList.add(data);
      } catch (e) {
        // print(e.toString());
        // data = list[0];
        // data.value = "-1";
      }
      // print(data.toJson());
    }
    multiList.add(singleList);
  }
  // print(multiList);
  return multiList;
}

void openWebPage(ChartData chartData) {
  try {
    if (chartData.link != "") {
      MenuHomePageController menuHPC = Get.find();
      String url = Const.getFullWebUrl('aspx/AxMain.aspx?pname=hDashboard&authKey=AXPERT-') +
          AppStorage().retrieveValue(AppStorage.SESSIONID) +
          '&plink=' +
          chartData.link;
      print(url);
      menuHPC.webUrl = url;
      menuHPC.switchPage.value = true;
    }
  } catch (e) {}
}

validate(ChartCardModel cardModel) {
  List<ChartData> datas = cardModel.dataList;
  try {
    for (ChartData item in datas) {
      double.parse(item.value);
    }
  } catch (e) {
    return false;
  }
  return true;
}
