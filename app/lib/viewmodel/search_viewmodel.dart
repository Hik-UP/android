import 'package:flutter/material.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'dart:convert';
import 'package:hikup/model/rando_field.dart';

class SearchViewModel extends BaseModel {
  bool loading = true;
  List<RandoField> trailsList = [];

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  trails({
    required AppState appState,
    required Function updateScreen,
  }) async {
    var trailList = await WrapperApi().getTrail(
      id: appState.id,
      roles: appState.roles,
      token: appState.token,
    );

    if (trailList.statusCode == 200 || trailList.statusCode == 201) {
      trailList.data["trails"].forEach((entry) {
        trailsList.add(
          RandoField(
            id: entry["id"],
            name: entry["name"],
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
          )
        );
      });
      setLoading(false);
    }
  }
}
