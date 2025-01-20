import 'package:flutter/material.dart';

class Prepmerchtab extends StatelessWidget implements PreferredSizeWidget {
  const Prepmerchtab({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      unselectedLabelColor: Colors.blueGrey[300],
      tabs: const [
        Tab(
          child: Text(
            'Prepared Food',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Tab(
          child: Text(
            'Merchandise',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
