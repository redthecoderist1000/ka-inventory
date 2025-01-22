import 'package:flutter/material.dart';

class Emptymerch extends StatelessWidget {
  const Emptymerch({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('There is no Merchandise yet!'),
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
