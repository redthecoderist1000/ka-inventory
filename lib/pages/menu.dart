import 'package:flutter/material.dart';
// import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/components/menuTile.dart';
// import 'package:ka_inventory/hive/boxes.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(height: 100),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 20),
              //   height: 150,
              //   decoration: BoxDecoration(
              //     color: Colors.blueGrey[700],
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Center(
              //     child: Text(
              //       '*profile here $userKey',
              //       style: TextStyle(
              //         fontSize: 15,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 30),
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
                      icon: Icons.shopping_cart_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, '/sales');
                      }),
                  Menutile(
                      label: 'Inventory',
                      icon: Icons.attach_money,
                      onTap: () {
                        Navigator.pushNamed(context, '/inventory');
                      }),
                  Menutile(label: 'Cash', icon: Icons.settings, onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
