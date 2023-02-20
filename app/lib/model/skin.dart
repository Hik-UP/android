import 'package:hikup/locator.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hive/hive.dart';
part 'skin.g.dart';

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

  static Skin fromMap({required Map<String, dynamic> data}) {
    List<String> skinString = [];

    if (data["pictures"] != null) {
      for (var value in data["pictures"]) {
        skinString.add(value as String);
      }
    }

    return Skin(
      id: data["id"] ?? "",
      name: data["name"] ?? "",
      description: data["description"] ?? "",
      pictures: skinString,
      model: data["model"] ?? "",
    );
  }

  static addSkinOnHive({
    required Skin skin,
    required Box<Skin> skinBox,
  }) async {
    await locator<HiveService>().addOnBoxViaKey(skinBox, "skin", skin);
  }
}
