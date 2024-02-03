import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/model/trail.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/service/firebase_storage.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';

class CommunityPageViewModel extends BaseModel {
  final dioService = locator<DioService>();
  final custonNavigationService = locator<CustomNavigationService>();
  final TextEditingController textController = TextEditingController();
  final firebaseStorage = locator<FirebaseStorageService>();
  FocusNode inputFocus = FocusNode();
  XFile? image;
  final ImagePicker picker = ImagePicker();

  void getImage(ImageSource media, Function(XFile?) onSelect) async {
    var img = await picker.pickImage(source: media);

    onSelect(img);
    //image = img;
  }

  void closeThumbmail() {
    image = null;
    notifyListeners();
  }

  Future<List<Comment>> retrieveData({
    required AppState appState,
    required String trailId,
  }) async {
    Map<String, dynamic> body = {
      "user": {
        "id": appState.id,
        "roles": appState.roles,
      },
    };
    var response = await dioService.post(
      path: getTrailsPath,
      body: body,
      token: "Bearer ${appState.token}",
    );
    if (!(response.statusCode == 200)) {
      return [];
    }
    List<Trail> trails = (response.data["trails"] as List)
        .map((e) => Trail.fromMap(data: e))
        .toList();
    Trail currentTrail =
        trails.where((element) => element.id == trailId).toList()[0];

    return currentTrail.comments;
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
