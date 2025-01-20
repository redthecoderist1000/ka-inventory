import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/components/inventoryTile.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Merchinvtab extends StatefulWidget {
  const Merchinvtab({super.key});

  @override
  State<Merchinvtab> createState() => _MerchinvtabState();
}

class _MerchinvtabState extends State<Merchinvtab> {
  @override
  Widget build(BuildContext context) {
    editInventory(data) {
      var formKey = GlobalKey<FormState>();
      var nameController = TextEditingController();
      var quantityController = TextEditingController();
      var priceController = TextEditingController();

      nameController.text = data['name'];
      quantityController.text = data['quantity'].toString();
      priceController.text = data['sellPrice'].toString();

      saveInventory() {
        if (formKey.currentState!.validate()) {
          var newData = {
            'mid': data['mid'],
            'name': nameController.text,
            'category': data['category'],
            'sellPrice': double.parse(priceController.text),
            'cost': data['cost'],
            'quantity': int.parse(quantityController.text),
            'image': data['image']
          };

          var box = userDataBox.get(userKey);

          // update merchList
          box.merchList[box.merchList.indexOf(data)] = newData;

          // update orderlist
          for (var order in box.orderList) {
            if (order['name'] == data['name']) {
              order['name'] = newData['name'];
              order['price'] = newData['sellPrice'];
            }
          }
          // save final box
          userDataBox.put(userKey, box);
          Navigator.pop(context);
        }
      }

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Text(
                'Edit Inventory',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // Text('Item: ${data['name']}'),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Quantity'),
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a quantity';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Selling Price'),
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value)! < 0) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  color: Colors.red[600],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                MaterialButton(
                  color: Colors.green[500],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: saveInventory,
                  child: Text('Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          });
    }

    return ValueListenableBuilder(
        // stream: userDataBox.watch(key: userKey),
        valueListenable: userDataBox.listenable(keys: [userKey]),
        builder: (context, box, snapshot) {
          List merchList = box.get(userKey)?.merchList ?? [];

          return Center(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: merchList.length,
                itemBuilder: (context, index) {
                  var data = merchList[index];

                  return Inventorytile(
                    label: data['name'],
                    quantity: data['quantity'],
                    isMerch: true,
                    onDelete: (context) {
                      // delete from merchList
                      box.get(userKey).merchList.removeAt(index);

                      // delete from orderList
                      box.get(userKey).orderList.removeWhere(
                          (order) => order['name'] == data['name']);

                      // save final box
                      userDataBox.put(userKey, box.get(userKey));
                    },
                    onEdit: (context) {
                      editInventory(data);
                    },
                  );
                }),
          );
        });
  }
}
