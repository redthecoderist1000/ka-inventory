import 'package:hive/hive.dart';

part 'userData.g.dart';

@HiveType(typeId: 1)
class UserData {
  UserData({
    required this.uname,
    required this.password,
    required this.prepList,
    required this.merchList,
    required this.orderList,
    required this.transactionList,
  });

  @HiveField(0)
  String uname;

  @HiveField(1)
  String password;

  @HiveField(2, defaultValue: [])
  List prepList;

  @HiveField(3, defaultValue: [])
  List merchList;

  @HiveField(4, defaultValue: [])
  List orderList;

  @HiveField(5, defaultValue: [])
  List transactionList;
}
