// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkinAdapter extends TypeAdapter<Skin> {
  @override
  final int typeId = 2;

  @override
  Skin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Skin(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      pictures: (fields[3] as List).cast<String>(),
      model: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Skin obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.pictures)
      ..writeByte(4)
      ..write(obj.model);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
