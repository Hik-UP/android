import 'package:hikup/locator.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';

class EventModel {
  final String name;
  final String description;
  final String localisation;
  final String visibilty;
  final List<String> tags;
  final String coverUrl;
  final List<String> participants;

  EventModel({
    required this.name,
    required this.description,
    required this.localisation,
    required this.visibilty,
    required this.tags,
    this.coverUrl = "",
    required this.participants,
  });

  static createEvent({
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
}
