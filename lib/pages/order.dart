import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => OrderState();
}

class OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    double total = 0;

    for (var item in order) {
      total += item['price'] * item['quantity'];
    }

    return Scaffold(
      appBar: Appbar(title: 'Order Summary', leading: true),
      body: SafeArea(
          child: Column(
        children: [
          order.isEmpty
              ? Center(
                  child: Text('No order yet'),
                )
              : Expanded(
                  child: ListView.builder(
                  itemCount: order.length,
                  itemBuilder: (context, index) {
                    final item = order[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: DrawerMotion(), children: [
                          SlidableAction(
                            label: 'Delete',
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            onPressed: (context) {
                              setState(() {
                                order.removeAt(index);
                              });
                            },
                          )
                        ]),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          height: 125,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //     bottomLeft: Radius.circular(20),
                            //     topLeft: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              item['image'] == ''
                                  ? Image.asset(
                                      'assets/img/logo.png',
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: double.infinity,
                                    )
                                  : Image.memory(
                                      base64Decode(item['image']),
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: double.infinity,
                                    ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['label'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₱ ${item['price'].toString()}',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              // width: 70,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (item['quantity'] >
                                                            1) {
                                                          setState(() {
                                                            order[index]
                                                                ['quantity']--;
                                                          });
                                                        }
                                                      },
                                                      child:
                                                          Icon(Icons.remove)),
                                                  VerticalDivider(
                                                    thickness: 1,
                                                  ),
                                                  Text(item['quantity']
                                                      .toString()),
                                                  VerticalDivider(
                                                    color: Colors.black,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          order[index]
                                                              ['quantity']++;
                                                        });
                                                      },
                                                      child: Icon(Icons.add)),
                                                ],
                                              ),
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
                  },
                )),
          SizedBox(
            height: 60,
          ),
        ],
      )),
      bottomSheet: Container(
        height: 60,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.blueGrey,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Total '),
                    Text(
                      '₱${total.toStringAsFixed(2)} ',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )),
            Expanded(
                child: MaterialButton(
              height: double.infinity,
              color: Colors.blueGrey,
              child: Text(
                'Checkout',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ))
          ],
        ),
      ),
    );
  }
}
