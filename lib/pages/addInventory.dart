import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Addinventory extends StatefulWidget {
  const Addinventory({super.key});

  @override
  State<Addinventory> createState() => _AddinventoryState();
}

class _AddinventoryState extends State<Addinventory> {
  var formKey = GlobalKey<FormState>();
  var nameCon = TextEditingController();
  var cat = '';
  var sellPriceCon = TextEditingController();
  var costCon = TextEditingController();
  var quanCon = TextEditingController();
  var base64image = '';

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

  @override
  Widget build(BuildContext context) {
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

    saveInventory() {
      if (formKey.currentState!.validate()) {
        if (cat == 'Prepared Food') {
          // save to prepared food box
          // var prepList = userDataBox.get(userKey)!.prepList;
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
            'category': cat,
            'sellPrice': double.parse(sellPriceCon.text),
            'totalCost': double.parse(costCon.text),
            'ordersFulfilled': 0,
            'image': base64image,
          });
        } else {
          // save to merchandise box
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
            'category': cat,
            'sellPrice': double.parse(sellPriceCon.text),
            'cost': double.parse(costCon.text),
            'quantity': int.parse(quanCon.text),
            'image': base64image,
          });
        }
        userDataBox.put(userKey, userDataBox.get(userKey));

        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: Appbar(title: "Add Inventory", leading: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: nameCon,
                        maxLength: 30,
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
                      SizedBox(height: 20),
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
                      Visibility(
                          visible:
                              cat == '' || nameCon.text.isEmpty ? false : true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                controller: sellPriceCon,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Selling Price',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the Selling Price';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: costCon,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: cat == 'Merchandise'
                                      ? 'Cost per Piece'
                                      : 'Total Cost',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the cost';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              cat != 'Merchandise'
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
                                          width: 100,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: quanCon,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Quantity',
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (cat == 'Merchandise') {
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
                              base64image == ''
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  pickImage(true);
                                                },
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blueGrey),
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
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blueGrey),
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
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                            ),
                                            child: Text(
                                              'Change Image',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      ],
                                    ),
                            ],
                          )),
                      SizedBox(height: 80),
                    ],
                  ))
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 80,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: saveInventory,
          child: Text(
            'Done',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
