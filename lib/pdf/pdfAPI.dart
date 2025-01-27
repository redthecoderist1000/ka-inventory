import 'dart:io';

import 'package:intl/intl.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfAPI {
  static Future<File> generatePdf(
      List allList, double mSales, double pSales, double prof) async {
    NumberFormat numberFormat = NumberFormat('#,###.00', 'en_PH');

    final pdf = Document();
    var userData = userDataBox.get(userKey);

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.all(.5 * PdfPageFormat.inch),
        header: (context) => header('Sales Report'),
        footer: (context) => footer(context),
        build: (context) => [
              Column(
                children: [
                  SizedBox(height: .25 * PdfPageFormat.inch),
                  details(userData, mSales, pSales, prof),
                  SizedBox(height: .5 * PdfPageFormat.inch),
                  Row(children: [
                    Text('Records',
                        style: TextStyle(
                            color: PdfColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 10),
                  // salesTable(allList),
                  ...salesTableList(allList),
                  Divider(color: PdfColors.grey300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Total Gross Profit: ',
                          style: TextStyle(
                            color: PdfColors.grey500,
                            fontSize: 11,
                          )),
                      SizedBox(width: 20),
                      Text(numberFormat.format(prof),
                          style: TextStyle(
                            color: PdfColors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ],
              )
            ]));

    return saveDocument(name: 'ka_inventory_report.pdf', pdf: pdf);
  }

  static Future<File> purchaseHistoryPDF(List allList, double totalCost) async {
    final pdf = Document();
    // var userData = userDataBox.get(userKey);
    DateFormat dateFormat = DateFormat("MMMM dd, yyyy");
    NumberFormat currencyFormat = NumberFormat.currency(
        locale: 'en_PH', symbol: 'PHP ', decimalDigits: 1);

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.all(.5 * PdfPageFormat.inch),
        header: (context) => header('Inventory Report'),
        footer: (context) => footer(context),
        build: (context) => [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  purHistoryDetails(),
                  SizedBox(height: .20 * PdfPageFormat.inch),
                  Divider(color: PdfColors.grey300, thickness: 1),
                  SizedBox(height: .20 * PdfPageFormat.inch),
                  Text('Records',
                      style: TextStyle(
                          color: PdfColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(dateFormat.format(allList[0]['date'])),
                  SizedBox(height: 10),
                  // purchaseTable(allList),
                  ...buildTablePages(allList),
                  Divider(color: PdfColors.grey300, thickness: 1),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Total Purchase Cost: ',
                          style:
                              TextStyle(color: PdfColors.black, fontSize: 11)),
                      TextSpan(
                          text: currencyFormat.format(totalCost),
                          style: TextStyle(
                              color: PdfColors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold))
                    ]))
                  ]),
                ],
              )
            ]));

    return saveDocument(name: 'ka_inventory_purchase_history.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static void openFile(File pdfFile) async {
    final file = pdfFile.path;
    await OpenFile.open(file);
  }

  static Widget header(String reportType) {
    DateFormat dateFormat = DateFormat("MMMM dd, yyyy hh:mm a");

    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: .25 * PdfPageFormat.inch),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ka-Inventory',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: PdfColors.blueGrey600)),
            // Image(
            //   MemoryImage(File('./../assets/img/logo.pdf').readAsBytesSync()),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(reportType,
                    style: TextStyle(
                        fontSize: 18,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('Issue Date: ${dateFormat.format(DateTime.now())}',
                    style: TextStyle(fontSize: 10, color: PdfColors.grey)),
              ],
            )
          ],
        ));
  }

  static Widget footer(context) {
    return Container(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Divider(color: PdfColors.grey300),
            Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: TextStyle(fontSize: 10, color: PdfColors.grey))
          ],
        ));
  }

  static Widget details(userData, mSales, pSales, prof) {
    NumberFormat numberFormat = NumberFormat('#,###.00', 'en_PH');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // user dateils
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gross Profit',
                style: TextStyle(
                    fontSize: 18,
                    color: PdfColors.black,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Account username',
                style: TextStyle(fontSize: 11, color: PdfColors.grey500)),
            Text(userData.uname,
                style: TextStyle(
                    fontSize: 13,
                    color: PdfColors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),

        // sumamry
        Container(
          padding: EdgeInsets.all(20),
          width: 3.5 * PdfPageFormat.inch,
          decoration: BoxDecoration(
              color: PdfColors.grey50,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Summary',
                  style: TextStyle(
                      fontSize: 16,
                      color: PdfColors.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Merchandise Sales',
                    style: TextStyle(fontSize: 11, color: PdfColors.grey500)),
                Text(numberFormat.format(mSales),
                    style: TextStyle(
                      fontSize: 11,
                      color: PdfColors.black,
                    )),
              ]),
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Prepared Food Sales',
                    style: TextStyle(fontSize: 11, color: PdfColors.grey500)),
                Text(numberFormat.format(pSales),
                    style: TextStyle(
                      fontSize: 11,
                      color: PdfColors.black,
                    )),
              ]),
              Divider(color: PdfColors.grey300),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Gross Profit',
                    style: TextStyle(fontSize: 11, color: PdfColors.grey500)),
                Text(numberFormat.format(mSales + pSales),
                    style: TextStyle(
                        fontSize: 11,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
        )
      ],
    );
  }

  static Widget salesTable(allData) {
    NumberFormat numberFormat = NumberFormat('#,###.00', 'en_PH');

    List tableHeader = [
      'Item',
      'Qty. Sold',
      'Price (PHP)',
      'Cost (PHP)',
      'Gross Profit (PHP)',
    ];

    List<List<dynamic>> data = [
      tableHeader,
      ...allData.map((e) {
        var grossProfit = e['isMerch']
            ? e['sales'] - (e['quantity'] * e['cost'])
            : e['sales'] - e['cost'];
        return [
          e['name'],
          e['quantity'].toString(),
          numberFormat.format(e['sales']),
          numberFormat.format(e['cost']),
          numberFormat.format(grossProfit),
        ];
      }).toList()
    ];

    return TableHelper.fromTextArray(
        data: data,
        border: null,
        headerStyle: TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: PdfColors.black),
        headerAlignment: Alignment.centerLeft,
        cellHeight: .5 * PdfPageFormat.inch,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
          5: Alignment.centerRight
        },
        cellStyle: TextStyle(fontSize: 10, color: PdfColors.black));
  }

  static List<Widget> salesTableList(List allData) {
    NumberFormat currencyFormat = NumberFormat.currency(
        locale: 'en_PH', symbol: 'PHP ', decimalDigits: 1);

    List tableHeader = [
      'Item',
      'Qty. Sold',
      'Price (PHP)',
      'Cost (PHP)',
      'Gross Profit (PHP)',
    ];

    final data = allData.map((e) {
      var grossProfit = e['isMerch']
          ? e['sales'] - (e['quantity'] * e['cost'])
          : e['sales'] - e['cost'];
      return [
        e['name'],
        e['quantity'].toString(),
        currencyFormat.format(e['sales']),
        currencyFormat.format(e['cost']),
        currencyFormat.format(grossProfit),
      ];
    }).toList();

    const int firstPageRows = 14; // Adjust this value for the first page
    const int rowsPerPage = 20;

    List<Widget> pages = [];

    final firstPageData = data.sublist(
        0, firstPageRows > data.length ? data.length : firstPageRows);

    pages.add(
      TableHelper.fromTextArray(
        headers: tableHeader,
        data: firstPageData,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
        },
        cellStyle: TextStyle(fontSize: 10, color: PdfColors.black),
      ),
    );

    // next pages
    for (int i = firstPageRows; i < data.length; i += rowsPerPage) {
      final chunk = data.sublist(
          i, i + rowsPerPage > data.length ? data.length : i + rowsPerPage);
      pages.add(
        TableHelper.fromTextArray(
          headers: tableHeader,
          data: chunk,
          border: null,
          headerStyle: TextStyle(fontWeight: FontWeight.bold),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
          cellAlignments: {
            0: Alignment.centerLeft,
            1: Alignment.centerRight,
            2: Alignment.centerRight,
            3: Alignment.centerRight,
            4: Alignment.centerRight,
          },
          cellStyle: TextStyle(fontSize: 10, color: PdfColors.black),
        ),
      );

      if (i + rowsPerPage < data.length) {
        pages.add(SizedBox(height: 20)); // Add space between tables
      }
    }

    return pages;
  }

  static Widget purHistoryDetails() {
    var userData = userDataBox.get(userKey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Purchase History',
            style: TextStyle(
                fontSize: 18,
                color: PdfColors.black,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Account username',
            style: TextStyle(fontSize: 11, color: PdfColors.grey500)),
        Text(userData.uname,
            style: TextStyle(
                fontSize: 13,
                color: PdfColors.black,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  static List<Widget> buildTablePages(List allList) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_PH', symbol: '', decimalDigits: 1);
    DateFormat dateFormat = DateFormat("hh:mm a");

    final headers = ['Time', 'Item', 'Qty', 'Unit Cost', 'Total Cost'];
    final data = allList.map((e) {
      return [
        dateFormat.format(e['date']),
        e['name'],
        e['quantity'] == null ? '' : e['quantity'].toString(),
        e['unitCost'] == null ? '' : currencyFormat.format(e['unitCost']),
        currencyFormat.format(e['totalCost']),
      ];
    }).toList();

    const int firstPageRows = 16; // Adjust this value for the first page
    const int rowsPerPage = 20;
    List<Widget> pages = [];

    final firstPageData = data.sublist(
        0, firstPageRows > data.length ? data.length : firstPageRows);
    pages.add(
      TableHelper.fromTextArray(
        headers: headers,
        data: firstPageData,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerLeft,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
        },
      ),
    );
    // Handle subsequent pages
    for (int i = firstPageRows; i < data.length; i += rowsPerPage) {
      final chunk = data.sublist(
          i, i + rowsPerPage > data.length ? data.length : i + rowsPerPage);
      pages.add(
        TableHelper.fromTextArray(
          headers: headers,
          data: chunk,
          border: null,
          headerStyle: TextStyle(fontWeight: FontWeight.bold),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
          cellAlignments: {
            0: Alignment.centerLeft,
            1: Alignment.centerLeft,
            2: Alignment.centerRight,
            3: Alignment.centerRight,
            4: Alignment.centerRight,
          },
        ),
      );

      if (i + rowsPerPage < data.length) {
        pages.add(SizedBox(height: 20)); // Add space between tables
      }
    }

    return pages;
  }
}
