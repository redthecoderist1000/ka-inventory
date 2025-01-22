import 'package:flutter/material.dart';

class Emptyprepared extends StatelessWidget {
  const Emptyprepared({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('There is no Prepared Food yet!'),
          SizedBox(height: 10),
          MaterialButton(
            textColor: Colors.white,
            color: const Color(0xFF607D8B),
            onPressed: () {
              Navigator.pushNamed(context, '/add_inventory');
            },
            child: Text('Add Here'),
          ),
        ],
      ),
    );
  }
}
