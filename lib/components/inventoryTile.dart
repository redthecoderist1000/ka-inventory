import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Inventorytile extends StatelessWidget {
  final String label;
  final int? quantity;
  final Function(BuildContext) onDelete;
  final Function(BuildContext) onEdit;
  final bool isMerch;

  const Inventorytile(
      {super.key,
      required this.label,
      this.quantity,
      required this.onDelete,
      required this.isMerch,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: onEdit,
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              label: 'Edit',
              borderRadius: BorderRadius.circular(10),
            ),
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              label: 'Delete',
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: isMerch
            // merch
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(label,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  trailing: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        '${quantity.toString()} pcs.',
                        style: TextStyle(fontSize: 17),
                      ),
                      quantity! < 5
                          ? Positioned(
                              top: -10,
                              right: -10,
                              child: Icon(
                                Icons.error,
                                size: 20,
                                color: Colors.red,
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              )
            // prepared
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
