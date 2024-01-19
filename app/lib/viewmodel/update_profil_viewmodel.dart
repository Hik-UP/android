import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/user.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/firebase_storage.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hikup/utils/validation.dart';

class UpdateProfilModel extends BaseModel {
  XFile? userImage;
  final _firebaseStorage = locator<FirebaseStorageService>();
  final _dioService = locator<DioService>();
  final _navigationService = locator<CustomNavigationService>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email obligatoire";
    } else if (email.length > 256) {
      return "Ne peut avoir plus de 256 caractères";
    } else if (!Validation.emailValidator(email)) {
      return AppMessages.wrongEmail;
    }
    return null;
  }

  setUserImage({XFile? value}) {
    userImage = value;
    notifyListeners();
  }

  updateProfile({
    required AppState appState,
    required String username,
    required String email,
  }) async {
    String urlImage = "";
    Map<String, dynamic> user = {
      "id": appState.id,
      "roles": appState.roles,
    };

    //Check if userImage is not null
    //Then user want to update his profile
    if (userImage != null) {
      setState(ViewState.busy);
      urlImage = await _firebaseStorage.uploadProfile(
        file: File(userImage!.path),
        userId: appState.id,
      );
      if (urlImage is bool) {
        setState(ViewState.retrieved);
        return;
      }
      user["picture"] = urlImage;
    }
    //Update the username only if the new username
    //Is different from the past username
    //Same for the email
    if (userImage == null &&
        username == appState.username &&
        email == appState.email) {
      setState(ViewState.retrieved);
      _navigationService.showSnackBack(
        content: AppMessages.nothingChange,
      );
      return;
    }
    if (email != appState.email) {
      user["email"] = email;
    }
    if (username != appState.username) {
      user["username"] = username;
    }
    setState(ViewState.busy);
    var result = await _dioService.put(
      path: updateProfilePath,
      token: "Bearer ${appState.token}",
      body: {
        "user": user,
      },
    );
    if (result.statusCode == 200 || result.statusCode == 201) {
      var userNewProfile = await WrapperApi().getProfile(
        id: appState.id,
        roles: appState.roles,
        token: appState.token,
      );
      setState(ViewState.retrieved);
      if (userNewProfile.statusCode == 200 ||
          userNewProfile.statusCode == 201) {
        Map<String, dynamic> userData =
            userNewProfile.data as Map<String, dynamic>;
        User user = User.fromMap(data: userData["user"]);
        appState.storeInHive(
            user: User(
          id: appState.id,
          name: user.name,
          email: user.email,
          accountType: user.accountType,
          imageProfile: user.imageProfile,
          roles: appState.roles,
          token: appState.token,
        ));
        _navigationService.goBack();
        return;
      }
    }
    setState(ViewState.retrieved);
    _navigationService.showSnackBack(
      content: AppMessages.anErrorOcur,
      isError: true,
    );
  }
}
