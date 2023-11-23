import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/right_hike_tostring.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/widget/achievement_card.dart';

class ShopViewModel extends BaseModel {
  final dioService = locator<DioService>();

  Color getBorderColor({
    required AppState appState,
    required SkinWithOwner skin,
  }) {
    if (appState.skin.id == skin.id) {
      return const Color(0xff15FF78);
    }
    if (isAPartOfOwner(ownerId: appState.id, owners: skin.owners)) {
      return inProgressColor;
    }
    return const Color(0xff000000);
  }
}
