import 'package:flutter/material.dart';

class Itemlist extends StatelessWidget {
  final String itemName;
  final double price;
  final int quantity;
  final bool withDate;
  final String? date;
  final int? count;
  final double? totalSales;
  final String time;

  const Itemlist(
      {super.key,
      required this.itemName,
      required this.price,
      required this.withDate,
      required this.quantity,
      required this.time,
      this.date,
      this.count,
      this.totalSales});

  @override
  Widget build(BuildContext context) {
    ShapeBorder listBorder = RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400, width: .5),
        borderRadius: BorderRadius.circular(0));

    TextStyle priceStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

    if (withDate) {
      // with date tile
      return Column(
        children: [
          ListTile(
            tileColor: Colors.white,
            shape: listBorder,
            title: RichText(
                text: TextSpan(
              text: date,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text:
                        "  (${count.toString()} transaction${count! > 1 ? 's' : ''})",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.normal))
              ],
            )),
            trailing: Text(
              '+ PHP $totalSales',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            dense: true,
            shape: listBorder,
            title: RichText(
                text: TextSpan(
              text: itemName,
              style: TextStyle(color: Colors.black, fontSize: 12),
              children: [
                TextSpan(
                    text: "  x $quantity",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.normal))
              ],
            )),
            subtitle: Text(
              time,
            ),
            trailing: Text(
              'PHP $price',
              style: priceStyle,
            ),
          ),
        ],
      );
    } else {
      // regular tile
      return ListTile(
        tileColor: Colors.white,
        dense: true,
        shape: listBorder,
        title: RichText(
            text: TextSpan(
          text: itemName,
          style: TextStyle(color: Colors.black, fontSize: 12),
          children: [
            TextSpan(
                text: "  x $quantity",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.normal))
          ],
        )),
        subtitle: Text(
          time,
        ),
        trailing: Text(
          'PHP $price',
          style: priceStyle,
        ),
      );
    }
  }
}
