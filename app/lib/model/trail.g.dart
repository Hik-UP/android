// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrailAdapter extends TypeAdapter<Trail> {
  @override
  final int typeId = 0;

  @override
  Trail read(BinaryReader reader) {
    return Trail();
  }

  @override
  void write(BinaryWriter writer, Trail obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.pictures)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.distance)
      ..writeByte(9)
      ..write(obj.uphill)
      ..writeByte(10)
      ..write(obj.downhill)
      ..writeByte(11)
      ..write(obj.tools)
      ..writeByte(12)
      ..write(obj.relatedArticles)
      ..writeByte(13)
      ..write(obj.labels)
      ..writeByte(14)
      ..write(obj.geoJSON);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
