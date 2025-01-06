import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  Widget build(BuildContext context) {
    var prep_items = userDataBox.get(userKey)!.prepList;
    var merch_items = userDataBox.get(userKey)!.merchList;
    String orderCount = order.length.toString();

    return Scaffold(
        // backgroundColor: Colors.blueGrey[100],
        appBar: Appbar(
          title: 'Sales',
          leading: true,
          cart: orderCount,
        ),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: TabBar(
              unselectedLabelColor: Colors.blueGrey[300],
              tabs: const [
                Tab(
                  child: Text(
                    'Prepared Food',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    'Merchandise',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
            body: TabBarView(
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
                    itemCount: prep_items.length,
                    itemBuilder: (context, index) {
                      final item = prep_items[index];

                      return GestureDetector(
                        onTap: () {
                          addToOrder(index, item['image'], item['label'],
                              item['sellPrice'], item['cost']);
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: item['image'] == ''
                                      ? Image.asset(
                                          'assets/img/logo.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : Image.memory(
                                          base64Decode(item['image']),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )),
                              const SizedBox(height: 10),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  item['label'],
                                  style: TextStyle(
                                      color: Colors.blueGrey[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ),
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
                    itemCount: merch_items.length,
                    itemBuilder: (context, index) {
                      final item = merch_items[index];

                      return GestureDetector(
                        onTap: () {
                          addToOrder(index, item['image'], item['label'],
                              item['sellPrice'], item['cost']);
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const Icon(
                              //   Icons.fastfood_rounded,
                              //   size: 40,
                              //   color: Colors.blueGrey,
                              // ),
                              // const SizedBox(height: 10),
                              Expanded(
                                  flex: 3,
                                  child: item['image'] == ''
                                      ? Image.asset(
                                          'assets/img/logo.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : Image.memory(
                                          fit: BoxFit.cover,
                                          base64Decode(item['image']),
                                          width: double.infinity,
                                          height: double.infinity,
                                        )),

                              const SizedBox(height: 10),

                              Expanded(
                                flex: 1,
                                child: Text(
                                  item['label'],
                                  style: TextStyle(
                                      color: Colors.blueGrey[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  addToOrder(int index, String image, String label, double price, double cost) {
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
              label,
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

                    for (var item in order) {
                      if (item['label'] == label) {
                        // existing
                        setState(() {
                          item['quantity'] +=
                              int.parse(quantityController.text);
                          item['price'] += price;
                        });
                        itemExists = true;
                        break;
                      }
                    }

                    if (!itemExists) {
                      setState(() {
                        order.add({
                          'image': image,
                          'label': label,
                          'price': price,
                          'cost': cost,
                          'quantity': int.parse(quantityController.text),
                        });
                      });
                    }

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }
}
