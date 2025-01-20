import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/components/orderTile.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => OrderState();
}

class OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    onSlide(context, index) {
      userDataBox.get(userKey)!.orderList.removeAt(index);
      userDataBox.put(userKey, userDataBox.get(userKey));
    }

    increment(index, isMerch, name) {
      if (isMerch) {
        int stock = userDataBox
            .get(userKey)
            .merchList
            .firstWhere((element) => element['name'] == name)['quantity'];

        if (userDataBox.get(userKey)!.orderList[index]['quantity'] < stock) {
          userDataBox.get(userKey)!.orderList[index]['quantity']++;
          userDataBox.put(userKey, userDataBox.get(userKey));
        }
      } else {
        userDataBox.get(userKey)!.orderList[index]['quantity']++;
        userDataBox.put(userKey, userDataBox.get(userKey));
      }
    }

    decrement(index) {
      if (userDataBox.get(userKey)!.orderList[index]['quantity'] > 1) {
        userDataBox.get(userKey)!.orderList[index]['quantity']--;
        userDataBox.put(userKey, userDataBox.get(userKey));
      }
    }

    showSuccess() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Transaction successful'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('OK'))
              ],
            );
          });
    }

    checkOut(box) {
      bool hasExceededStock = false;
      //  check stock
      for (var item in box.get(userKey).orderList) {
        if (item['isMerch']) {
          if (item['quantity'] >
              (item['isMerch']
                  ? box.get(userKey).merchList.firstWhere(
                      (element) => element['name'] == item['name'])['quantity']
                  : box.get(userKey).prepList.firstWhere((element) =>
                      element['name'] == item['name'])['quantity'])) {
            hasExceededStock = true;
            break;
          }
        }
      }

      if (box.get(userKey).orderList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('No items to checkout',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } else if (hasExceededStock && box.get(userKey).orderList.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Some items have exceeded stock',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } else {
        // update transatcionlist

        List orderList = box.get(userKey).orderList;

        for (var item in orderList) {
          userDataBox.get(userKey).transactionList.add({
            // 'user': userKey,
            'id': item['id'],
            'name': item['name'],
            'price': item['price'],
            'quantity': item['quantity'],
            'isMerch': item['isMerch'],
            'date': DateTime.now()
          });
        }

        // last stock
        for (var item in box.get(userKey).orderList) {
          if (item['isMerch']) {
            // for decrementing quantity
            box.get(userKey).merchList.firstWhere(
                    (element) => element['name'] == item['name'])['quantity'] -=
                item['quantity'];
          } else {
            // for decrementing quantity
            box.get(userKey).prepList.firstWhere((element) =>
                    element['name'] == item['name'])['ordersFulfilled'] +=
                item['quantity'];
          }
        }

        //update actual hive db
        box.put(userKey, box.get(userKey));

        // clear orderList
        box.get(userKey).orderList.clear();
        showSuccess();
      }
    }

    return Scaffold(
      appBar: Appbar(title: 'Order Summary', leading: true),
      body: ValueListenableBuilder(
          valueListenable: userDataBox.listenable(keys: [userKey]),
          builder: (context, box, child) {
            var order = box.get(userKey)!.orderList;

            return SafeArea(
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

                          return Ordertile(
                            name: item['name'],
                            image: item['image'],
                            price: item['price'],
                            onSlide: (context) {
                              onSlide(context, index);
                            },
                            increment: () {
                              increment(index, item['isMerch'], item['name']);
                            },
                            decrement: () {
                              decrement(index);
                            },
                            quantity: item['quantity'] ?? 0,
                            isMerch: item['isMerch'],
                          );
                        },
                      )),
                SizedBox(
                  height: 60,
                ),
              ],
            ));
          }),
      bottomSheet: ValueListenableBuilder(
          valueListenable: userDataBox.listenable(keys: [userKey]),
          builder: (context, box, child) {
            double total = 0;

            for (var item in box.get(userKey).orderList) {
              total += (item['quantity'] * item['price']);
            }

            return Container(
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
                    onPressed: () {
                      checkOut(box);
                    },
                  ))
                ],
              ),
            );
          }),
    );
  }
}
