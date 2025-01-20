import 'package:flutter/material.dart';
// import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/components/menuTile.dart';
// import 'package:ka_inventory/hive/boxes.dart';
// import 'package:ka_inventory/hive/boxes.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    // print(userKey);
    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
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
    );
  }
}
