import 'package:hikup/locator.dart';
import 'package:hikup/model/event.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class AllEventViewModel extends BaseModel {
  final _dioService = locator<DioService>();

  Future<List<EventModel>> getAllEvent({required AppState appState}) async {
    try {
      var response = await _dioService.post(
          path: eventRetrieve,
          body: {
            "user": {
              "id": appState.id,
              "roles": appState.roles,
            },
          },
          token: 'Bearer ${appState.token}');

      var result = (response.data['events'] as List)
          .map<EventModel>((e) => EventModel.fromMap(e))
          .toList();

      return result;
    } catch (e) {
      return [];
    }
  }
}
