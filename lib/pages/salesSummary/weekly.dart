import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/components/barGraph.dart';
import 'package:ka_inventory/components/pieChart.dart';
import 'package:ka_inventory/hive/boxes.dart';

class WeekSummary extends StatelessWidget {
  final DateTime dateFrom;
  final DateTime dateTo;
  const WeekSummary({super.key, required this.dateFrom, required this.dateTo});

  @override
  Widget build(BuildContext context) {
    var transaction = userDataBox.get(userKey).transactionList;
    var transThisWeek = transaction.where((item) {
      var date = item['date'].toString().substring(0, 10);
      var targetDateFrom = dateFrom.toString().substring(0, 10);
      var targetDateTo = dateTo.toString().substring(0, 10);

      return date.compareTo(targetDateFrom) >= 0 &&
          date.compareTo(targetDateTo) <= 0;
    }).toList();

    Map<String, Map<String, dynamic>> weeklyTrans = {
      'Sunday': {'day': 'Sunday', 'sales': 0.0, 'date': ''},
      'Monday': {'day': 'Monday', 'sales': 0.0, 'date': ''},
      'Tuesday': {'day': 'Tuesday', 'sales': 0.0, 'date': ''},
      'Wednesday': {'day': 'Wednesday', 'sales': 0.0, 'date': ''},
      'Thursday': {'day': 'Thursday', 'sales': 0.0, 'date': ''},
      'Friday': {'day': 'Friday', 'sales': 0.0, 'date': ''},
      'Saturday': {'day': 'Saturday', 'sales': 0.0, 'date': ''},
    };

    Map<String, Map<String, dynamic>> weeklyTransMerch = {};
    Map<String, Map<String, dynamic>> weeklyTransPrep = {};

    for (var item in transaction) {
      var day = DateFormat('EEEE')
          .format(item['date']); // Get the word value of the weekday
      var date = item['date'].toString().substring(0, 10);
      var targetDateFrom = dateFrom.toString().substring(0, 10);
      var targetDateTo = dateTo.toString().substring(0, 10);
      var category = item['isMerch'] ? 'Merchandise' : 'Prepared Food';
      var name = item['name'];

      if (date.compareTo(targetDateFrom) >= 0 &&
          date.compareTo(targetDateTo) <= 0) {
        // fill in the weeklyTrans map
        weeklyTrans[day]!['sales'] += item['quantity'] * item['price'];
        weeklyTrans[day]!['date'] = date;

        // fill in the weeklyTransMerch map
        if (item['isMerch'] == true) {
          if (weeklyTransMerch.containsKey(name)) {
            weeklyTransMerch[name]!['sales'] +=
                item['quantity'] * item['price'];
          } else {
            weeklyTransMerch[name] = {
              'name': name,
              'category': category,
              'sales': item['quantity'] * item['price'],
            };
          }
        } else {
          if (weeklyTransPrep.containsKey(name)) {
            weeklyTransPrep[name]!['sales'] += item['quantity'] * item['price'];
          } else {
            weeklyTransPrep[name] = {
              'name': name,
              'category': category,
              'sales': item['quantity'] * item['price'],
            };
          }
        }
      }
    }

    List weeklyTransList = weeklyTrans.values.toList();
    List weeklyTransMerchList = weeklyTransMerch.values.toList();
    List weeklyTransPrepList = weeklyTransPrep.values.toList();

    Widget weeklyTopTitle(value, meta) {
      const style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

      Widget text;

      switch (value.toInt()) {
        case 0:
          text = Text('Sun', style: style);
          break;
        case 1:
          text = Text('Mon', style: style);
          break;
        case 2:
          text = Text('Tue', style: style);
          break;
        case 3:
          text = Text('Wed', style: style);
          break;
        case 4:
          text = Text('Thu', style: style);
          break;
        case 5:
          text = Text('Fri', style: style);
          break;
        case 6:
          text = Text('Sat', style: style);
          break;

        default:
          text = Text('');
          break;
      }

      return SideTitleWidget(child: text, meta: meta);
    }

    // print(weeklyTransPrepList);

    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // bar graph for weekly sales
            Container(
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
              child: transThisWeek.isEmpty
                  ? Center(
                      child: Text('No record of sales found'),
                    )
                  : Column(
                      children: [
                        // SizedBox(height: 20),
                        Text(
                          'WEEKLY SALES',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Bargraph(
                            dataList: weeklyTransList,
                            topTitle: weeklyTopTitle),
                        // SizedBox(height: 20)
                      ],
                    ),
            ),
            SizedBox(height: 20),
            // pie chart for merchandise sales
            weeklyTransMerchList.isEmpty
                ? Container()
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
                          dataList: weeklyTransMerchList,
                        )

                        // SizedBox(height: 20)
                      ],
                    ),
                  ),
            SizedBox(height: 20),

            // pie chart for prepared food sales
            weeklyTransPrepList.isEmpty
                ? Container()
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
                          dataList: weeklyTransPrepList,
                        )

                        // SizedBox(height: 20)
                      ],
                    ),
                  ),
          ],
        ));
  }
}
