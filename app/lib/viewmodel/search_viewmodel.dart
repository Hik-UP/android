import 'package:dio/src/response.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/service/hive_service.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/service/custom_navigation.dart';

class SearchViewModel extends BaseModel {
  bool loading = true;
  bool error = false;
  List<TrailFields> trailsList = [];
  List<TrailFields> filterTrailsList = [];
  final _navigator = locator<CustomNavigationService>();
  final HiveService _hiveService = locator<HiveService>();

  searchFilterTrails({required String filter}) {
    if (filter == "") {
      filterTrailsList = trailsList;
    } else {
      filterTrailsList = trailsList
          .where((trail) =>
              trail.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  trails(
      {required AppState appState,
      required Function() onLoad,
      required Function() onRetrieved}) async {
    Response trailList;
    List<TrailFields> result = [];
    try {
      onLoad();
      var existingTrail = _hiveService.getData<TrailList>(boxTrails, "trails");
      if (existingTrail != null && existingTrail.trails.isNotEmpty) {
        trailsList = existingTrail.trails;
      } else {
        trailList = await WrapperApi().getTrail(
          id: appState.id,
          roles: appState.roles,
          token: appState.token,
        );

        if (trailList.statusCode == 200 || trailList.statusCode == 201) {
          trailList.data["trails"].forEach((entry) {
            trailsList.add(
              TrailFields.fromMap(entry),
            );
            result.add(TrailFields.fromMap(entry));
          });
          await TrailFields.storeTrailListInHive(result);
        } else {
          throw "";
        }
      }

      filterTrailsList = trailsList;
      onRetrieved();
      notifyListeners();
    } catch (err) {
      error = true;
      _navigator.showSnackBack(
          content: "Une erreur est survenue", isError: true);
      filterTrailsList = trailsList;
      onRetrieved();
      notifyListeners();
    }
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
