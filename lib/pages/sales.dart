import 'dart:convert';

import 'package:flutter/material.dart';
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

    return Scaffold(
        // backgroundColor: Colors.blueGrey[100],
        appBar: const Appbar(
          title: 'Sales',
          leading: true,
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

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const Icon(
                            //   Icons.fastfood_rounded,
                            //   size: 40,
                            //   color: Colors.blueGrey,
                            // ),

                            Expanded(
                                flex: 3,
                                child: item['image'] == ''
                                    ? Expanded(
                                        flex: 3,
                                        child: Image.asset(
                                          'assets/img/logo.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : Expanded(
                                        flex: 3,
                                        // clipBehavior: Clip.hardEdge,
                                        child: Image.memory(
                                          fit: BoxFit.cover,
                                          base64Decode(item['image']),
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
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

                      return Card(
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
