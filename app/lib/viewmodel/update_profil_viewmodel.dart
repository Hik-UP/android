import 'dart:io';
import 'package:hikup/locator.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/firebase_storage.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilModel extends BaseModel {
  XFile? userImage;
  final _firebaseStorage = locator<FirebaseStorageService>();
  final _dioService = locator<DioService>();
  final _navigationService = locator<CustomNavigationService>();

  setUserImage({XFile? value}) {
    userImage = value;
    notifyListeners();
  }

  updateProfile({
    required AppState appState,
  }) async {
    setState(ViewState.busy);
    var urlImage = await _firebaseStorage.uploadProfile(
      file: File(userImage!.path),
      userId: appState.id,
    );

    if (urlImage is bool) {
      setState(ViewState.retrieved);
      return;
    }
    var result = await _dioService.put(
      path: updateProfilePath,
      token: "Bearer ${appState.token}",
      body: {
        "user": {
          "id": appState.id,
          "roles": appState.roles,
          "picture": urlImage
        },
      },
    );
    setState(ViewState.retrieved);

    if (result.statusCode == 200 || result.statusCode == 201) {
      User user = boxUser.get("user")!;

      appState.storeInHive(
          user: User(
        id: user.id,
        name: user.name,
        email: user.email,
        accountType: user.accountType,
        imageProfile: urlImage,
        roles: user.roles,
        token: user.token,
      ));
      _navigationService.goBack();
      return;
    }
    _navigationService.showSnackBack(
      content: AppMessages.anErrorOcur,
      isError: true,
    );
  }
}
