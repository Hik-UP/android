import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/guest.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/widget/display_status.dart';

class HikeCardViewModel extends BaseModel {
  final _dioService = locator<DioService>();
  final _navigator = locator<CustomNavigationService>();
  bool acceptLoader = false;
  bool declineLoader = false;

  List<String> retriveGuestName({required List<Guest> guests}) {
    return guests.map((e) => e.username).toList();
  }

  setAcceptLoader(bool value) {
    acceptLoader = value;

    notifyListeners();
  }

  setDeclineLoader(bool value) {
    declineLoader = value;

    notifyListeners();
  }

  acceptOrRefuse({
    required String routeName,
    required String hikeId,
    required AppState appState,
    required Function() load,
    required Function() stop,
  }) async {
    load();
    try {
      await _dioService.put(
        path: routeName,
        body: {
          "user": {
            "id": appState.id,
            "roles": appState.roles,
          },
          "hike": {
            "id": hikeId,
          }
        },
        token: "Bearer ${appState.token}",
      );
    } catch (e) {
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
    stop();
  }

  Widget labelStatus({required String status}) {
    switch (status) {
      case "IN_PROGRESS":
        return DisplayStatus(
          status: AppMessages.inProgress,
          bgClor: Colors.red,
        );
      case "SCHEDULED":
        return DisplayStatus(
          status: AppMessages.scheduled,
          bgClor: Colors.amber[400],
        );
      default:
        {
          return DisplayStatus(
            status: AppMessages.doneLabel,
            bgClor: Colors.green,
          );
        }
    }
  }
}
