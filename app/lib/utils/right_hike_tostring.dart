import 'package:hikup/model/owner_skin.dart';
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

bool isAPartOfOwner(
    {required String ownerId, required List<OwnerSkin> owners}) {
  for (var owner in owners) {
    if (owner.id == ownerId) return true;
  }

  return false;
}
