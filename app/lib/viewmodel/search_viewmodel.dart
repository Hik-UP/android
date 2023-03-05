import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/comment.dart';

class SearchViewModel extends BaseModel {
  bool loading = true;
  List<TrailFields> trailsList = [];

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<List<TrailFields>> trails({
    required AppState appState,
  }) async {
    var trailList = await WrapperApi().getTrail(
      id: appState.id,
      roles: appState.roles,
      token: appState.token,
    );

    if (trailList.statusCode == 200 || trailList.statusCode == 201) {
      print(trailList.data["trails"]);
      trailList.data["trails"].forEach((entry) {
        trailsList.add(
          TrailFields(
            id: entry["id"],
            name: entry["name"],
            address: entry["address"],
            description: entry["description"],
            pictures: entry["pictures"].cast<String>(),
            latitude: entry["latitude"],
            longitude: entry["longitude"],
            difficulty: entry["difficulty"],
            duration: entry["duration"],
            distance: entry["distance"],
            uphill: entry["uphill"],
            downhill: entry["downhill"],
            tools: entry["tools"].cast<String>(),
            relatedArticles: entry["relatedArticles"].cast<String>(),
            labels: entry["labels"].cast<String>(),
            geoJSON: entry["geoJSON"],
            comments: entry["comments"].map((value) => Comment(
              id: value["id"],
              author: Author(
                username: value["author"]["username"],
                picture: value["author"]["picture"]
              ),
              body: value["body"],
              pictures: value["pictures"].cast<String>(),
              date: value["date"]
            )).toList().cast<Comment>(),
            imageAsset: "",
            price: 0,
            openTime: "",
            closeTime: "",
          ),
        );
      });
    }

    return trailsList;
  }
}
