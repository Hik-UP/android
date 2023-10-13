import 'package:hikup/model/comment.dart';

class TrailFields {
  String id;
  String name;
  String address;
  String description;
  List<String> pictures;
  double latitude;
  double longitude;
  int difficulty;
  int duration;
  int distance;
  int uphill;
  int downhill;
  List<String> tools;
  List<String> relatedArticles;
  List<String> labels;
  String geoJSON;
  List<Comment> comments;
  String imageAsset;
  int price;
  String openTime;
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
}
