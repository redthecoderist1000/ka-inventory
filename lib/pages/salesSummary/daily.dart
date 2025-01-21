import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/hive/boxes.dart';

class DailySummary extends StatefulWidget {
  final DateTime date;
  const DailySummary({super.key, required this.date});

  @override
  State<DailySummary> createState() => _DailySummaryState();
}

class _DailySummaryState extends State<DailySummary> {
  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');
    NumberFormat numberFormat = NumberFormat("#,##0.0", "en_PH");

    var transaction = userDataBox.get(userKey).transactionList;
    int totalQuantity = 0;

    Map<String, Map<String, dynamic>> combinedTransactions = {};
    Map<String, Map<String, dynamic>> perCatTransactions = {
      'Merchandise': {'category': 'Merchandise', 'sales': 0.0},
      'Prepared Food': {'category': 'Prepared Food', 'sales': 0.0},
    };

    // Combine items
    for (var item in transaction) {
      var date = item['date'].toString().substring(0, 10);
      var name = item['name'];
      var key = '$name-$date';
      var targetDate = widget.date.toString().substring(0, 10);
      var category = item['isMerch'] ? 'Merchandise' : 'Prepared Food';

      if (date == targetDate) {
        if (combinedTransactions.containsKey(key)) {
          combinedTransactions[key]!['quantity'] += item['quantity'];
        } else {
          combinedTransactions[key] = {
            'name': name,
            'quantity': item['quantity'],
            'price': item['price'],
            'isMerch': item['isMerch'],
            'date': date,
          };
        }

        // per category
        perCatTransactions[category]!['sales'] +=
            item['quantity'] * item['price'];
      }
    }

    List combinedList = combinedTransactions.values.toList();
    List perCatList = perCatTransactions.values.toList();

    // sort combined list
    combinedList.sort((a, b) {
      double aValue = a['quantity'] * a['price'];
      double bValue = b['quantity'] * b['price'];
      return bValue.compareTo(aValue); // Sort in descending order
    });

    // sort per category
    perCatList.sort((a, b) {
      double aValue = a['sales'];
      double bValue = b['sales'];
      return bValue.compareTo(aValue); // Sort in descending order
    });

    // get total quantity
    for (var item in combinedList) {
      totalQuantity = (totalQuantity + item['quantity']).toInt();
    }

    // Calculate the percentage difference between the highest and second highest sales per category
    String highestSale = ((perCatList[0]['sales'] /
                (perCatList[0]['sales'] + perCatList[1]['sales'])) *
            100)
        .toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
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
            // per item

            child: combinedList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text('No record of sales found'),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'DAILY SALES',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                              itemCount: combinedList.length,
                              itemBuilder: (context, index) {
                                var item = combinedList[index];

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          currencyFormat.format(
                                              item['quantity'] * item['price']),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            minHeight: 10,
                                            backgroundColor: Colors.transparent,
                                            color: Colors.blue[900],
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            value: item['quantity'] /
                                                totalQuantity,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                            'Items sold: ${numberFormat.format(item['quantity'])}'),
                                      ],
                                    ),
                                    SizedBox(height: 15)
                                  ],
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 20),
          // per category
          combinedList.isEmpty
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HIGHEST SALES IN',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$highestSale% of the total sales',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currencyFormat.format(perCatList[0]['sales']),
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                perCatList[0]['category'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              perCatList[0]['category'] == 'Merchandise'
                                  ? Icons.local_drink_rounded
                                  : Icons.rice_bowl_outlined,
                              color: Colors.blueGrey[50],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
