import 'package:flutter/material.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/main/community/comments/update_comment_dialogue.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class CommentCardViewModel extends BaseModel {
  final TextEditingController newCommentCtrl = TextEditingController();
  final _customNavigationService = locator<CustomNavigationService>();
  final _dioService = DioService();

  updateComment({
    required Function() update,
    required AppState appState,
    required Comment comment,
  }) {
    newCommentCtrl.text = comment.body;
    _customNavigationService.showDialogue(
      content: UpdateCommentDialogue(
        isLoading: getState == ViewState.busy,
        controller: newCommentCtrl,
        action: () async {
          setState(ViewState.busy);
          await _dioService.put(
            path: updateCommentPath,
            body: {
              "user": {
                "id": appState.id,
                "roles": appState.roles,
              },
              "comment": {
                "id": comment.id,
                "body": newCommentCtrl.text,
              },
            },
            token: 'Bearer ${appState.token}',
          );
          setState(ViewState.retrieved);
          _customNavigationService.goBack();
        },
      ),
      action: () {
        update();
      },
    );
  }
}
