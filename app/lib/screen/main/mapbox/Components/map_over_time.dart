import 'package:hikup/utils/constant.dart';

String getMapId() {
  DateTime now = DateTime.now().toLocal();
  int hour = now.hour;

  if (hour >= 6 && hour < 7 || hour >= 20 && hour < 21) {
    return (mapIdSunset);
  } else if (hour >= 7 && hour < 20) {
    return (mapIdDay);
  } else {
    return (mapIdNight);
  }
}
