import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Ordertile extends StatelessWidget {
  final String name;
  final String image;
  final double price;
  final int quantity;
  final Function(BuildContext) onSlide;
  final Function() increment;
  final Function() decrement;
  final bool isMerch;

  const Ordertile(
      {super.key,
      required this.name,
      required this.image,
      required this.price,
      required this.onSlide,
      required this.increment,
      required this.decrement,
      required this.quantity,
      required this.isMerch});

  @override
  Widget build(BuildContext context) {
    int stock;
    if (isMerch) {
      stock = userDataBox
          .get(userKey)
          .merchList
          .firstWhere((element) => element['name'] == name)['quantity'];
    } else {
      stock = 0;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: DrawerMotion(), children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(10),
            label: 'Delete',
            backgroundColor: Colors.red,
            onPressed: onSlide,
          )
        ]),
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 125,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: isMerch
                ? stock < quantity
                    ? Border.all(color: Colors.red, width: 2)
                    : Border.all(style: BorderStyle.none)
                : Border.all(style: BorderStyle.none),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.hardEdge,
                children: [
                  image == ''
                      ? Image.asset(
                          'assets/img/logo.png',
                          fit: BoxFit.cover,
                          width: 80,
                          height: double.infinity,
                        )
                      : Image.memory(
                          base64Decode(image),
                          fit: BoxFit.cover,
                          width: 80,
                          height: double.infinity,
                        ),
                  isMerch
                      ? Positioned(
                          bottom: 0,
                          child: Container(
                            width: 1000,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Text(
                              'Items left: ${stock.toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₱ ${price.toString()}',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  // width: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: decrement,
                                          child: Icon(Icons.remove)),
                                      VerticalDivider(
                                        thickness: 1,
                                      ),
                                      Text(quantity.toString()),
                                      VerticalDivider(
                                        color: Colors.black,
                                      ),
                                      GestureDetector(
                                          onTap: increment,
                                          child: Icon(Icons.add)),
                                    ],
                                  ),
                                ),
                                isMerch
                                    ? quantity > stock
                                        ? Text(
                                            'Quantity exceeds stock',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Container()
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
