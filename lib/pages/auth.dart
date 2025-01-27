import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/pages/login.dart';
import 'package:ka_inventory/pages/menu.dart';
// import 'package:ka_inventory/pages/menu.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: userDataBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return LoginPage();
          } else {
            // check if any user is logged in
            for (var i = 0; i < box.length; i++) {
              final user = box.getAt(i);
              if (user.isLogged) {
                // save userKey
                userKey = user.uid;
                // go to menu
                // Navigator.pushReplacementNamed(context, '/menu');
                return Menu();
                // break loop
              }
            }

            return LoginPage();
          }
        });
  }
}
