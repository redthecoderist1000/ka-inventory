import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:ka_inventory/components/barGraph.dart';
import 'package:ka_inventory/components/pieChart.dart';
import 'package:ka_inventory/hive/boxes.dart';

class MonthlySummary extends StatelessWidget {
  final DateTime dateFrom;
  final DateTime dateTo;
  const MonthlySummary(
      {super.key, required this.dateFrom, required this.dateTo});

  @override
  Widget build(BuildContext context) {
    var transaction = userDataBox.get(userKey).transactionList;
    var transPerMonth = transaction.where((item) {
      var date = item['date'].toString().substring(0, 10);
      var targetDateFrom = dateFrom.toString().substring(0, 10);
      var targetDateTo = dateTo.toString().substring(0, 10);

      return date.compareTo(targetDateFrom) >= 0 &&
          date.compareTo(targetDateTo) <= 0;
    }).toList();

    Map<String, Map<String, dynamic>> transPerWeek = {
      '1': {'week': 'Week 1', 'sales': 0.0},
      '2': {'week': 'Week 2', 'sales': 0.0},
      '3': {'week': 'Week 3', 'sales': 0.0},
      '4': {'week': 'Week 4', 'sales': 0.0},
      '5': {'week': 'Week 5', 'sales': 0.0},
    };
    Map<String, Map<String, dynamic>> merchPermonth = {};
    Map<String, Map<String, dynamic>> prepPermonth = {};

    for (var items in transPerMonth) {
      var date = items['date'].toString().substring(0, 10);
      var week = (int.parse(date.substring(8, 10)) / 7).ceil();

      // fill in the transaction per week
      if (transPerWeek.containsKey(week.toString())) {
        transPerWeek[week.toString()]!['sales'] +=
            items['quantity'] * items['price'];
      } else {
        transPerWeek[week.toString()] = {
          'week': 'Week $week',
          'sales': items['quantity'] * items['price']
        };
      }

      if (items['isMerch']) {
        // fill in the merch per month
        if (merchPermonth.containsKey(items['name'])) {
          merchPermonth[items['name']]!['quantity'] += items['quantity'];
          merchPermonth[items['name']]!['sales'] +=
              items['quantity'] * items['price'];
        } else {
          merchPermonth[items['name']] = {
            'name': items['name'],
            'quantity': items['quantity'],
            'sales': items['quantity'] * items['price']
          };
        }
      } else {
        // fill in the prep per month
        if (prepPermonth.containsKey(items['name'])) {
          prepPermonth[items['name']]!['quantity'] += items['quantity'];
          prepPermonth[items['name']]!['sales'] +=
              items['quantity'] * items['price'];
        } else {
          prepPermonth[items['name']] = {
            'name': items['name'],
            'quantity': items['quantity'],
            'sales': items['quantity'] * items['price']
          };
        }
      }
    }

    List transPerWeekList = transPerWeek.values.toList();
    List merchPerMonthList = merchPermonth.values.toList();
    List prepPerMonthList = prepPermonth.values.toList();

    // print(prepPerMonthList);

    Widget monthlyTopTitle(value, meta) {
      const style = TextStyle(color: Colors.black, fontSize: 11);

      Widget text;
      // DateFormat formatter = DateFormat('MMM dd');
      // DateFormat endFormatter = DateFormat('dd');

      switch (value.toInt()) {
        case 0:
          // get start and end date of the week
          // var startDate = formatter.format(dateFrom);
          // var endDate = endFormatter.format(dateFrom.add(Duration(days: 6)));
          text = Text('Week 1', style: style);
          // text = Text('$startDate - $endDate', style: style);
          break;
        case 1:
          // var startDate = formatter.format(dateFrom.add(Duration(days: 7)));
          // var endDate = endFormatter.format(dateFrom.add(Duration(days: 13)));
          text = Text('Week 2', style: style);
          // text = Text('$startDate - $endDate', style: style);
          break;
        case 2:
          // var startDate = formatter.format(dateFrom.add(Duration(days: 14)));
          // var endDate = endFormatter.format(dateFrom.add(Duration(days: 20)));
          text = Text('Week 3', style: style);
          // text = Text('$startDate - $endDate', style: style);
          break;
        case 3:
          // var startDate = formatter.format(dateFrom.add(Duration(days: 21)));
          // var endDate = endFormatter.format(dateFrom.add(Duration(days: 27)));
          text = Text('Week 4', style: style);
          // text = Text('$startDate - $endDate', style: style);

          break;
        case 4:
          // var startDate = formatter.format(dateFrom.add(Duration(days: 28)));
          // var endDate = endFormatter.format(dateTo);
          text = Text('Week 5', style: style);
          // text = Text('$startDate - $endDate', style: style);
          break;

        default:
          text = Text('');
          break;
      }

      return SideTitleWidget(meta: meta, child: text);
    }

    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                  )
                ],
              ),
              child: transPerMonth.isEmpty
                  ? Center(
                      child: Text('No transaction for this month'),
                    )
                  : Column(
                      children: [
                        // SizedBox(height: 20),
                        Text(
                          'MONTHLY SALES',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Bargraph(
                            dataList: transPerWeekList,
                            topTitle: monthlyTopTitle),
                        // SizedBox(height: 20)
                      ],
                    ),
            ),
            SizedBox(height: 20),
            merchPerMonthList.isEmpty
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'MERCHANDISE',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: 15),
                        Piechart(
                          dataList: merchPerMonthList,
                        )
                        // SizedBox(height: 20)
                      ],
                    ),
                  ),
            SizedBox(height: 20),
            prepPerMonthList.isEmpty
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'PREPARED FOOD',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: 15),
                        Piechart(
                          dataList: prepPerMonthList,
                        )

                        // SizedBox(height: 20)
                      ],
                    ),
                  ),
          ],
        ));
  }
}
