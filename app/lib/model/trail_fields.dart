import 'package:hikup/locator.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'trail_fields.g.dart';

@HiveType(typeId: 4)
class TrailFields {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String address;
  @HiveField(3)
  String description;
  @HiveField(4)
  List<String> pictures;
  @HiveField(5)
  double latitude;
  @HiveField(6)
  double longitude;
  @HiveField(7)
  int difficulty;
  @HiveField(8)
  int duration;
  @HiveField(9)
  int distance;
  @HiveField(10)
  int uphill;
  @HiveField(11)
  int downhill;
  @HiveField(12)
  List<String> tools;
  @HiveField(13)
  List<String> relatedArticles;
  @HiveField(14)
  List<String> labels;
  @HiveField(15)
  String geoJSON;
  @HiveField(16)
  List<Comment> comments;
  @HiveField(17)
  String imageAsset;
  @HiveField(18)
  int price;
  @HiveField(19)
  String openTime;
  @HiveField(20)
  String closeTime;

  TrailFields({
    required this.id,
    required this.name,
    required this.address,
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
    required this.geoJSON,
    required this.comments,
    required this.imageAsset,
    required this.price,
    required this.openTime,
    required this.closeTime,
  });

  static TrailFields fromMap(Map<String, dynamic> entry) {
    return TrailFields(
      id: entry["id"],
      name: entry["name"],
      address: entry["address"],
      description: entry["description"],
      pictures: entry["pictures"].cast<String>(),
      latitude: entry["latitude"].toDouble(),
      longitude: entry["longitude"].toDouble(),
      difficulty: entry["difficulty"],
      duration: entry["duration"],
      distance: entry["distance"],
      uphill: entry["uphill"],
      downhill: entry["downhill"],
      tools: entry["tools"].cast<String>(),
      relatedArticles: entry["relatedArticles"].cast<String>(),
      labels: entry["labels"].cast<String>(),
      geoJSON: entry["geoJSON"],
      comments: entry["comments"]
          .map((value) => Comment(
              id: value["id"],
              author: Author(
                  username: value["author"]["username"],
                  picture: value["author"]["picture"]),
              body: value["body"],
              pictures: value["pictures"].cast<String>(),
              date: DateTime.parse(value["date"])))
          .toList()
          .cast<Comment>(),
      imageAsset: "",
      price: 0,
      openTime: "",
      closeTime: "",
    );
  }

  static Future<void> storeTrailListInHive(List<TrailFields> trails) async {
    await locator<HiveService>().addOnBoxViaKey(
      boxTrails,
      "trails",
      TrailList(trails: trails),
    );
  }
}

@HiveType(typeId: 5)
class TrailList {
  @HiveField(0)
  final List<TrailFields> trails;

  const TrailList({required this.trails});
}
