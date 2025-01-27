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
        ],
      ),
    );
  }
}
