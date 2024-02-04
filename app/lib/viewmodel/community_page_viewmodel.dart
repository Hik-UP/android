import 'package:hikup/locator.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/model/trail.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/dio_service.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/base_model.dart';

class CommunityPageViewModel extends BaseModel {
  final dioService = locator<DioService>();

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
}
