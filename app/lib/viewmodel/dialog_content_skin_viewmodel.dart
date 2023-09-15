import 'package:hikup/locator.dart';
import 'package:hikup/model/skin.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class DialogContentSkinViewModel extends BaseModel {
  final dioService = locator<DioService>();
  final navigationService = locator<CustomNavigationService>();
  final hiveService = locator<HiveService>();

  changeSkin({
    required AppState appState,
    required String newSkinId,
    required SkinWithOwner skinWithOwner,
  }) async {
    try {
      setState(ViewState.busy);
      await dioService.put(
        path: updateCurrentSkinPath,
        body: {
          'user': {'id': appState.id, 'roles': appState.roles},
          'skin': {
            'id': newSkinId,
          }
        },
        token: 'Bearer ${appState.token}',
      );
      setState(ViewState.retrieved);
      Skin newSkin = Skin(
          id: skinWithOwner.id,
          name: skinWithOwner.name,
          description: skinWithOwner.description,
          pictures: skinWithOwner.pictures,
          model: skinWithOwner.model,
          price: skinWithOwner.price);
      Skin.addSkinOnHive(
        skin: newSkin,
        skinBox: skinUserBox,
      );
      appState.updateSkinState(value: newSkin);
      navigationService.goBack();
    } catch (e) {
      setState(ViewState.retrieved);
      navigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
  }
}
