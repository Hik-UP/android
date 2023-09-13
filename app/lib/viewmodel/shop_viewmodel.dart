import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/right_hike_tostring.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/widget/achievement_card.dart';

class ShopViewModel extends BaseModel {
  final dioService = locator<DioService>();

  Future<List<SkinWithOwner>> getAllSkin({required AppState appState}) async {
    List<SkinWithOwner> skins = [];

    try {
      var response = await dioService.post(
        path: getSkinPath,
        body: {
          'user': {
            'id': appState.id,
            'roles': appState.roles,
          }
        },
        token: "Bearer ${appState.token}",
      );

      (response.data['skins'] as List)
          .map(
            (e) => skins.add(
              SkinWithOwner.fromMap(
                skin: Skin.fromMap(data: e),
                ownersList: e['owners'],
              ),
            ),
          )
          .toList();
      return skins;
    } catch (e) {
      return [];
    }
  }

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
