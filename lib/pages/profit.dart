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
    // userDataBox.get(userKey).transactionList.clear();
    // userDataBox.put(userKey, userDataBox.get(userKey));

    NumberFormat numFormat = NumberFormat("#,##0.0", "en_PH");
    NumberFormat currencyFormat = NumberFormat.currency(locale: 'fil_PH ');
    List transactionList = [];
    List merchList = [];
    List prepList = [];
    double merchTotal = 0;
    double prepTotal = 0;

    userDataBox.get(userKey).transactionList.forEach((element) {
      // check if existing in transactionList
      // print(element);

      if (transactionList.isEmpty) {
        transactionList.add({
          'id': element['id'],
          'name': element['name'],
          'quantity': element['quantity'],
          'price': element['price'],
          'isMerch': element['isMerch'],
          'cost': element['cost'],
          'sales': element['quantity'] * element['price']
        });
      } else {
        for (var item in transactionList) {
          if (item['id'] == element['id'] &&
              item['isMerch'] == element['isMerch']) {
            item['quantity'] += element['quantity'];
            item['sales'] += element['quantity'] * element['price'];
            break;
          } else {
            transactionList.add({
              'id': element['id'],
              'name': element['name'],
              'quantity': element['quantity'],
              'price': element['price'],
              'isMerch': element['isMerch'],
              'cost': element['cost'],
              'sales': element['quantity'] * element['price']
            });
            break;
          }
        }
      }
    });

    for (var element in transactionList) {
      // int quantity = getQuantity(element['pid'], false);

      if (element['isMerch']) {
        merchList.add({
          'id': element['id'],
          'name': element['name'],
          'quantity': element['quantity'],
          'price': element['price'],
          'cost': element['cost'],
          'isMerch': true,
          'sales': element['price'] * element['quantity']
        });
      } else {
        prepList.add({
          'id': element['id'],
          'name': element['name'],
          'quantity': element['quantity'],
          'price': element['price'],
          'cost': element['cost'],
          'isMerch': false,
          'sales': element['price'] * element['quantity']
        });
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
        ? merchList + prepList
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
      body: toDisplay.isEmpty
          ? Center(
              child: Text(
                'No data to display',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    IconButton(
                        onPressed: () async {
                          final pdfFile = await PdfAPI.generatePdf(
                              merchList + prepList,
                              merchTotal,
                              prepTotal,
                              merchTotal + prepTotal);

                          PdfAPI.openFile(pdfFile);
                        },
                        icon: Icon(Icons.file_download_outlined))
                  ],
                ),
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
                                    currencyFormat.format(
                                        selected == 'Merchandise'
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
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
                            children: List.generate(toDisplay.length, (index) {
                              var item = toDisplay[index];
                              var cost = item['cost'];
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
                                      child:
                                          Text(numFormat.format(item['price'])),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(numFormat.format(cost)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        numFormat.format(grossProfit),
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
