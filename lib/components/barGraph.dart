import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Bargraph extends StatelessWidget {
  final List dataList;
  final Widget Function(double, TitleMeta) topTitle;
  const Bargraph({super.key, required this.dataList, required this.topTitle});

  @override
  Widget build(BuildContext context) {
    NumberFormat numFormat = NumberFormat("#,##0", "en_PH");

    double highestSaleRaw = dataList
        .map((e) => e['sales'])
        .reduce((value, element) => value > element ? value : element)
        .toDouble();
    double highestSale = (highestSaleRaw / 100).ceil() * 100;

    Widget weeklyBottomTitle(value, meta) {
      const style = TextStyle(
        color: Colors.black,
      );

      Widget text = Text(numFormat.format(dataList[value.toInt()]['sales']),
          style: style);

      return SideTitleWidget(meta: meta, child: text);
    }

    return SizedBox(
      height: 300,
      child: BarChart(BarChartData(
          barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
                rod.toY.toStringAsFixed(0),
                TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14));
          })),
          minY: 0,
          maxY: highestSale,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  axisNameWidget: Text('Sales (PHP)',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  sideTitles: SideTitles(
                      showTitles: true, getTitlesWidget: weeklyBottomTitle)),
              topTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: true, getTitlesWidget: topTitle)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false))),
          barGroups: List.generate(dataList.length, (index) {
            var item = dataList[index];
            return BarChartGroupData(x: index, barRods: [
              BarChartRodData(
                  toY: item['sales'],
                  color: Colors.blue[900],
                  width: 20,
                  borderRadius: BorderRadius.circular(5),
                  backDrawRodData: BackgroundBarChartRodData(
                      show: true, toY: highestSale, color: Colors.grey[100]))
            ]);
          }))),
    );
  }
}
