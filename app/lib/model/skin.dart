import 'package:hikup/locator.dart';
import 'package:hikup/model/owner_skin.dart';
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
  @HiveField(5)
  final double price;

  const Skin({
    required this.id,
    required this.name,
    required this.description,
    required this.pictures,
    required this.model,
    this.price = 0,
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
      price: data["price"] != null ? data["price"].toDouble() : 0,
    );
  }

  static addSkinOnHive({
    required Skin skin,
    required Box<Skin> skinBox,
  }) async {
    await locator<HiveService>().addOnBoxViaKey(skinBox, "skin", skin);
  }
}

class SkinWithOwner extends Skin {
  final List<OwnerSkin> owners;
  const SkinWithOwner({
    required this.owners,
    required String description,
    required String id,
    required String name,
    required List<String> pictures,
    required String model,
    required double price,
  }) : super(
          description: description,
          id: id,
          name: name,
          pictures: pictures,
          model: model,
          price: price,
        );

  static SkinWithOwner fromMap({
    required Skin skin,
    required dynamic ownersList,
  }) {
    return SkinWithOwner(
      owners: ownersList.map<OwnerSkin>((e) => OwnerSkin.fromMap(e)).toList(),
      description: skin.description,
      id: skin.id,
      name: skin.name,
      pictures: skin.pictures,
      model: skin.model,
      price: skin.price,
    );
  }
}
