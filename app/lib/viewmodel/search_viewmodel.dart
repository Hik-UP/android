import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/model/trail_fields.dart';

class SearchViewModel extends BaseModel {
  bool loading = true;
  List<TrailFields> trailsList = [];
  List<TrailFields> filterTrailsList = [];

  filterTrails({required String filter}) {
    if (filter == "") {
      filterTrailsList = trailsList;
    } else {
      filterTrailsList = trailsList
          .where((trail) =>
              trail.labels.indexWhere((label) => label == filter) >= 0)
          .toList();
    }
    notifyListeners();
  }

  trails({
    required AppState appState,
  }) async {
    var trailList = await WrapperApi().getTrail(
      id: appState.id,
      roles: appState.roles,
      token: appState.token,
    );

    if (trailList.statusCode == 200 || trailList.statusCode == 201) {
      trailList.data["trails"].forEach((entry) {
        trailsList.add(
          TrailFields.fromMap(entry),
        );
      });
    }
    filterTrailsList = trailsList;
    notifyListeners();
  }

  List<String> genTrailLabel() {
    List<String> labels = ["Tout"];
    for (int i = 0; i < trailsList.length; i++) {
      for (int j = 0; j < trailsList[i].labels.length; j++) {
        trailsList[i].labels.map((e) {
          if (!labels.contains(e)) {
            labels.add(e);
          }
        }).toList();
      }
    }

    return labels;
  }
}
