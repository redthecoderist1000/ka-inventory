import 'dart:convert';

import 'package:flutter/material.dart';

class Salestile extends StatelessWidget {
  final String name;
  final String image;
  final Function() onTap;

  const Salestile(
      {super.key,
      required this.name,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 3,
                child: image == ''
                    ? Image.asset(
                        'assets/img/logo.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Image.memory(
                        base64Decode(image),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
