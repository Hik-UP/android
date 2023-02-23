// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensible_user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensibleUserDataAdapter extends TypeAdapter<SensibleUserData> {
  @override
  final int typeId = 3;

  @override
  SensibleUserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensibleUserData(
      age: fields[0] as int,
      sex: fields[3] as String,
      weight: fields[1] as int,
      tall: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SensibleUserData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.tall)
      ..writeByte(3)
      ..write(obj.sex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensibleUserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
