// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_swipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SwipeAdapter extends TypeAdapter<Swipe> {
  @override
  final int typeId = 2;

  @override
  Swipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Swipe(
      (fields[0] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Swipe obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.uidList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
