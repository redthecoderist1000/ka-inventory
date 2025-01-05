import 'package:hive_flutter/hive_flutter.dart';

class db {
  List KainventoryList = [];

  // reference hive box
  final dataBox = Hive.box('kainventory');
}
