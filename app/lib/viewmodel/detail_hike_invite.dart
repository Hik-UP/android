import 'package:hikup/locator.dart';
import 'dart:convert';
import "package:hikup/model/hike.dart";
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/utils/socket/socket.dart';
import 'package:geolocator/geolocator.dart';

class DetailHikeInviteViewModel extends BaseModel {
  final _dioService = locator<DioService>();
  final _navigatorService = locator<CustomNavigationService>();
  bool loadingDelete = false;
  final navigator = locator<CustomNavigationService>();
  bool joinInProgress = false;
  late dynamic stats;
  late List<dynamic> hikers;
  late Hike newHike;

  Future<bool> getLocation() async {
    late LocationPermission permission;

    await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always ||
        !(await Geolocator.isLocationServiceEnabled())) {
      navigator.showSnackBack(
        content: 'Localisation inaccessible',
        isError: true,
      );
      return false;
    } else {
      return true;
    }
  }

  joinHike(
      {required AppState appState,
      required Hike hike,
      required Function() onLoad,
      required Function() onFail,
      required Function() onComplete}) async {
    try {
      onLoad();
      bool permission = await getLocation();
      List<Hike> hikesList;
      int index;

      if (permission == false) {
        onFail();
        return;
      }
      if (joinInProgress == false) {
        setState(ViewState.join);
        joinInProgress = true;
        hikesList = await WrapperApi().getAllHike(
            path: getHikePath,
            appState: appState,
            target: ["attendee"],
            onLoad: () => null,
            onRetrieved: () => null);
        index = hikesList.indexWhere((item) => item.id == hike.id);
        newHike = hikesList[index];
        SocketService().connect(
            token: appState.token,
            userId: appState.id,
            userRoles: appState.roles);
        SocketService().onError((_) {
          joinInProgress = false;
          SocketService().disconnect();
          onFail();
        });

        await SocketService().hike.join(hike.id, (data) {
          dynamic jsonData = json.decode(data);
          stats = jsonData["stats"];
          hikers = jsonData["hikers"];

          joinInProgress = false;
          setState(ViewState.retrieved);
          onComplete();
        });
      }
    } catch (err) {}
  }

  leaveHike(
      {required String hikeId,
      required AppState appState,
      required bool isOrganizer}) async {
    setState(ViewState.deletion);
    var response = await _dioService.put(
      path: isOrganizer == true ? leaveOrganizedHikePath : leaveHikePath,
      body: {
        "user": {
          "id": appState.id,
          "roles": appState.roles,
        },
        "hike": {
          "id": hikeId,
        },
      },
      token: "Bearer ${appState.token}",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      _navigatorService.showSnackBack(
        content: "Vous avez quitté la randonnée.",
      );
      setState(ViewState.retrieved);
      _navigatorService.goBack();
    }
  }

  removeHike(
      {required String hikeId,
      required AppState appState,
      required bool isOrganizer}) async {
    setState(ViewState.busy);
    var response = await _dioService.delete(
      path: isOrganizer == true ? removeOrganizedHikePath : removeHikePath,
      body: {
        "user": {
          "id": appState.id,
          "roles": appState.roles,
        },
        "hike": {
          "id": hikeId,
        },
      },
      token: "Bearer ${appState.token}",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      _navigatorService.showSnackBack(
        content: "La randonnée a été supprimé.",
      );
      setState(ViewState.retrieved);
      _navigatorService.goBack();
    }
  }
}
