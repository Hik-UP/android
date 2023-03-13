import 'package:hikup/utils/constant.dart';

String rightHikeToString({required TypeOfHike state}) {
  switch (state) {
    case TypeOfHike.attendee:
      return "attendee";
    case TypeOfHike.guest:
      return "guest";
    default:
      return "organized";
  }
}
