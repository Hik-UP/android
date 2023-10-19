// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_fields.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrailFieldsAdapter extends TypeAdapter<TrailFields> {
  @override
  final int typeId = 4;

  @override
  TrailFields read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrailFields(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      description: fields[3] as String,
      pictures: (fields[4] as List).cast<String>(),
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      difficulty: fields[7] as int,
      duration: fields[8] as int,
      distance: fields[9] as int,
      uphill: fields[10] as int,
      downhill: fields[11] as int,
      tools: (fields[12] as List).cast<String>(),
      relatedArticles: (fields[13] as List).cast<String>(),
      labels: (fields[14] as List).cast<String>(),
      geoJSON: fields[15] as String,
      comments: (fields[16] as List).cast<Comment>(),
      imageAsset: fields[17] as String,
      price: fields[18] as int,
      openTime: fields[19] as String,
      closeTime: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrailFields obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.pictures)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.distance)
      ..writeByte(10)
      ..write(obj.uphill)
      ..writeByte(11)
      ..write(obj.downhill)
      ..writeByte(12)
      ..write(obj.tools)
      ..writeByte(13)
      ..write(obj.relatedArticles)
      ..writeByte(14)
      ..write(obj.labels)
      ..writeByte(15)
      ..write(obj.geoJSON)
      ..writeByte(16)
      ..write(obj.comments)
      ..writeByte(17)
      ..write(obj.imageAsset)
      ..writeByte(18)
      ..write(obj.price)
      ..writeByte(19)
      ..write(obj.openTime)
      ..writeByte(20)
      ..write(obj.closeTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailFieldsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrailListAdapter extends TypeAdapter<TrailList> {
  @override
  final int typeId = 5;

  @override
  TrailList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrailList(
      trails: (fields[0] as List).cast<TrailFields>(),
    );
  }

  @override
  void write(BinaryWriter writer, TrailList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.trails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
