import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;
  final PreferredSizeWidget? bottom;
  final String? cart;

  const Appbar(
      {super.key,
      required this.title,
      required this.leading,
      this.bottom,
      this.cart});

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
                color: Color(0xFFFFFFFF),
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
      backgroundColor: const Color(0xFF455A64),
      actions: [
        cart != null
            ? Stack(children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/order');
                    // print('order');
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                cart != '0'
                    ? Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          cart!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : SizedBox()
              ])
            : const SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
