import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/shop/components/dialog_content.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';

class SkinDisplayViewModel extends BaseModel {
  final navigator = locator<CustomNavigationService>();

  openDialog({required SkinWithOwner skin, required Function() action}) {
    navigator.showDialogue(
      action: action,
      content: DialogContent(
        skin: skin,
      ),
    );
  }

  Future<List<SkinWithOwner>> getAllSkin({required AppState appState}) async {
    List<SkinWithOwner> unlockedSkin = await WrapperApi().getAllSkin(
      appState: appState,
      routeName: "/user/skin/unlocked",
    );
    var skinUnlocked = unlockedSkin
        .map((e) => SkinWithOwner(
              owners: e.owners,
              description: e.description,
              id: e.id,
              name: e.name,
              pictures: e.pictures,
              model: e.model,
              price: e.price,
              isUnLock: true,
            ))
        .toList();
    List<SkinWithOwner> lockedSkin = await WrapperApi().getAllSkin(
      appState: appState,
      routeName: "/user/skin/locked",
    );
    skinUnlocked.addAll(lockedSkin);

    return skinUnlocked;
  }
}
