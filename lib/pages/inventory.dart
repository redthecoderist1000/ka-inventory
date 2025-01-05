// import 'dart:math';

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  String base64Image = '';

  @override
  Widget build(BuildContext context) {
    List inventoryList = userDataBox.get(userKey)!.prepList +
        userDataBox.get(userKey)!.merchList;

    int prepCount = userDataBox.get(userKey)!.prepList.length;

    return Scaffold(
      appBar: const Appbar(
        title: 'Inventory',
        leading: true,
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: inventoryList.length,
            itemBuilder: (context, index) => Slidable(
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          // edit inventory
                          if (inventoryList[index]['category'] ==
                              'Prepared Food') {
                            userDataBox.get(userKey)!.prepList.removeAt(index);
                          } else {
                            userDataBox
                                .get(userKey)!
                                .merchList
                                .removeAt(index - prepCount);
                          }

                          setState(() {
                            // Save the updated data back to Hive
                            userDataBox.put(userKey, userDataBox.get(userKey));
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(inventoryList[index]['label']),
                      subtitle: Text(
                          'Quantity: ${inventoryList[index]['quantity']} ${inventoryList[index]['unit']}'),
                    ),
                  ),
                )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        onPressed: () {
          addInventory();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void addInventory() {
    List<DropdownMenuItem<dynamic>> itemCat = [
      DropdownMenuItem(
        value: 'Prepared Food',
        child: Text('Prepared Food'),
      ),
      DropdownMenuItem(
        value: 'Merchandise',
        child: Text('Merchandise'),
      ),
    ];

    List<DropdownMenuItem<dynamic>> itemUnit = [
      DropdownMenuItem(
        value: 'pcs.',
        child: Text('Pieces (pcs.)'),
      ),
      DropdownMenuItem(
        value: 'kgs.',
        child: Text('Kilos (kg.)'),
      ),
    ];

    var formKey = GlobalKey<FormState>();
    var nameCon = TextEditingController();
    var cat = '';
    var sellPriceCon = TextEditingController();
    var costCon = TextEditingController();
    var quanCon = TextEditingController();
    var unit = '';

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blueGrey[900]),
              title: const Text(
                'Add Inventory',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameCon,
                        maxLength: 20,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                        items: itemCat,
                        onChanged: (value) {
                          setState(() {
                            cat = value;
                          });
                        },
                        hint: Text('Category'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                        controller: sellPriceCon,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Selling Price',
                        ),
                      ),
                      TextFormField(
                        controller: costCon,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cost',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a cost';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: quanCon,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                        items: itemUnit,
                        onChanged: (value) {
                          setState(() {
                            unit = value;
                          });
                        },
                        hint: Text('Unit'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a unit';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      base64Image == ''
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                    height: 30,
                                    color: Colors.blueGrey,
                                    onPressed: () async {
                                      base64Image = await pickImage();
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Add Image',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Text(
                                  " (optional)",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blueGrey[200]),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.memory(
                                    base64Decode(base64Image),
                                    width: 100,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        base64Image = '';
                                      });
                                    },
                                    icon: Icon(
                                      Icons.cancel_presentation,
                                    ))
                              ],
                            ),
                      Divider(
                        color: Colors.blueGrey[100],
                        thickness: 2,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    base64Image = '';
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // add to inventory

                      // check kung anong category
                      if (cat == 'Prepared Food') {
                        userDataBox.get(userKey)!.prepList.add({
                          'label': nameCon.text,
                          'category': cat,
                          'sellPrice': int.parse(sellPriceCon.text),
                          'cost': int.parse(costCon.text),
                          'quantity': int.parse(quanCon.text),
                          'unit': unit,
                          'image': base64Image,
                        });
                      } else {
                        userDataBox.get(userKey)!.merchList.add({
                          'label': nameCon.text,
                          'category': cat,
                          'sellPrice': int.parse(sellPriceCon.text),
                          'cost': int.parse(costCon.text),
                          'quantity': int.parse(quanCon.text),
                          'unit': unit,
                          'image': base64Image,
                        });
                      }
                      setState(() {
                        // Save the updated data back to Hive
                        userDataBox.put(userKey, userDataBox.get(userKey));
                        // base64Image = '';
                      });

                      Navigator.pop(context);
                    }
                  },
                  color: Colors.green,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<String> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // Capture a photo.
    // final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();

      return base64Encode(imageBytes);
    }
    return '';
  }
}
