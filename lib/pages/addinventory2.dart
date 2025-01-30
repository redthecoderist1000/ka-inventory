import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';
// import 'package:ka_inventory/hive/userData.dart';

class Addinventory2 extends StatefulWidget {
  const Addinventory2({super.key});

  @override
  State<Addinventory2> createState() => _Addinventory2State();
}

class _Addinventory2State extends State<Addinventory2> {
  var nameCon = TextEditingController();
  bool isExisting = false;
  var formKey = GlobalKey<FormState>();
  String catValue = '';
  var sellPriceCon = TextEditingController();
  var costCon = TextEditingController();
  var quanCon = TextEditingController();
  var base64image = '';
  // late var existingItem = {};
  String existingID = '';

  @override
  Widget build(BuildContext context) {
    var userData = userDataBox.get(userKey);
    List inventoryList = userData.prepList + userData.merchList;

    List<String> itemList = [
      ...userData!.prepList.map((item) => item['name'].toString()),
      ...userData.merchList.map((item) => item['name'].toString())
    ];

    if (isExisting) {
      catValue = inventoryList
          .firstWhere((element) => element['name'] == nameCon.text)['category'];
    }

    List<DropdownMenuItem<dynamic>> itemCat = [
      DropdownMenuItem(
        value: 'Prepared Food',
        enabled: isExisting ? false : true,
        child: Text('Prepared Food'),
      ),
      DropdownMenuItem(
        value: 'Merchandise',
        enabled: isExisting ? false : true,
        child: Text('Merchandise'),
      ),
    ];

    setName(String value) {
      if (value.isEmpty) {
        print('empty name');
        setState(() {
          isExisting = false;
          existingID = '';
          nameCon.text = '';
        });
        return;
      }

      var existingItem = inventoryList.firstWhere(
          (element) => element['name'] == value,
          orElse: () => null);

      setState(() {
        isExisting = existingItem == null ? false : true;
        if (isExisting) {
          existingID = existingItem['category'] == 'Prepared Food'
              ? existingItem['pid']
              : existingItem['mid'];
        } else {
          existingID = '';
        }

        print(existingID);
        nameCon.text = value;
      });
    }

    addQuantity() {
      if (quanCon.text.isEmpty) {
        quanCon.text = '0';
      }
      int newQuan = int.parse(quanCon.text) + 1;
      quanCon.text = newQuan.toString();
    }

    minusQuantity() {
      if (quanCon.text.isEmpty) {
        quanCon.text = '0';
      }
      if (int.parse(quanCon.text) == 1) {
        return;
      }
      int newQuan = int.parse(quanCon.text) - 1;
      quanCon.text = newQuan.toString();
    }

    pickImage(bool isCamera) async {
      final ImagePicker picker = ImagePicker();
      // Pick an image.
      final XFile? image = await picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      // Capture a photo.
      // final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        Uint8List imageBytes = await image.readAsBytes();

        setState(() {
          base64image = base64Encode(imageBytes);
        });
      }
    }

    removeImage() {
      setState(() {
        base64image = '';
      });
    }

    addCashFlow(double amount) {
      // update cashflow
      var cashflowList = userDataBox.get(userKey).cashFlowLsit.where((element) {
        return element['date'].toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10);
      }).toList();

      DateFormat dateFormat = DateFormat("MMM dd, yyyy");

