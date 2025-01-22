import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/pages/salesSummary/daily.dart';
import 'package:ka_inventory/pages/salesSummary/monthly.dart';
import 'package:ka_inventory/pages/salesSummary/weekly.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  var selected = 1;
  final DateFormat formatter = DateFormat('MMM dd, y');
  var items = [
    DropdownMenuItem(value: 1, child: Text('Daily')),
    DropdownMenuItem(value: 2, child: Text('Weekly')),
    DropdownMenuItem(value: 3, child: Text('Monthly')),
  ];
  late DateTime dateFrom = DateTime.now();
  late DateTime dateTo;

  @override
  Widget build(BuildContext context) {
    if (selected == 2) {
      dateTo = dateFrom.add(Duration(days: 6));
    } else if (selected == 3) {
      dateTo = DateTime(dateFrom.year, dateFrom.month + 1, 0);
    } else {
      dateTo = dateFrom;
    }

    late String formatted = formatter.format(dateFrom); // date from
    late String formattedTo = formatter.format(dateTo); // date to

    void updateDate(mode) {
      int day;

      switch (mode) {
        case 'add':
          day = 1;
          break;
        case 'minus':
          day = -1;
          break;

        default:
          day = 0;
          break;
      }
      // daily
      if (selected == 1) {
        if (day == 0) {
          dateFrom = DateTime.now();
        } else {
          if (dateFrom.add(Duration(days: day)).isAfter(DateTime.now())) {
            return;
          }
          setState(() {
            dateFrom = dateFrom.add(Duration(days: day));
            formatted = formatter.format(dateFrom);
          });
        }
      }
      // weekly
      if (selected == 2) {
        if (day == 0) {
          setState(() {
            dateFrom =
                DateTime.now().subtract(Duration(days: DateTime.now().weekday));
            // dateTo = dateFrom.add(Duration(days: 6));
          });
        }
        if (day == 1) {
          if (dateTo.add(Duration(days: day)).isAfter(DateTime.now())) {
            return;
          }
          setState(() {
            dateFrom = dateFrom.add(Duration(days: 7));
          });
        }
        if (day == -1) {
          setState(() {
            dateFrom = dateFrom.subtract(Duration(days: 7));
          });
        }
      }
      // monthly
      if (selected == 3) {
        if (day == 0) {
          setState(() {
            dateFrom =
                DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
            // DateTime(DateTime.now().year, DateTime.now().month, 1);
            // dateTo = dateFrom.add(Duration(days: 30));
          });
        }
        if (day == 1) {
          if (DateTime(dateFrom.year, dateFrom.month + 1, 1)
              .isAfter(DateTime.now())) {
            return;
          }
          setState(() {
            dateFrom = DateTime(dateFrom.year, dateFrom.month + 1, 1);
          });
        }
        if (day == -1) {
          setState(() {
            dateFrom = DateTime(dateFrom.year, dateFrom.month - 1, 1);
          });
        }
      }
    }

    return Scaffold(
      appBar: Appbar(title: 'Sales Summary', leading: true),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        updateDate('minus');
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded)),
                  Text(
                    selected == 1 ? formatted : '$formatted - $formattedTo',
                  ),
                  IconButton(
                      onPressed: () {
                        updateDate('add');
                      },
                      icon: Icon(Icons.arrow_forward_ios_rounded)),
                ],
              ),
              SizedBox(
                width: 100,
                child: DropdownButtonFormField(
                    alignment: AlignmentDirectional.centerStart,
                    value: selected,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        selected = value!;
                      });
                      updateDate('initial');
                    }),
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: selected == 1
                  ? DailySummary(
                      date: dateFrom,
                    )
                  : selected == 2
                      ? WeekSummary(
                          dateFrom: dateFrom,
                          dateTo: dateTo,
                        )
                      : MonthlySummary(
                          dateFrom: dateFrom,
                          dateTo: dateTo,
                        ),
            ),
          )
        ],
      ),
    );
  }
}
