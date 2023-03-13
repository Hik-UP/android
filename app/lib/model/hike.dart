import 'package:hikup/model/guest.dart';

class Hike {
  final String id;
  final String name;
  final String description;
  final String address;
  final List<Guest> guests;
  final String schedule;
  final String createdAt;

  Hike({
    required this.id,
    required this.name,
    required this.description,
    required this.guests,
    required this.schedule,
    required this.createdAt,
    required this.address,
  });

  static Hike fromMap({
    required Map<String, dynamic> data,
  }) {
    return Hike(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      address: data["trail"]["address"],
      guests: (data["guests"] as List<dynamic>)
          .map(
            (element) => Guest.fromMap(data: element),
          )
          .toList(),
      schedule: data["schedule"] ?? 0,
      createdAt: data["createdAt"] ?? 0,
    );
  }
}
