import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class DetailHikeInviteViewModel extends BaseModel {
  final _dioService = locator<DioService>();
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
    await _dioService.delete(
      path: leaveHikePath,
      body: {
        "user": {
          "id": appState.id,
          "roles": appState.roles,
        },
        "hike": {"id": hikeId},
      },
    );
    setLoadingDelete(false);
  }
}
