import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Trail {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> pictures;

  @HiveField(4)
  final double latitude;

  @HiveField(5)
  final double longitude;

  @HiveField(6)
  final int difficulty;

  @HiveField(7)
  final int duration;

  @HiveField(8)
  final int distance;

  @HiveField(9)
  final int uphill;

  @HiveField(10)
  final int downhill;

  @HiveField(11)
  final List<String> tools;

  @HiveField(12)
  final List<String> relatedArticles;

  @HiveField(13)
  final List<String> labels;

  @HiveField(14)
  final String geoJSON;

  Trail(
      {required this.id,
      required this.name,
      required this.description,
      required this.pictures,
      required this.latitude,
      required this.longitude,
      required this.difficulty,
      required this.duration,
      required this.distance,
      required this.uphill,
      required this.downhill,
      required this.tools,
      required this.relatedArticles,
      required this.labels,
      required this.geoJSON});

  static Trail fromMap({
    required Map<String, dynamic> data,
  }) {
    return Trail(
        id: data["id"],
        name: data["name"],
        description: data["description"],
        pictures: data["pictures"],
        latitude: data["latitude"],
        longitude: data["longitude"],
        difficulty: data["difficulty"],
        duration: data["duration"],
        distance: data["distance"],
        uphill: data["uphill"],
        downhill: data["downhill"],
        tools: data["tools"],
        relatedArticles: data["relatedArticles"],
        labels: data["labels"],
        geoJSON: data["geoJSON"]);
  }

  static printTrain({required Trail trail}) {
    print(
        "${trail.id} ==> ${trail.name} ==> ${trail.description} ==> ${trail.pictures} ==> ${trail.latitude} ==> ${trail.longitude} ==> ${trail.difficulty} ==> ${trail.duration} ==> ${trail.distance} ==> ${trail.uphill} ==> ${trail.downhill} ==> ${trail.tools} ==> ${trail.relatedArticles} ==> ${trail.labels} ==> ${trail.geoJSON}");
  }

  static Trail copy({required Trail trail}) {
    return Trail(
        id: trail.id,
        name: trail.name,
        description: trail.description,
        pictures: trail.pictures,
        latitude: trail.latitude,
        longitude: trail.longitude,
        difficulty: trail.difficulty,
        duration: trail.duration,
        distance: trail.distance,
        uphill: trail.uphill,
        downhill: trail.downhill,
        tools: trail.tools,
        relatedArticles: trail.relatedArticles,
        labels: trail.labels,
        geoJSON: trail.geoJSON);
  }
}
