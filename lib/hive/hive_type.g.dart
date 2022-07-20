// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyTypeAdapter extends TypeAdapter<MyType> {
  @override
  final int typeId = 1;

  @override
  MyType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyType(
      fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MyType obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
