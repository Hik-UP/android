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
      id: data["id"] ?? "",
      name: data["name"] ?? "",
      description: data["description"] ?? "",
      pictures: (data["pictures"] as List).map((e) => e as String).toList(),
      latitude: data["latitude"] ?? 0,
      longitude: data["longitude"] ?? 0,
      difficulty: data["difficulty"] ?? 0,
      duration: data["duration"] ?? 0,
      distance: data["distance"] ?? 0,
      uphill: data["uphill"] ?? 0,
      downhill: data["downhill"] ?? 0,
      tools: (data["tools"] as List).map((e) => e as String).toList(),
      relatedArticles:
          (data["relatedArticles"] as List).map((e) => e as String).toList(),
      labels: (data["labels"] as List).map((e) => e as String).toList(),
      geoJSON: data["geoJSON"],
    );
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
