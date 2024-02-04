import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/firebase_storage.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';

class CommentBarViewModel extends BaseModel {
  final dioService = locator<DioService>();
  final commentFormKey = GlobalKey<FormFieldState>();
  final custonNavigationService = locator<CustomNavigationService>();
  final TextEditingController textController = TextEditingController();
  final firebaseStorage = locator<FirebaseStorageService>();
  FocusNode inputFocus = FocusNode();
  XFile? image;
  final ImagePicker picker = ImagePicker();

  String? validateComment(String? comment) {
    if (comment == null || comment.isEmpty) {
      return "Vous devez écrire un avis";
    } else if (comment.length > 2048) {
      return "Ne peut avoir plus de 2048 caractères";
    }
    return null;
  }

  void getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    image = img;
    notifyListeners();
  }

  void closeThumbmail() {
    image = null;
    notifyListeners();
  }

  void submitMessage({
    required AppState appState,
    required String trailId,
    required Function update,
  }) async {
    Map<String, dynamic> body = {
      "user": {
        "id": appState.id,
        "roles": appState.roles,
      },
      "trail": {
        "id": trailId,
        "comment": {
          "body": textController.text,
          "pictures": [],
        },
      },
    };
    final text = textController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      setState(ViewState.create);
      if (image != null) {
        String urlImage = await firebaseStorage.uploadProfile(
          file: File(image!.path),
          userId: appState.id,
        );
        body["trail"]["comment"]["pictures"] = [urlImage];
      }

      await dioService.post(
        path: createCommentPath,
        body: body,
        token: "Bearer ${appState.token}",
      );
      setState(ViewState.retrieved);
      custonNavigationService.showSnackBack(
        content: "Votre commentaire a été créé",
        isError: false,
      );
    } catch (e) {
      setState(ViewState.retrieved);
      custonNavigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
    textController.clear();
    inputFocus.unfocus();

    update();
    closeThumbmail();
  }
}
