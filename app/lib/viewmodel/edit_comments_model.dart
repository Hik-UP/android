/*import 'dart:io';
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

class EditCommentModel extends BaseModel {
  XFile? userImage;
  final _firebaseStorage = locator<FirebaseStorageService>();
  final _dioService = locator<DioService>();
  final _navigationService = locator<CustomNavigationService>();
  final TextEditingController commentCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  setUserImage({XFile? value}) {
    userImage = value;
    notifyListeners();
  }

  editComment({
    required AppState appState,
    required String comment,
    required String email,
  }) async {
    String urlImage = "";
    Map<String, dynamic> user = {
      "id": appState.id,
      "roles": appState.roles,
    };

    //Check if userImage is not null
    //Then user want to edit his comment
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
    //Edit the comment only if the new comment
    //Is different from the past comment
    //Same for the email
    if (userImage == null &&
        comment == appState.comment) {
      setState(ViewState.retrieved);
      _navigationService.showSnackBack(
        content: AppMessages.nothingChange,
      );
      return;
    }
    if (comment != appState.comment) {
      user["comment"] = comment;
    }
    setState(ViewState.busy);
    var result = await _dioService.put(
      path: updateProfilePath,
      token: "Bearer ${appState.token}",
      body: {
        "user": user,
      },
    );
    setState(ViewState.retrieved);
    _navigationService.showSnackBack(
      content: AppMessages.anErrorOcur,
      isError: true,
    );
  }
}*/
