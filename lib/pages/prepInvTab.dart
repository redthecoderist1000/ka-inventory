import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/components/ifEmpty/emptyPrepared.dart';
import 'package:ka_inventory/components/inventoryTile.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Prepinvtab extends StatefulWidget {
  const Prepinvtab({super.key});

  @override
  State<Prepinvtab> createState() => _PrepinvtabState();
}

class _PrepinvtabState extends State<Prepinvtab> {
  @override
  Widget build(BuildContext context) {
    editInventory(data) {
      var formKey = GlobalKey<FormState>();
      var nameController = TextEditingController();
      var priceController = TextEditingController();

      nameController.text = data['name'];
      priceController.text = data['sellPrice'].toString();

      saveInventory() {
        if (formKey.currentState!.validate()) {
          var newData = {
            'pid': data['pid'],
            'name': nameController.text,
            'category': data['category'],
            'sellPrice': double.parse(priceController.text),
            'totalCost': data['totalCost'],
            'ordersFulfilled': data['ordersFulfilled'],
            'image': data['image']
          };

          var box = userDataBox.get(userKey);

          // update prepList
          box.prepList[box.prepList.indexOf(data)] = newData;

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
          List prepList = box.get(userKey)?.prepList ?? [];

          if (prepList.isEmpty) {
            return Emptyprepared();
          } else {
            return Center(
              child: ListView.builder(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: prepList.length,
                  itemBuilder: (context, index) {
                    var data = prepList[index];

                    return Inventorytile(
                      label: "${data['name']}",
                      isMerch: false,
                      onDelete: (context) {
                        // delte item from the preplist
                        box.get(userKey).prepList.removeAt(index);
                        // delete item from the orderList
                        box.get(userKey).orderList.removeWhere(
                            (element) => element['name'] == data['name']);
                        // update the user data box
                        userDataBox.put(userKey, box.get(userKey));
                      },
                      onEdit: (context) {
                        editInventory(data);
                      },
                    );
                  }),
            );
          }
        });
  }
}
