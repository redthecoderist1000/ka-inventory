import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/components/purchase_history/itemList.dart';

class PurchaseHistoryList extends StatelessWidget {
  final List transList;
  const PurchaseHistoryList({super.key, required this.transList});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('MMM dd');
    DateFormat formatterTime = DateFormat('hh:mm a');

    int getCount(curDate) {
      int count = transList
          .where((element) =>
              element['date'].toString().substring(0, 10) == curDate)
          .length;

      return count;
    }

    double getTotalSales(curDate) {
      double totalSales = 0;

      for (var item in transList) {
        var date = item['date'].toString().substring(0, 10);
        if (date == curDate) {
          totalSales += item['quantity'] * item['price'];
        }
      }

      return totalSales;
    }

    return ListView.builder(
        itemCount: transList.length,
        itemBuilder: (context, index) {
          var item = transList[index];
          var curDate = item['date'].toString().substring(0, 10);
          var nxtDate = index > 0
              ? transList[index - 1]['date'].toString().substring(0, 10)
              : '';

          if (index == 0) {
            // fisrt item

            return Itemlist(
              itemName: item['name'],
              price: item['price'] * item['quantity'],
              quantity: item['quantity'],
              time: formatterTime.format(item['date']),
              withDate: true,
              date: formatter.format(item['date']),
              count: getCount(curDate),
              totalSales: getTotalSales(curDate),
            );
          }

          if (curDate != nxtDate) {
            return Itemlist(
              itemName: item['name'],
              price: item['price'] * item['quantity'],
              quantity: item['quantity'],
              time: formatterTime.format(item['date']),
              count: getCount(curDate),
              withDate: true,
              date: formatter.format(item['date']),
              totalSales: getTotalSales(curDate),
            );
          }
          return Itemlist(
              itemName: item['name'],
              quantity: item['quantity'],
              time: formatterTime.format(item['date']),
              price: item['price'] * item['quantity'],
              withDate: false);
        });
  }
}
