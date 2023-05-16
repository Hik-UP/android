import 'package:hikup/model/guest.dart';
import 'package:hikup/model/trail.dart';

class Hike {
  final String id;
  final String name;
  final String description;
  final String address;
  final List<Guest> guests;
  final String schedule;
  final String createdAt;
  final Trail trail;
  final List<Guest> attendee;
  final Guest organizers;
  final String status;

  Hike({
    required this.id,
    required this.name,
    required this.description,
    required this.guests,
    required this.schedule,
    required this.createdAt,
    required this.address,
    required this.trail,
    required this.attendee,
    required this.organizers,
    required this.status,
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
      attendee: data["attendees"] != null
          ? (data["attendees"] as List<dynamic>)
              .map(
                (element) => Guest.fromMap(data: element),
              )
              .toList()
          : [],
      schedule: data["schedule"] ?? 0,
      createdAt: data["createdAt"] ?? 0,
      trail: Trail.fromMap(
        data: data["trail"],
      ),
      organizers: Guest.fromMap(data: data["organizers"][0]),
      status: data["status"] ?? "",
    );
  }
}
