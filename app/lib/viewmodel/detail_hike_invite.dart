import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class DetailHikeInviteViewModel extends BaseModel {
  final _dioService = locator<DioService>();
  final _navigatorService = locator<CustomNavigationService>();
  bool loadingDelete = false;

  setLoadingDelete(bool value) {
    loadingDelete = value;

    notifyListeners();
  }

  leaveHike({
    required String hikeId,
    required AppState appState,
  }) async {
    setLoadingDelete(true);

    var response = await _dioService.put(
      path: leaveHikePath,
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
        content: AppMessages.success,
      );
      _navigatorService.goBack();
    }
  }

  finishByOrganizer({
    required String hikeId,
    required AppState appState,
  }) async {
    setLoadingDelete(true);

    var response = await _dioService.put(
      path: organzierUpdatePath,
      body: {
        "user": {
          "id": appState.id,
          "roles": appState.roles,
        },
        "hike": {
          "id": hikeId,
          "status": "DONE",
        },
      },
      token: "Bearer ${appState.token}",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      _navigatorService.showSnackBack(
        content: AppMessages.success,
      );
      _navigatorService.goBack();
    }

    setLoadingDelete(false);
  }
}
