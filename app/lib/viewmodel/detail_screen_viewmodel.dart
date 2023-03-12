import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class DetailScreenViewModel extends BaseModel {
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();
  final _navigationService = locator<CustomNavigationService>();
  final _dioService = locator<DioService>();
  List<String> emailFriends = [];

  pushInEmailFirends({required String value}) {
    emailFriends.add(value);
    notifyListeners();
  }

  removeInEmailFriends({required String value}) {
    emailFriends.remove(value);
    notifyListeners();
  }

  createAHike({
    required AppState appState,
    required TrailFields trailField,
    required int? timeStamps,
    required List<String> guests,
  }) async {
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
    if (timeStamps != null) bodyTosend["hike"]["schedule"] = timeStamps / 1000;

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
        _navigationService.showSnackBack(content: AppMessages.success);
      }
    } catch (e) {
      setState(ViewState.retrieved);
    }
  }

  Widget showTools({required List<String> toolsBack}) {
    List<Widget> tools = [];

    for (int i = 0; i + 1 < toolsBack.length; i += 2) {
      tools.add(Row(
        children: [
          Expanded(
            child: Text(
              "${i + 1}. ${toolsBack[i]}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${i + 2}. ${toolsBack[i + 1]}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ));
    }

    return Column(children: tools);
  }

  int timeStampOrNull() {
    var dateSplit = timeCtrl.text.split(':');
    String minute =
        dateSplit[1].length >= 2 ? dateSplit[1] : "0${dateSplit[1]}";

    return DateTime.parse("${dateCtrl.text} ${dateSplit[0]}:$minute:00")
        .millisecondsSinceEpoch;
  }
}
