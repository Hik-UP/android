import 'package:hikup/model/rando_category.dart';
import 'package:hikup/model/field_facility.dart';

class RandoField {
  String id;
  String name;
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

  RandoField({
    required this.id,
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
    required this.geoJSON
  });
}
