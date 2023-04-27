import 'package:hikup/locator.dart';
import 'package:hikup/model/guest.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/viewmodel/base_model.dart';

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

  acceptOrRefuse({
    required String routeName,
    required String hikeId,
    required AppState appState,
    required Function() load,
    required Function() stop,
  }) async {
    print(hikeId);
    load();
    try {
      await _dioService.post(
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
      print(e);
      _navigator.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
    stop();
  }
}
