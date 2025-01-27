import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/hive/boxes.dart';
import 'package:ka_inventory/hive/userData.dart';
import 'package:ka_inventory/pages/addinventory2.dart';
import 'package:ka_inventory/pages/auth.dart';
import 'package:ka_inventory/pages/cash.dart';
import 'package:ka_inventory/pages/inventory.dart';
import 'package:ka_inventory/pages/login.dart';
import 'package:ka_inventory/pages/menu.dart';
import 'package:ka_inventory/pages/order.dart';
import 'package:ka_inventory/pages/profile.dart';
import 'package:ka_inventory/pages/profit.dart';
import 'package:ka_inventory/pages/purchaseHistory.dart';
import 'package:ka_inventory/pages/sales.dart';
import 'package:ka_inventory/pages/summary.dart';

void main() async {
  //  init hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  // open box
  userDataBox = await Hive.openBox<UserData>('userDataBox');

  // add first account in uerDataBox
  if (userDataBox.values.isEmpty) {
    userDataBox.put(
        'USR-1',
        UserData(
            uid: 'USR-1',
            uname: 'k4nwAl_dy0sUHhzxcvs1234',
            password: 'password',
            prepList: [
              {
                "pid": '1',
                "name": "Abodo",
                "category": "Prepared Food",
                "sellPrice": 30.0,
                "totalCost": 2973.99,
                "ordersFulfilled": 17,
                "image": ""
              },
              {
                "pid": '2',
                "name": "Spaghetti Bolognese",
                "category": "Prepared Food",
                "sellPrice": 25.0,
                "totalCost": 3120.50,
                "ordersFulfilled": 20,
                "image": ""
              },
              {
                "pid": '3',
                "name": "Chicken Adobo",
                "category": "Prepared Food",
                "sellPrice": 30.0,
                "totalCost": 2850.75,
                "ordersFulfilled": 23,
                "image": ""
              },
              {
                "pid": '4',
                "name": "Beef Tacos",
                "category": "Prepared Food",
                "sellPrice": 35.0,
                "totalCost": 3210.10,
                "ordersFulfilled": 19,
                "image": ""
              },
              {
                "pid": '5',
                "name": "Vegetable Stir-fry",
                "category": "Prepared Food",
                "sellPrice": 20.0,
                "totalCost": 2995.80,
                "ordersFulfilled": 25,
                "image": ""
              },
              {
                "pid": '6',
                "name": "Shrimp Tempura",
                "category": "Prepared Food",
                "sellPrice": 40.0,
                "totalCost": 3340.60,
                "ordersFulfilled": 18,
                "image": ""
              },
              {
                "pid": '7',
                "name": "Pasta Alfredo",
                "category": "Prepared Food",
                "sellPrice": 28.0,
                "totalCost": 3095.90,
                "ordersFulfilled": 22,
                "image": ""
              },
              {
                "pid": '8',
                "name": "Sushi Platter",
                "category": "Prepared Food",
                "sellPrice": 45.0,
                "totalCost": 3405.30,
                "ordersFulfilled": 16,
                "image": ""
              },
              {
                "pid": '9',
                "name": "Burger and Fries",
                "category": "Prepared Food",
                "sellPrice": 32.0,
                "totalCost": 3110.00,
                "ordersFulfilled": 21,
                "image": ""
              },
              {
                "pid": '10',
                "name": "Grilled Salmon",
                "category": "Prepared Food",
                "sellPrice": 50.0,
                "totalCost": 3545.70,
                "ordersFulfilled": 17,
                "image": ""
              },
              {
                "pid": '11',
                "name": "Caesar Salad",
                "category": "Prepared Food",
                "sellPrice": 18.0,
                "totalCost": 2750.40,
                "ordersFulfilled": 28,
                "image": ""
              },
              {
                "pid": '12',
                "name": "Pulled Pork Sandwich",
                "category": "Prepared Food",
                "sellPrice": 33.0,
                "totalCost": 3175.65,
                "ordersFulfilled": 20,
                "image": ""
              }
            ],
            merchList: [
              {
                "mid": '1',
                "name": "Potato Chips",
                "category": "Merchandise",
                "sellPrice": 20.0,
                "cost": 12.0,
                "quantity": 8,
                "image": ""
              },
              {
                "mid": '2',
                "name": "Chocolate Bar",
                "category": "Merchandise",
                "sellPrice": 15.0,
                "cost": 8.0,
                "quantity": 100,
                "image": ""
              },
              {
                "mid": '3',
                "name": "Energy Drink",
                "category": "Merchandise",
                "sellPrice": 25.0,
                "cost": 15.0,
                "quantity": 150,
                "image": ""
              },
              {
                "mid": '4',
                "name": "Gummy Bears",
                "category": "Merchandise",
                "sellPrice": 10.0,
                "cost": 5.0,
                "quantity": 200,
                "image": ""
              },
              {
                "mid": '5',
                "name": "Granola Bar",
                "category": "Merchandise",
                "sellPrice": 8.0,
                "cost": 4.0,
                "quantity": 3,
                "image": ""
              },
              {
                "mid": '6',
                "name": "Soda",
                "category": "Merchandise",
                "sellPrice": 5.0,
                "cost": 2.5,
                "quantity": 300,
                "image": ""
              },
              {
                "mid": '7',
                "name": "Pretzels",
                "category": "Merchandise",
                "sellPrice": 20.0,
                "cost": 10.0,
                "quantity": 180,
                "image": ""
              },
              {
                "mid": '8',
                "name": "Fruit Juice",
                "category": "Merchandise",
                "sellPrice": 12.0,
                "cost": 6.0,
                "quantity": 5,
                "image": ""
              },
              {
                "mid": '9',
                "name": "Popcorn",
                "category": "Merchandise",
                "sellPrice": 30.0,
                "cost": 18.0,
                "quantity": 2,
                "image": ""
              },
              {
                "mid": '10',
                "name": "Candy Bar",
                "category": "Merchandise",
                "sellPrice": 6.0,
                "cost": 3.0,
                "quantity": 270,
                "image": ""
              },
              {
                "mid": '11',
                "name": "Iced Tea",
                "category": "Merchandise",
                "sellPrice": 10.0,
                "cost": 5.0,
                "quantity": 1,
                "image": ""
              },
              {
                "mid": '12',
                "name": "Trail Mix",
                "category": "Merchandise",
                "sellPrice": 20.0,
                "cost": 12.0,
                "quantity": 120,
                "image": ""
              }
            ],
            orderList: [],
            transactionList: [
              {
                "tid": 1,
                "id": 1,
                "name": "Abodo",
                "price": 30.0,
                "quantity": 3,
                "isMerch": false,
                "cost": 2973.99,
                "date": DateTime.parse("2025-01-23 19:59:28.697")
              },
              {
                "tid": 2,
                "id": 4,
                "name": "Beef Tacos",
                "price": 35.0,
                "quantity": 3,
                "isMerch": false,
                "cost": 3210.1,
                "date": DateTime.parse("2025-01-23 19:59:28.697")
              },
              {
                "tid": 3,
                "id": 5,
                "name": "Vegetable Stir-fry",
                "price": 20.0,
                "quantity": 3,
                "isMerch": false,
                "cost": 2995.8,
                "date": DateTime.parse("2025-01-23 19:59:28.697")
              },
              {
                "tid": 4,
                "id": 8,
                "name": "Sushi Platter",
                "price": 45.0,
                "quantity": 3,
                "isMerch": false,
                "cost": 3405.3,
                "date": DateTime.parse("2025-01-23 19:59:28.697")
              },
              {
                "tid": 5,
                "id": 7,
                "name": "Pasta Alfredo",
                "price": 28.0,
                "quantity": 3,
                "isMerch": false,
                "cost": 3095.9,
                "date": DateTime.parse("2025-01-24 19:59:28.697")
              },
              {
                "tid": 6,
                "id": 10,
                "name": "Grilled Salmon",
                "price": 50.0,
                "quantity": 4,
                "isMerch": false,
                "cost": 3545.7,
                "date": DateTime.parse("2025-01-24 19:59:28.697")
              },
              {
                "tid": 7,
                "id": 1,
                "name": "Potato Chips",
                "price": 20.0,
                "quantity": 3,
                "isMerch": true,
                "cost": 12.0,
                "date": DateTime.parse("2025-01-24 19:59:28.697")
              },
              {
                "tid": 8,
                "id": 4,
                "name": "Gummy Bears",
                "price": 10.0,
                "quantity": 3,
                "isMerch": true,
                "cost": 5.0,
                "date": DateTime.parse("2025-01-25 19:59:28.697")
              },
              {
                "tid": 9,
                "id": 3,
                "name": "Energy Drink",
                "price": 25.0,
                "quantity": 4,
                "isMerch": true,
                "cost": 15.0,
                "date": DateTime.parse("2025-01-25 19:59:28.697")
              },
              {
                "tid": 10,
                "id": 6,
                "name": "Soda",
                "price": 5.0,
                "quantity": 3,
                "isMerch": true,
                "cost": 2.5,
                "date": DateTime.parse("2025-01-25 19:59:28.697")
              },
              {
                "tid": 11,
                "id": 7,
                "name": "Pretzels",
                "price": 20.0,
                "quantity": 3,
                "isMerch": true,
                "cost": 10.0,
                "date": DateTime.parse("2025-01-25 19:59:28.697")
              },
              {
                "tid": 12,
                "id": 10,
                "name": "Candy Bar",
                "price": 6.0,
                "quantity": 3,
                "isMerch": true,
                "cost": 3.0,
                "date": DateTime.parse("2025-01-26 19:59:28.697")
              },
              {
                "tid": 13,
                "id": 12,
                "name": "Trail Mix",
                "price": 20.0,
                "quantity": 4,
                "isMerch": true,
                "cost": 12.0,
                "date": DateTime.parse("2025-01-26 19:59:28.697")
              },
              {
                "tid": 14,
                "id": 11,
                "name": "Iced Tea",
                "price": 10.0,
                "quantity": 1,
                "isMerch": true,
                "cost": 5.0,
                "date": DateTime.parse("2025-01-26 19:59:28.697")
              },
              {
                "tid": 15,
                "id": 1,
                "name": "Abodo",
                "price": 30.0,
                "quantity": 4,
                "isMerch": false,
                "cost": 2973.99,
                "date": DateTime.parse("2025-01-26 19:59:50.940")
              },
              {
                "tid": 16,
                "id": 3,
                "name": "Chicken Adobo",
                "price": 30.0,
                "quantity": 2,
                "isMerch": false,
                "cost": 2850.75,
                "date": DateTime.parse("2025-01-27 20:00:50.442")
              },
              {
                "tid": 17,
                "id": 6,
                "name": "Soda",
                "price": 5.0,
                "quantity": 3,
                "isMerch": true,
                "cost": 2.5,
                "date": DateTime.parse("2025-01-27 20:00:50.442")
              },
              {
                "tid": 18,
                "id": 10,
                "name": "Grilled Salmon",
                "price": 50.0,
                "quantity": 3,
                "isMerch": false,
                "cost": 3545.7,
                "date": DateTime.parse("2025-01-27 20:00:50.442")
              },
              {
                "tid": 19,
                "id": 11,
                "name": "Caesar Salad",
                "price": 18.0,
                "quantity": 4,
                "isMerch": false,
                "cost": 2750.4,
                "date": DateTime.parse("2025-01-27 20:00:50.442")
              }
            ],
            cashFlowLsit: [],
            isLogged: false,
            inventoryHistory: [
              {
                "hid": '1',
                "id": '1',
                "name": "Potato Chips",
                "category": "Merchandise",
                "quantity": 60,
                "unitCost": 12.0,
                "totalCost": 720.0,
                "date": DateTime(2025, 1, 23, 10, 30, 20, 123)
              },
              {
                "hid": '2',
                "id": '2',
                "name": "Chocolate Bar",
                "category": "Merchandise",
                "quantity": 70,
                "unitCost": 8.0,
                "totalCost": 560.0,
                "date": DateTime(2025, 1, 23, 14, 45, 30, 456)
              },
              {
                "hid": '3',
                "id": '3',
                "name": "Energy Drink",
                "category": "Merchandise",
                "quantity": 90,
                "unitCost": 15.0,
                "totalCost": 1350.0,
                "date": DateTime(2025, 1, 23, 17, 55, 40, 789)
              },
              {
                "hid": '4',
                "id": '4',
                "name": "Gummy Bears",
                "category": "Merchandise",
                "quantity": 100,
                "unitCost": 5.0,
                "totalCost": 500.0,
                "date": DateTime(2025, 1, 24, 08, 35, 49, 164)
              },
              {
                "hid": '5',
                "id": '5',
                "name": "Granola Bar",
                "category": "Merchandise",
                "quantity": 120,
                "unitCost": 4.0,
                "totalCost": 480.0,
                "date": DateTime(2025, 1, 24, 10, 50, 30, 654)
              },
              {
                "hid": '6',
                "id": '6',
                "name": "Soda",
                "category": "Merchandise",
                "quantity": 110,
                "unitCost": 2.5,
                "totalCost": 275.0,
                "date": DateTime(2025, 1, 24, 13, 25, 40, 987)
              },
              {
                "hid": '7',
                "id": '7',
                "name": "Pretzels",
                "category": "Merchandise",
                "quantity": 80,
                "unitCost": 10.0,
                "totalCost": 800.0,
                "date": DateTime(2025, 1, 25, 11, 35, 20, 789)
              },
              {
                "hid": '8',
                "id": '8',
                "name": "Fruit Juice",
                "category": "Merchandise",
                "quantity": 130,
                "unitCost": 6.0,
                "totalCost": 780.0,
                "date": DateTime(2025, 1, 25, 15, 10, 30, 654)
              },
              {
                "hid": '9',
                "id": '9',
                "name": "Popcorn",
                "category": "Merchandise",
                "quantity": 70,
                "unitCost": 18.0,
                "totalCost": 1260.0,
                "date": DateTime(2025, 1, 25, 18, 25, 45, 987)
              },
              {
                "hid": '10',
                "id": '10',
                "name": "Candy Bar",
                "category": "Merchandise",
                "quantity": 150,
                "unitCost": 3.0,
                "totalCost": 450.0,
                "date": DateTime(2025, 1, 26, 08, 30, 55, 432)
              },
              {
                "hid": '11',
                "id": '11',
                "name": "Iced Tea",
                "category": "Merchandise",
                "quantity": 100,
                "unitCost": 5.0,
                "totalCost": 500.0,
                "date": DateTime(2025, 1, 26, 11, 45, 40, 567)
              },
              {
                "hid": '12',
                "id": '12',
                "name": "Trail Mix",
                "category": "Merchandise",
                "quantity": 90,
                "unitCost": 12.0,
                "totalCost": 1080.0,
                "date": DateTime(2025, 1, 26, 14, 55, 30, 654)
              },
              {
                "hid": '13',
                "id": '1',
                "name": "Abodo",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 2973.99,
                "date": DateTime(2025, 1, 24, 9, 45, 30, 123)
              },
              {
                "hid": '14',
                "id": '2',
                "name": "Spaghetti Bolognese",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 3120.50,
                "date": DateTime(2025, 1, 24, 12, 30, 22, 456)
              },
              {
                "hid": '15',
                "id": '3',
                "name": "Chicken Adobo",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 2850.75,
                "date": DateTime(2025, 1, 24, 14, 15, 45, 987)
              },
              {
                "hid": '16',
                "id": '4',
                "name": "Beef Tacos",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 3210.10,
                "date": DateTime(2025, 1, 24, 16, 30, 30, 654)
              },
              {
                "hid": '17',
                "id": '5',
                "name": "Vegetable Stir-fry",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 2995.80,
                "date": DateTime(2025, 1, 25, 10, 50, 55, 321)
              },
              {
                "hid": '18',
                "id": '6',
                "name": "Shrimp Tempura",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 3340.60,
                "date": DateTime(2025, 1, 25, 13, 55, 40, 654)
              },
              {
                "hid": '19',
                "id": '7',
                "name": "Pasta Alfredo",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 3095.90,
                "date": DateTime(2025, 1, 25, 15, 40, 12, 987)
              },
              {
                "hid": '20',
                "id": '8',
                "name": "Sushi Platter",
                "category": "Prepared Food",
                "quantity": null,
                "unitCost": null,
                "totalCost": 3405.30,
                "date": DateTime(2025, 1, 26, 08, 25, 30, 654)
              }
            ]));
  }

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
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const Auth(),
        '/login': (context) => const LoginPage(),
        '/sales': (context) => const Sales(),
        '/inventory': (context) => const Inventory(),
        '/menu': (context) => const Menu(),
        '/order': (context) => const Order(),
        '/add_inventory': (context) => const Addinventory2(),
        '/summary': (context) => const Summary(),
        '/purchase_history': (context) => const Purchasehistory(),
        '/profit': (context) => const Profit(),
        '/cash': (context) => const Cash(),
        '/profile': (context) => const Profile(),
      },
    );
  }
}
