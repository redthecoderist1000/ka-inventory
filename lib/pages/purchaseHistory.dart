import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:ka_inventory/components/appBar.dart';
// import 'package:ka_inventory/components/purchase_history/purchaseHistoryList.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/pdf/pdfAPI.dart';

class Purchasehistory extends StatefulWidget {
  const Purchasehistory({super.key});

  @override
  State<Purchasehistory> createState() => _PurchasehistoryState();
}

class _PurchasehistoryState extends State<Purchasehistory> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_PH', symbol: '', decimalDigits: 1);

    DateFormat formatter = DateFormat('MMM dd, yyyy');
    var historyList = userDataBox.get(userKey).inventoryHistory;

    List historySorted = [];
    double totalSales = 0;

    historyList.forEach((element) {
      DateTime elementDate = element['date'];

      if (elementDate.year == date.year &&
          elementDate.month == date.month &&
          elementDate.day == date.day) {
        historySorted.add(element);
      }
    });

    for (var item in historySorted) {
      totalSales += item['totalCost'];
    }

    List tableHeader = [
      'Item',
      'Quantity',
      'Unit Cost (PHP)',
      'Total Cost (PHP)',
    ];

    chooseDate() {
      showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2021),
        lastDate: DateTime.now(),
      ).then((value) {
        if (value != null) {
          setState(() {
            date = value;
          });
        }
      });
    }

    return Scaffold(
      appBar: Appbar(title: 'Purchase History', leading: true),
      // backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            // total purchase cost
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade400, width: .5)),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400, width: .5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text('Total Purchase Cost:'),
                          Text(
                            currencyFormat.format(totalSales),
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // date
            Row(
              mainAxisAlignment: historySorted.isEmpty
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(formatter.format(date)),
                    IconButton(
                      onPressed: chooseDate,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
                historySorted.isEmpty
                    ? SizedBox()
                    : IconButton(
                        onPressed: () async {
                          final pdfFile = await PdfAPI.purchaseHistoryPDF(
                              historySorted, totalSales);

                          PdfAPI.openFile(pdfFile);
                        },
                        icon: Icon(Icons.file_download_outlined))
              ],
            ),
            // data table
            historySorted.isEmpty
                ? Center(
                    child: Text(
                    'No data to display',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Table(
                          border: TableBorder.all(style: BorderStyle.none),
                          children: [
                            // talbe header
                            TableRow(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                children:
                                    List.generate(tableHeader.length, (index) {
                                  return TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        tableHeader[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                })),
                            // table body
                            ...List.generate(historySorted.length, (index) {
                              var item = historySorted[index];
                              List tableRow = [
                                item['name'],
                                "${item['quantity'] ?? '--'}",
                                item['unitCost'] == null
                                    ? '--'
                                    : currencyFormat.format(item['unitCost']),
                                currencyFormat.format(item['totalCost']),
                              ];
                              return TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: historySorted.length - 1 ==
                                            index
                                        ? BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))
                                        : BorderRadius.only(),
                                  ),
                                  children:
                                      List.generate(tableRow.length, (index) {
                                    return TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          tableRow[index],
                                          textAlign: index == 0
                                              ? TextAlign.left
                                              : TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: index == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ),
                                    );
                                  }));
                            }),
                            // table footer
                            // TableRow(
                            //     decoration: BoxDecoration(
                            //         color: Colors.blueGrey.shade100,
                            //         borderRadius: BorderRadius.only(
                            //             bottomLeft: Radius.circular(10),
                            //             bottomRight: Radius.circular(10))),
                            //     children: [
                            //       TableCell(
                            //         child: Container(),
                            //       ),
                            //       TableCell(
                            //         child: Container(),
                            //       ),
                            //       TableCell(
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(10),
                            //           child: Text(
                            //             'Total: ',
                            //             textAlign: TextAlign.center,
                            //             style: TextStyle(
                            //                 fontSize: 15,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //         ),
                            //       ),
                            //       TableCell(
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(10),
                            //           child: Text(
                            //             currencyFormat.format(totalSales),
                            //             textAlign: TextAlign.center,
                            //             style: TextStyle(
                            //                 fontSize: 15,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //         ),
                            //       ),
                            //     ])
                          ],
                        ),
                      ),
                    ),
                  ),

            // list
            // Expanded(
            //   child: PurchaseHistoryList(transList: historyList),
            // ),
          ],
        ),
      )),
    );
  }
}
