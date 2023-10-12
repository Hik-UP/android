import 'package:hikup/model/notification.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';

class NotifyViewModel extends BaseModel {
  bool computeShowNotif(List<NotificationModel> notifs) {
    if (notifs.isEmpty) return false;
    for (var notif in notifs) {
      if (!notif.read) {
        return true;
      }
    }

    return false;
  }

  Future<bool> showNotifBellOrNot(AppState appState) async {
    List<NotificationModel> notifs =
        await WrapperApi().getAllNotification(appState: appState);

    return computeShowNotif(notifs);
  }
}
