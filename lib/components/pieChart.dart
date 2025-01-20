import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Piechart extends StatelessWidget {
  final List dataList;
  const Piechart({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    double totalSales = dataList
        .map((e) => e['sales'])
        .reduce((value, element) => value + element)
        .toDouble();

    List<Color> colorList = [];
    for (int i = 0; i < dataList.length; i++) {
      colorList.add(Colors.primaries[(i + 2) % Colors.primaries.length]);
    }

    return Row(
      children: [
        SizedBox(
          height: 200,
          width: 150,
          child: PieChart(
              curve: Curves.easeInOut,
              PieChartData(
                sections: List.generate(dataList.length, (index) {
                  var item = dataList[index];
                  var percent =
                      (item['sales'] / totalSales * 100).toStringAsFixed(0);
                  return PieChartSectionData(
                    color: colorList[index],
                    value: item['sales'],
                    title: "$percent%",
                    radius: 30,
                    titleStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              )),
        ),
        Expanded(
            child: Column(
          children: List.generate(dataList.length, (index) {
            var item = dataList[index];
            var percent = (item['sales'] / totalSales * 100).toStringAsFixed(0);
            return ListTile(
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              minVerticalPadding: 0,
              dense: true,
              leading: Icon(Icons.circle, color: colorList[index]),
              title: Text(
                item['name'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                "$percent%",
                style: TextStyle(fontSize: 10),
              ),
            );
          }),
        ))
      ],
    );
  }
}
