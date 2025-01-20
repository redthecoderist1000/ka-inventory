import 'package:flutter/material.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Profit extends StatefulWidget {
  const Profit({super.key});

  @override
  State<Profit> createState() => _ProfitState();
}

class _ProfitState extends State<Profit> {
  bool isMerch = false;

  @override
  Widget build(BuildContext context) {
    var transaction = userDataBox.get(userKey).transactionList;
    var filteredTrans =
        transaction.where((element) => element['isMerch'] == isMerch);
    double merchTotal = 0;
    double prepTotal = 0;
    // double total = 0;

    List<DropdownMenuItem> items = [
      DropdownMenuItem(value: true, child: Text('Merchandise')),
      DropdownMenuItem(value: false, child: Text('Prepared Foods')),
    ];

    // Combine same items in transaction
    Map<String, Map<String, dynamic>> groupedTrans = {};

    for (var item in filteredTrans) {
      var name = item['name'];

      if (groupedTrans.containsKey(name)) {
        groupedTrans[name]!['quantity'] += item['quantity'];
        groupedTrans[name]!['sales'] += item['quantity'] * item['price'];
      } else {
        groupedTrans[name] = {
          'id': item['id'],
          'name': name,
          'quantity': item['quantity'],
          'price': item['price'],
          'isMerch': item['isMerch'],
          'sales': item['quantity'] * item['price'],
        };
      }
    }

    // Convert combined transactions back to a list
    List groupedTransList = groupedTrans.values.toList();

    List header = [
      "Item",
      "Qty. Sold",
      "Price (PHP)",
      "Cost (PHP)",
      "Gross Profit (PHP)",
    ];

    double getCost(String id, bool isMerch) {
      if (isMerch) {
        var list = userDataBox.get(userKey).merchList;

        for (var item in list) {
          if (item['mid'] == id) {
            return item['cost'];
          }
        }
      } else {
        var list = userDataBox.get(userKey).prepList;

        for (var item in list) {
          if (item['pid'] == id) {
            return item['totalCost'];
          }
        }
      }
      return 0;
    }

    for (var item in transaction) {
      double cost = getCost(item['id'], item['isMerch']);

      if (item['isMerch']) {
        merchTotal += (item['price'] - cost) * item['quantity'];
      } else {
        prepTotal += (item['price'] * item['quantity']) - cost;
      }
    }

    TextStyle titleStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.bold,
    );

    TextStyle salesStyle(double sales) {
      Color color = sales > 0 ? Colors.green : Colors.red;

      return TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20);
    }

    return Scaffold(
      appBar: Appbar(title: "Gross Profit", leading: true),
      body: Column(
        children: [
          DropdownButton(
              items: items,
              value: isMerch,
              onChanged: (val) {
                setState(() {
                  isMerch = val as bool;
                });
              }),
          Container(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Gross Profit',
                        style: titleStyle,
                      ),
                      Text(
                        'PHP ${merchTotal + prepTotal}',
                        style: salesStyle(merchTotal + prepTotal),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${isMerch ? 'Merchandise' : 'Prepared Foods'} Gross Profit',
                        style: titleStyle,
                      ),
                      Text(
                        'PHP ${isMerch ? merchTotal : prepTotal}',
                        style: salesStyle(isMerch ? merchTotal : prepTotal),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Table(
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey,
                  ),
                  children: List.generate(header.length, (index) {
                    return TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          header[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Table(
                      children: List.generate(groupedTransList.length, (index) {
                        var item = groupedTransList[index];
                        var cost = getCost(item['id'], item['isMerch']);
                        var grossProfit = item['isMerch']
                            ? item['sales'] - (item['quantity'] * cost)
                            : item['sales'] - cost;

                        return TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item['name']),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item['quantity'].toString()),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item['price']}'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(cost.toString()),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  grossProfit.toString(),
                                  style: TextStyle(
                                    color: grossProfit > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
