import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/hive/userData.dart';
import 'package:ka_inventory/pages/inventory.dart';
import 'package:ka_inventory/pages/login.dart';
import 'package:ka_inventory/pages/menu.dart';
import 'package:ka_inventory/pages/order.dart';
import 'package:ka_inventory/pages/register.dart';
import 'package:ka_inventory/pages/sales.dart';

void main() async {
  //  init hive
  await Hive.initFlutter();

  Hive.registerAdapter(UserDataAdapter());

  // open box
  userDataBox = await Hive.openBox<UserData>('userDataBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ka-inventory',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.blueGrey[50],
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/sales': (context) => const Sales(),
        '/inventory': (context) => const Inventory(),
        '/menu': (context) => const Menu(),
        '/order': (context) => const Order(),
      },
    );
  }
}
