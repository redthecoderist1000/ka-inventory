import 'package:flutter/material.dart';

class Salestile extends StatelessWidget {
  const Salestile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Icon(
              Icons.fastfood_rounded,
              size: 40,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Text(
          'Label',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
      ],
    );
  }
}
