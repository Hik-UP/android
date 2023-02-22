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
    required this.geoJSON
  });
}
