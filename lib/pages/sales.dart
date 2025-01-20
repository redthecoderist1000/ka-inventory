import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/components/prepMerchTab.dart';
import 'package:ka_inventory/components/salestile.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userDataBox.listenable(keys: [userKey]),
      builder: (context, box, child) {
        String orderCount = box.get(userKey)!.orderList.length.toString();

        return Scaffold(
            appBar: Appbar(
              title: 'Sales',
              leading: true,
              cart: orderCount,
            ),
            body: DefaultTabController(
              length: 2,
              child: Column(children: [
                Prepmerchtab(),
                Expanded(
                  child: TabBarView(
                    children: [
                      // prepared food tab
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: box.get(userKey)!.prepList.length,
                          itemBuilder: (context, index) {
                            final item = box.get(userKey)!.prepList[index];

                            return Salestile(
                              name: item['name'],
                              image: item['image'],
                              onTap: () {
                                addToOrder(
                                    index,
                                    item['pid'],
                                    item['image'],
                                    item['name'],
                                    item['sellPrice'],
                                    item['totalCost'],
                                    false);
                              },
                            );
                          },
                        ),
                      ),
                      // merchandise tab
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          // itemCount: box.get(userKey)!.merchList.length,
                          itemCount: box
                              .get(userKey)!
                              .merchList
                              .where(
                                  (item) => item['quantity'] > 0 ? true : false)
                              .length,
                          itemBuilder: (context, index) {
                            // final item = box.get(userKey)!.merchList[index];
                            final filteredMerchList = box
                                .get(userKey)!
                                .merchList
                                .where((item) =>
                                    item['quantity'] > 0 ? true : false)
                                .toList();
                            final item = filteredMerchList[index];

                            final filtered_index =
                                box.get(userKey)!.merchList.indexOf(item);

                            return Salestile(
                                name: item['name'],
                                image: item['image'],
                                onTap: () {
                                  addToOrder(
                                      filtered_index,
                                      item['mid'],
                                      item['image'],
                                      item['name'],
                                      item['sellPrice'],
                                      item['cost'],
                                      true);
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
              ]),
            ),
            bottomSheet: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              width: double.infinity,
              color: Colors.transparent,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/summary');
                },
                child: Text(
                  'Summary',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ));
      },
    );
  }

  addToOrder(int index, String id, String image, String name, double price,
      double cost, bool isMerch) {
    var quantityController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    quantityController.text = '1';

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              name,
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.blueGrey[900]),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  image == ''
                      ? Image.asset(
                          'assets/img/logo.png',
                        )
                      : Container(
                          height: 250,
                          width: 300,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Image.memory(base64Decode(image),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity),
                        ),
                  Text('Quantity:'),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (int.parse(value!) <= 0) {
                          return 'Quantity cannot be lower than 0';
                        }
                        if (isMerch &&
                            int.parse(value) >
                                userDataBox.get(userKey)!.merchList[index]
                                    ['quantity']) {
                          return 'Maximum quantity reached. Items left in stock: ${userDataBox.get(userKey)!.merchList[index]['quantity']}';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            height: 80,
                            color: Colors.red,
                            onPressed: () {
                              if (int.parse(quantityController.text) > 1) {
                                quantityController.text =
                                    (int.parse(quantityController.text) - 1)
                                        .toString();
                              }
                            },
                            child: Icon(
                              Icons.remove_outlined,
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            height: 80,
                            color: Colors.green,
                            onPressed: () {
                              quantityController.text =
                                  (int.parse(quantityController.text) + 1)
                                      .toString();
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blueGrey[300]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add to Order',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    bool itemExists = false;
                    List order = userDataBox.get(userKey)!.orderList;

                    for (var item in order) {
                      if (item['name'] == name) {
                        item['quantity'] += int.parse(quantityController.text);
                        // item['price'] += price;
                        itemExists = true;

                        userDataBox.get(userKey)!.orderList = order;
                        userDataBox.put(userKey, userDataBox.get(userKey));

                        break;
                      }
                    }

                    if (!itemExists) {
                      userDataBox.get(userKey)!.orderList.add({
                        'id': id,
                        'image': image,
                        'name': name,
                        'price': price, // Ensure price is not null
                        'cost': cost,
                        'isMerch': isMerch,
                        'quantity': int.parse(quantityController.text),
                      });
                      userDataBox.get(userKey)!.orderList = order;
                      userDataBox.put(userKey, userDataBox.get(userKey));
                    }

                    // userDataBox.get(userKey)!.orderList = order;
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }
}
