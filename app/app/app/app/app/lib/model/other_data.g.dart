// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OtherDataAdapter extends TypeAdapter<OtherData> {
  @override
  final int typeId = 1;

  @override
  OtherData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OtherData(
      isFirstDownload: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OtherData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isFirstDownload);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtherDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