      if (cashflowList.isEmpty) {
        // empty cashflow for today,, just add purchase
        userDataBox.get(userKey).cashFlowLsit.add({
          'cid': userDataBox.get(userKey).cashFlowLsit.length + 1,
          'label': 'Purchase for ${dateFormat.format(DateTime.now())}',
          'amount': amount,
          'type': 'purchase',
          'date': DateTime.now()
        });
      } else {
        // cashflow for today exists
        // check if purchase already exists
        var purchase = cashflowList.firstWhere(
            (element) => element['type'] == 'purchase',
            orElse: () => null);

        if (purchase == null) {
          // purchase does not exist, just add purchase
          userDataBox.get(userKey).cashFlowLsit.add({
            'cid': userDataBox.get(userKey).cashFlowLsit.length + 1,
            'label': 'Purchase for ${dateFormat.format(DateTime.now())}',
            'amount': amount,
            'type': 'purchase',
            'date': DateTime.now()
          });
        } else {
          // purchase exists
          purchase['amount'] += amount;
        }
      }
      // update hive
      // userDataBox.put(userKey, userDataBox.get(userKey));
    }

    submit() {
      // print('object');

      // get index for inventory history
      int lastIndexHistory =
          userDataBox.get(userKey)!.inventoryHistory.length - 1;

      String hid = lastIndexHistory < 0
          ? '1'
          : (int.parse(userDataBox
                      .get(userKey)!
                      .inventoryHistory[lastIndexHistory]['hid']) +
                  1)
              .toString();

      if (isExisting) {
        // existing item
        if (catValue == 'Prepared Food') {
          // prepared food
          double costToAdd = double.parse(costCon.text);
          // edit prepList
          userDataBox.get(userKey)!.prepList.firstWhere(
                  (element) => element['pid'] == existingID)['totalCost'] +=
              costToAdd;

          userDataBox.get(userKey)!.inventoryHistory.add({
            'hid': hid,
            'id': existingID,
            'name': nameCon.text, //
            'category': 'Prepared Food',
            'quantity': null, //
            'unitCost': null, //
            'totalCost': costToAdd, //
            'date': DateTime.now(), //
          });
          addCashFlow(costToAdd);
        } else {
          // merchandise

          int quanToAdd = int.parse(quanCon.text);

          userDataBox.get(userKey)!.merchList.firstWhere(
                  (element) => element['mid'] == existingID)['quantity'] +=
              quanToAdd;

          // update history

          double costOriginal = userDataBox
              .get(userKey)!
              .merchList
              .firstWhere((element) => element['mid'] == existingID)['cost'];

          userDataBox.get(userKey)!.inventoryHistory.add({
            'hid': hid,
            'id': existingID,
            'name': nameCon.text,
            'category': 'Merchandise',
            'quantity': quanToAdd,
            'unitCost': costOriginal,
            'totalCost': costOriginal * quanToAdd,
            'date': DateTime.now(),
          });
          addCashFlow(costOriginal * quanToAdd);
        }
      } else {
        // new item
        if (catValue == 'Prepared Food') {
          // prepared food
          int lastIndex = userDataBox.get(userKey)!.prepList.length - 1;
          String pid = lastIndex < 0
              ? '1'
              : (int.parse(userDataBox.get(userKey)!.prepList[lastIndex]
                          ['pid']) +
                      1)
                  .toString();

          userDataBox.get(userKey)!.prepList.add({
            'pid': pid,
            'name': nameCon.text,
            'category': 'Prepared Food',
            'sellPrice': double.parse(sellPriceCon.text),
            'totalCost': double.parse(costCon.text),
            'ordersFulfilled': 0,
            'image': base64image,
          });

          // add to inventoryHistory

          userDataBox.get(userKey)!.inventoryHistory.add({
            'hid': hid,
            'id': pid,
            'name': nameCon.text,
            'category': 'Prepared Food',
            'quantity': null,
            'unitCost': null,
            'totalCost': double.parse(costCon.text),
            'date': DateTime.now(),
          });

          addCashFlow(double.parse(costCon.text));
        } else {
          // merchandise
          int lastIndex = userDataBox.get(userKey)!.merchList.length - 1;
          String mid = lastIndex < 0
              ? '1'
              : (int.parse(userDataBox.get(userKey)!.merchList[lastIndex]
                          ['mid']) +
                      1)
                  .toString();

          userDataBox.get(userKey)!.merchList.add({
            'mid': mid,
            'name': nameCon.text,
            'category': 'Merchandise',
            'quantity': int.parse(quanCon.text),
            'cost': double.parse(costCon.text), // cost per piece
            'sellPrice': double.parse(sellPriceCon.text),
            'image': base64image,
          });

          // add to inventoryHistory

          userDataBox.get(userKey)!.inventoryHistory.add({
            'hid': hid,
            'id': mid,
            'name': nameCon.text,
            'category': 'Merchandise',
            'quantity': int.parse(quanCon.text),
            'unitCost': double.parse(costCon.text),
            'totalCost': double.parse(costCon.text) * int.parse(quanCon.text),
            'date': DateTime.now(),
          });
          addCashFlow(double.parse(costCon.text) * int.parse(quanCon.text));
        }
      }

      userDataBox.put(userKey, userDataBox.get(userKey));
    }

    confirmDialog() {
      if (!formKey.currentState!.validate()) {
        return;
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Text('Are you sure you want to add this item?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  submit();
                  Navigator.popUntil(
                      context, ModalRoute.withName('/inventory'));
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    return ValueListenableBuilder(
        valueListenable: userDataBox.listenable(),
        builder: (context, box, widget) {
          return Scaffold(
            appBar: Appbar(title: 'Add Inventory', leading: true),
            body: SingleChildScrollView(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'You can choose from current inventory or add a new item',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Autocomplete(
                          optionsBuilder: (value) {
                            if (value.text.isEmpty) {
                              return itemList;
                            }
                            return itemList
                                .where((element) => element
                                    .toLowerCase()
                                    .contains(value.text.toLowerCase()))
                                .toList();
                          },
                          onSelected: (val) => setName(val.trim()),
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            return TextFormField(
                              maxLength: 30,
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              onFieldSubmitted: (value) =>
                                  setName(value.trim()),
                              onChanged: (value) => setName(value.trim()),
                              decoration: InputDecoration(
                                labelText: 'Item Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter item name';
                                }
                                return null;
                              },
                            );
                          }),
                      SizedBox(height: 20),
                      DropdownButtonFormField(
                        items: itemCat,
                        value: catValue == '' ? null : catValue,
                        onChanged: (value) {
                          setState(() {
                            catValue = value.toString();
                          });
                        },
                        disabledHint: Text(catValue),
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null ? 'Please select category' : null,
                      ),
                      isExisting
                          ? Text(
                              '\'${nameCon.text}\' already exists in $catValue',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey),
                            )
                          : SizedBox(),
                      Visibility(
                          visible: catValue == '' || nameCon.text.isEmpty
                              ? false
                              : true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),
                              isExisting
                                  ? SizedBox()
                                  : TextFormField(
                                      controller: sellPriceCon,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Selling Price',
                                      ),
                                      validator: (value) {
                                        if (!isExisting) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the Selling Price';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                              SizedBox(height: 20),
                              isExisting && catValue == 'Merchandise'
                                  ? SizedBox()
                                  : TextFormField(
                                      controller: costCon,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: catValue == 'Merchandise'
                                            ? 'Cost per Piece'
                                            : 'Total Cost',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          if (isExisting &&
                                              catValue == 'Merchandise') {
                                            return null;
                                          }
                                          return 'Please enter the cost';
                                        }
                                        return null;
                                      },
                                    ),
                              SizedBox(height: 20),
                              catValue != 'Merchandise'
                                  ? SizedBox()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: minusQuantity,
                                          icon: Icon(Icons.remove),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: quanCon,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Quantity',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (catValue == 'Merchandise') {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a quantity';
                                                }
                                                if (int.parse(value) <= 0) {
                                                  return 'Quantity cannot be equal to or less than 0';
                                                }
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: addQuantity,
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 20),
                              // image piocker
                              isExisting
                                  ? SizedBox()
                                  : base64image == ''
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.blueGrey.shade100,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.image_outlined,
                                                color: Colors.blueGrey.shade100,
                                                size: 80,
                                              ),
                                              Text('Add Image from:'),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      pickImage(true);
                                                    },
                                                    style: ButtonStyle(
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .blueGrey),
                                                    ),
                                                    child: Text(
                                                      'Camera',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text('or'),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      pickImage(false);
                                                    },
                                                    style: ButtonStyle(
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .blueGrey),
                                                    ),
                                                    child: Text(
                                                      'Gallery',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.memory(
                                                base64Decode(base64image),
                                                width: 200,
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: removeImage,
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red[600]),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                child: Text(
                                                  'Change Image',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                          ],
                                        ),
                            ],
                          )),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            )),
            bottomSheet: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 80,
              color: Colors.blueGrey[50],
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: confirmDialog,
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        });
  }
}
