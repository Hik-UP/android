import 'package:flutter/widgets.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/model/trail.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';

import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:image_picker/image_picker.dart';

class CommunityPageViewModel extends BaseModel {
  final dioService = locator<DioService>();
  final custonNavigationService = locator<CustomNavigationService>();
  final TextEditingController textController = TextEditingController();
  XFile? image;
  final ImagePicker picker = ImagePicker();

  void getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    image = img;
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
          "pictures": [
            "https://images.cgames.de/images/gsgp/4/naruto-anime_6224688.jpg"
          ],
        },
      },
      //  "https://images.cgames.de/images/gsgp/4/naruto-anime_6224688.jpg"
    };
    final text = textController.text;
    //final myUserId = supabase.auth.currentUser!.id;
    if (text.isEmpty) {
      return;
    }
    try {
      if (image != null) {
        print(image!.path);
      }
      print("Load");
      var response = await dioService.post(
        path: createCommentPath,
        body: body,
        token: "Bearer ${appState.token}",
      );
      print("Finish");
    } catch (e) {
      custonNavigationService.showSnackBack(
        content: AppMessages.anErrorOcur,
        isError: true,
      );
    }
    textController.clear();
  }
}
