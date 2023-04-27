import 'package:hikup/utils/constant.dart';

String getMap() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 6 && hour < 7) {
    return (urlTemplateMapBoxCrepu);
  } else if (hour >= 7 && hour < 20) {
    return (urlTemplateMapBoxDay);
  } else if (hour >= 20 && hour < 21) {
    return (urlTemplateMapBoxCrepu);
  }
  return (urlTemplateMapBoxNight);
}
