import 'package:flutter/material.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:intl/intl.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class DetailScreenViewModel extends BaseModel {
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();
  final _navigationService = locator<CustomNavigationService>();
  GlobalKey<FormState> planFormKey = GlobalKey<FormState>();
  final _dioService = locator<DioService>();
  List<String> emailFriends = [];

  pushInEmailFirends({required String value}) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      if (emailFriends.contains(value) == false) {
        emailFriends.add(value.toLowerCase());
      }
    }
  }

  removeInEmailFriends({required String value}) {
    emailFriends.remove(value);
  }

  createAHike(
      {required AppState appState,
      required TrailFields trailField,
      required int? timeStamps,
      required List<String> guests,
      required Function() onLoad,
      required Function() onError}) async {
    List guestsObject =
        guests.isNotEmpty ? guests.map((e) => {"email": e}).toList() : [];
    Map<String, dynamic> bodyTosend = {
      "user": {
        "id": appState.id,
        "roles": appState.roles,
      },
      "trail": {
        "id": trailField.id,
      },
      "hike": {
        "name": "Hike with friend",
        "description": "A simple hike with friend",
        "guests": guestsObject,
      }
    };

    if (timeStamps != null &&
        DateTime.now()
            .isBefore(DateTime.fromMillisecondsSinceEpoch(timeStamps))) {
      bodyTosend["hike"]["schedule"] = timeStamps / 1000;
    }

    try {
      setState(ViewState.busy);
      var result = await _dioService.post(
        path: createHikePath,
        body: bodyTosend,
        token: "Bearer ${appState.token}",
      );
      setState(ViewState.retrieved);

      if (result.statusCode == 201 || result.statusCode == 200) {
        _navigationService.goBack();
        _navigationService.showSnackBack(content: "La randonnée a été créé.");
        onLoad();
      }
    } catch (e) {
      onError();
      _navigationService.showSnackBack(
        content: guests.isNotEmpty
            ? "Un(e) invité(e) n'existe pas"
            : AppMessages.anErrorOcur,
        isError: true,
      );
      setState(ViewState.retrieved);
    }
  }

  int timeStampOrNull() {
    var dateSplit = timeCtrl.text.split(':');

    String minute =
        dateSplit[1].length >= 2 ? dateSplit[1] : "0${dateSplit[1]}";

    return DateFormat("dd/MM/yyyy HH:mm")
        .parse("${dateCtrl.text} ${dateSplit[0]}:$minute")
        .millisecondsSinceEpoch;
  }
}
