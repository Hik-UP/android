import 'package:hikup/model/event.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class EventCardViewModel extends BaseModel {
  participate(
      {required AppState appState,
      required String eventId,
      required String path,
      required Function update}) async {
    setState(ViewState.busy);
    await EventModel.participateUnparticipate(
      token: appState.token,
      id: appState.id,
      roles: appState.roles,
      eventId: eventId,
      path: path,
    );

    setState(ViewState.retrieved);
    update();
  }
}
