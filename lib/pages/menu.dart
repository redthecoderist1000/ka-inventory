import 'package:flutter/material.dart';
import 'package:ka_inventory/components/menuTile.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  logOut() {
    userDataBox.get(userKey).isLogged = false;
    userDataBox.put(userKey, userDataBox.get(userKey));

    userKey = '';
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  logOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: logOut,
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }

  // execute background tasks

  // get sales yesterday add to cashflow list, if not yet added
  DateTime today = DateTime.now();
  String yesterday =
      DateTime.now().subtract(Duration(days: 1)).toString().substring(0, 10);
  bool isRecorded = false;
  bool isPurchaseRecorded = false;

  @override
  Widget build(BuildContext context) {
    var yesterdaySales = userDataBox
        .get(userKey)
        .transactionList
        .where((element) =>
            element['date'].toString().substring(0, 10) == yesterday)
        .toList();

    var yesterdayPurchase = userDataBox
        .get(userKey)
        .inventoryHistory
        .where((element) =>
            element['date'].toString().substring(0, 10) == yesterday)
        .toList();

    // check if yesterday sales is already recorded in cashflow
    var cashflow = userDataBox.get(userKey).cashFlowLsit.where((element) {
      return element['date'].toString().substring(0, 10) == yesterday;
    }).toList();

    cashflow.forEach((element) {
      if (element['type'] == 'sales') {
        isRecorded = true;
      }
      if (element['type'] == 'purchase') {
        isPurchaseRecorded = true;
      }
    });
    // add yesterday sales to cashflow list
    if (yesterdaySales.isNotEmpty && !isRecorded) {
      userDataBox.get(userKey).cashFlowLsit.add({
        'cid': userDataBox.get(userKey).cashFlowLsit.length + 1,
        'label': 'Sales for $yesterday',
        'amount': yesterdaySales
            .map((e) => e['price'] * e['quantity'])
            .toList()
            .reduce((value, element) => value + element),
        'type': 'sales',
        'date': DateTime.parse("$yesterday 23:59:59")
      });
      userDataBox.put(userKey, userDataBox.get(userKey));
    }
    // record yesterday purchase to cashflow list
    if (yesterdayPurchase.isNotEmpty && !isPurchaseRecorded) {
      userDataBox.get(userKey).cashFlowLsit.add({
        'cid': userDataBox.get(userKey).cashFlowLsit.length + 1,
        'label': 'Purchase for $yesterday',
        'amount': yesterdayPurchase
            .map((e) => e['totalCost'])
            .toList()
            .reduce((value, element) => value + element),
        'type': 'purchase',
        'date': DateTime.parse("$yesterday 23:59:59")
      });
      userDataBox.put(userKey, userDataBox.get(userKey));
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        logOutDialog();
      },
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.person_2_rounded,
                  size: 30, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GridView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  children: [
                    Menutile(
                        label: 'Sales',
                        icon: Icons.shopping_cart_outlined,
                        onTap: () {
                          Navigator.pushNamed(context, '/sales');
                        }),
                    Menutile(
                        label: 'Inventory',
                        icon: Icons.inventory_2_outlined,
                        onTap: () {
                          Navigator.pushNamed(context, '/inventory');
                        }),
                    Menutile(
                        label: 'Cash',
                        icon: Icons.money,
                        onTap: () {
                          Navigator.pushNamed(context, '/cash');
                        }),
                    Menutile(
                        label: 'Profit',
                        icon: Icons.auto_graph_rounded,
                        onTap: () {
                          Navigator.pushNamed(context, '/profit');
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
