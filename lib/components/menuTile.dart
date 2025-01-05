import 'package:flutter/material.dart';

class Menutile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onTap;
  const Menutile(
      {super.key,
      required this.label,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              elevation: 0,
              child: Icon(
                icon,
                size: 40,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
