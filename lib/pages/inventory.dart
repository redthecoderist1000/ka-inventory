import 'package:flutter/material.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/components/prepMerchTab.dart';
import 'package:ka_inventory/pages/merchInvTab.dart';
import 'package:ka_inventory/pages/prepInvTab.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  String base64Image = '';
  int test = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(
          title: 'Inventory',
          leading: true,
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_inventory');
              },
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Add Item',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Prepmerchtab(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(clipBehavior: Clip.antiAlias, children: [
                Prepinvtab(),
                Merchinvtab(),
              ]),
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
              backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/purchase_history');
            },
            child: Text(
              'Purchase History',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }
}
