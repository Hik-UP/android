import 'package:hikup/locator.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';

class EventModel {
  final String id;
  final String name;
  final String description;
  final String localisation;
  final String visibilty;
  final List<String> tags;
  final String coverUrl;
  final List<String> participants;

  DioService dioService = locator<DioService>();

  EventModel({
    required this.name,
    required this.description,
    required this.localisation,
    required this.visibilty,
    required this.tags,
    this.coverUrl = "",
    required this.participants,
    this.id = '',
  });

  static createEvent({
    required String id,
    required List<dynamic> roles,
    required String title,
    required String description,
    required String coverUrl,
    required List<String> invitedUser,
    required List<String> tags,
    required String localisation,
    required int nbrParticipants,
    required String token,
  }) async {
    DioService dioService = locator<DioService>();

    var response = await dioService.post(
      path: eventCreatePath,
      body: {
        "user": {
          "id": id,
          "roles": roles,
        },
        "event": {
          "title": title,
          "description": description,
          "coverUrl": coverUrl,
          "invitedUser": [],
          "tags": tags,
          "localisation": localisation,
          "nbrParticipants": nbrParticipants
        },
      },
      token: 'Bearer $token',
    );
  }

  static EventModel fromMap(Map<String, dynamic> data) {
    return EventModel(
        id: data['id'],
        name: data["title"],
        description: data['description'],
        localisation: data['localisation'],
        visibilty: data['visibilityEvent'],
        tags: (data['tags'] as List).map<String>((e) => e as String).toList(),
        participants: (data['participants'] as List)
            .map<String>((e) => e as String)
            .toList(),
        coverUrl: data['coverUrl']);
  }

  static participateUnparticipate({
    required String token,
    required String id,
    required List<dynamic> roles,
    required String eventId,
    required String path,
  }) async {
    DioService dioService = locator<DioService>();

    await dioService.post(
      path: path,
      body: {
        "user": {
          "id": id,
          "roles": roles,
        },
        "event": {
          "id": eventId,
        }
      },
      token: 'Bearer $token',
    );
  }
}
