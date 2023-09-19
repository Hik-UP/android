import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/screen/shop/components/dialog_content.dart';
import 'package:hikup/service/custom_navigation.dart';
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
}
