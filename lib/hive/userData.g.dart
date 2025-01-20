// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 1;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      uname: fields[0] as String,
      password: fields[1] as String,
      prepList: fields[2] == null ? [] : (fields[2] as List).cast<dynamic>(),
      merchList: fields[3] == null ? [] : (fields[3] as List).cast<dynamic>(),
      orderList: fields[4] == null ? [] : (fields[4] as List).cast<dynamic>(),
      transactionList:
          fields[5] == null ? [] : (fields[5] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uname)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.prepList)
      ..writeByte(3)
      ..write(obj.merchList)
      ..writeByte(4)
      ..write(obj.orderList)
      ..writeByte(5)
      ..write(obj.transactionList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
