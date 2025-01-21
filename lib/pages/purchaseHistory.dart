import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/components/purchase_history/purchaseHistoryList.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Purchasehistory extends StatelessWidget {
  const Purchasehistory({super.key});

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat = NumberFormat.currency(
        locale: 'en_PH', symbol: 'PHP ', decimalDigits: 1);
    var transList = userDataBox.get(userKey).transactionList;

    transList.sort((a, b) {
      DateTime dateA = a['date'];
      DateTime dateB = b['date'];
      return dateB.compareTo(dateA);
    });

    double totalSales = 0;

    for (var i = 0; i < transList.length; i++) {
      totalSales += transList[i]['price'] * transList[i]['quantity'];
    }

    return Scaffold(
      appBar: Appbar(title: 'Purchase History', leading: true),
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
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
                          Text('Total Sales:'),
                          Text(
                            currencyFormat.format(totalSales),
                            style: TextStyle(
                                color:
                                    totalSales > 0 ? Colors.green : Colors.red,
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
            Expanded(
              child: PurchaseHistoryList(transList: transList),
            ),
          ],
        ),
      )),
    );
  }
}
