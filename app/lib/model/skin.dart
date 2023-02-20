import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Skin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<String> pictures;
  @HiveField(4)
  final String model;

  const Skin({
    required this.id,
    required this.name,
    required this.description,
    required this.pictures,
    required this.model,
  });

  Skin fromMap(Map<String, dynamic> value) {
    return Skin(
      id: value["id"] ?? "",
      name: value["name"] ?? "",
      description: value["description"] ?? "",
      pictures: value["pictures"] ?? [],
      model: value["model"] ?? "",
    );
  }
}
