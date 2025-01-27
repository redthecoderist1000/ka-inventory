import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/pdf/pdfAPI.dart';

class Profit extends StatefulWidget {
  const Profit({super.key});

  @override
  State<Profit> createState() => _ProfitState();
}

class _ProfitState extends State<Profit> {
  // bool isMerch = false;
  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    // print(userDataBox.get(userKey).transactionList);
    // userDataBox.put(userKey, userDataBox.get(userKey));

    NumberFormat numFormat = NumberFormat("#,##0.0", "en_PH");
    NumberFormat currencyFormat = NumberFormat.currency(locale: 'fil_PH ');
    List transactionList = [];
    List merchList = [];
    List prepList = [];
    double merchTotal = 0;
    double prepTotal = 0;

    userDataBox.get(userKey).transactionList.forEach((element) {
      // all items
      if (transactionList.isEmpty) {
        transactionList.add({
          'tid': element['tid'],
          'id': element['id'],
          'name': element['name'],
          'quantity': element['quantity'],
          'price': element['price'],
          'isMerch': element['isMerch'],
          'cost': element['cost'],
          'sales': element['quantity'] * element['price']
        });
      }
      bool itemFound = false;
      for (var item in transactionList) {
        if (item['id'] == element['id'] &&
            item['isMerch'] == element['isMerch']) {
          item['quantity'] += element['quantity'];
          item['sales'] += element['quantity'] * element['price'];
          itemFound = true;
          break;
        }
      }
      if (!itemFound) {
        transactionList.add({
          'tid': element['tid'],
          'id': element['id'],
          'name': element['name'],
          'quantity': element['quantity'],
          'price': element['price'],
          'isMerch': element['isMerch'],
          'cost': element['cost'],
          'sales': element['quantity'] * element['price']
        });
      }
      // merch and prep items
      if (element['isMerch']) {
        // merch items
        if (merchList.isEmpty) {
          merchList.add({
            'tid': element['tid'],
            'id': element['id'],
            'name': element['name'],
            'quantity': element['quantity'],
            'price': element['price'],
            'cost': element['cost'],
            'isMerch': true,
            'sales': element['quantity'] * element['price']
          });
        }
        bool itemFoundMerch = false;
        for (var item in merchList) {
          if (item['id'] == element['id']) {
            // item['name'] = element['name'];
            item['quantity'] += element['quantity'];
            item['sales'] += element['quantity'] * element['price'];
            itemFoundMerch = true;
            break;
          }
        }
        if (!itemFoundMerch) {
          merchList.add({
            'tid': element['tid'],
            'id': element['id'],
            'name': element['name'],
            'quantity': element['quantity'],
            'price': element['price'],
            'cost': element['cost'],
            'isMerch': true,
            'sales': element['quantity'] * element['price']
          });
        }
      } else if (!element['isMerch']) {
        // prep
        if (prepList.isEmpty) {
          prepList.add({
            'tid': element['tid'],
            'id': element['id'],
            'name': element['name'],
            'quantity': element['quantity'],
            'price': element['price'],
            'cost': element['cost'],
            'isMerch': false,
            'sales': element['quantity'] * element['price']
          });
        }
        bool itemFoundPrep = false;
        for (var item in prepList) {
          if (item['id'] == element['id']) {
            // item['name'] = element['name'];
            item['quantity'] += element['quantity'];
            item['sales'] += element['quantity'] * element['price'];
            itemFoundPrep = true;
            break;
          }
        }
        if (!itemFoundPrep) {
          prepList.add({
            'tid': element['tid'],
            'id': element['id'],
            'name': element['name'],
            'quantity': element['quantity'],
            'price': element['price'],
            'cost': element['cost'],
            'isMerch': false,
            'sales': element['quantity'] * element['price']
          });
        }
      }
    });

    TextStyle titleStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.bold,
    );

    TextStyle salesStyle(double sales) {
      Color color = sales > 0 ? Colors.green : Colors.red;

      return TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20);
    }

    List<DropdownMenuItem> items = [
      DropdownMenuItem(
          alignment: Alignment.center,
          value: 'All',
          child: Text(
            'All',
          )),
      DropdownMenuItem(
          alignment: Alignment.center,
          value: 'Merchandise',
          child: Text('Merchandise')),
      DropdownMenuItem(
          alignment: Alignment.center,
          value: 'Prepared Food',
          child: Text('Prepared Foods')),
    ];

    List header = [
      "Item",
      "Qty. Sold",
      "Price (PHP)",
      "Cost (PHP)",
      "Gross Profit (PHP)",
    ];

    List toDisplay = selected == 'All'
        ? transactionList
        : selected == 'Merchandise'
            ? merchList
            : prepList;

    for (var element in merchList) {
      merchTotal += element['sales'] - (element['quantity'] * element['cost']);
    }
    for (var element in prepList) {
      prepTotal += element['sales'] - element['cost'];
    }

    return Scaffold(
      appBar: Appbar(title: "Gross Profit", leading: true),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: selected == 'All'
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              DropdownButton(
                  alignment: Alignment.center,
                  items: items,
                  value: selected,
                  onChanged: (val) {
                    setState(() {
                      selected = val.toString();
                    });
                  }),
              selected != 'All'
                  ? SizedBox()
                  : IconButton(
                      onPressed: () async {
                        final pdfFile = await PdfAPI.generatePdf(
                            transactionList,
                            merchTotal,
                            prepTotal,
                            merchTotal + prepTotal);

                        PdfAPI.openFile(pdfFile);
                      },
                      icon: Icon(Icons.file_download_outlined))
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                mainAxisAlignment: selected == 'All'
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Gross Profit',
                        style: titleStyle,
                      ),
                      Text(
                        currencyFormat.format(merchTotal + prepTotal),
                        style: salesStyle(merchTotal + prepTotal),
                      ),
                    ],
                  ),
                  selected == 'All'
                      ? SizedBox()
                      : Column(
                          children: [
                            Text(
                              '$selected Gross Profit',
                              style: titleStyle,
                            ),
                            Text(
                              currencyFormat.format(selected == 'Merchandise'
                                  ? merchTotal
                                  : prepTotal),
                              style: salesStyle(selected == 'Merchandise'
                                  ? merchTotal
                                  : prepTotal),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
          toDisplay.isEmpty
              ? Center(
                  child: Text(
                    'No data to display',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Table(
                        border: TableBorder.all(style: BorderStyle.none),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.shade100,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            children: List.generate(header.length, (index) {
                              return TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    header[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              );
                            }),
                          ),
                          ...List.generate(toDisplay.length, (index) {
                            var item = toDisplay[index];
                            var cost = item['cost'];
                            var grossProfit = item['isMerch']
                                ? item['sales'] - (item['quantity'] * cost)
                                : item['sales'] - cost;

                            return TableRow(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: toDisplay.length - 1 == index
                                    ? BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))
                                    : BorderRadius.only(),
                              ),
                              children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(item['name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      item['quantity'].toString(),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(numFormat.format(item['price']),
                                        textAlign: TextAlign.right),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(numFormat.format(cost),
                                        textAlign: TextAlign.right),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      numFormat.format(grossProfit),
                                      textAlign: TextAlign.right,
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
                          })
                        ],
                      ),
                    ),
                  ),
                ),
          // Table(
          //   children: ,
          // ),
        ],
      ),
    );
  }
}
