import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;
  final PreferredSizeWidget? bottom;

  const Appbar(
      {super.key, required this.title, required this.leading, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      leading: leading
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 30,
              ),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueGrey[700],
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       // showDialog(
      //       //   context: context,
      //       //   builder: (BuildContext context) {
      //       //     return AlertDialog(
      //       //       title: const Text('Information'),
      //       //       content: const Text('This is a popup dialog.'),
      //       //       actions: <Widget>[
      //       //         TextButton(
      //       //           child: const Text('Close'),
      //       //           onPressed: () {
      //       //             Navigator.of(context).pop();
      //       //           },
      //       //         ),
      //       //       ],
      //       //     );
      //       //   },
      //       // );
      //     },
      //     icon: const Icon(
      //       Icons.settings_rounded,
      //       color: Colors.white,
      //       size: 20,
      //     ),
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
