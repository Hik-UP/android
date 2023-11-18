import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/comment.dart';

class MapViewModel extends BaseModel {
  final List<Marker> markers = [];
  late MapController mapController = MapController();
  final List<Polyline> polylines = [];
  final List<TrailFields> trailsList = [];
  final double zoom = 5.5;
  bool loading = true;
  bool showPanel = false;

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
        late LatLng trailLatLng = LatLng(entry["latitude"], entry["longitude"]);
        var geoJSON = json.decode(entry["geoJSON"]);

        markers.add(
          Marker(
            width: 35,
            height: 35,
            point: trailLatLng,
            child: GestureDetector(
              onTap: () {
                final List<LatLng> points = [];

                trailsList.clear();
                trailsList.add(TrailFields(
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
                  comments: entry["comments"]
                      .map((value) => Comment(
                          id: value["id"],
                          author: Author(
                              username: value["author"]["username"],
                              picture: value["author"]["picture"]),
                          body: value["body"],
                          pictures: value["pictures"].cast<String>(),
                          date: DateTime.parse(value["date"])))
                      .toList()
                      .cast<Comment>(),
                  imageAsset: "",
                  price: 0,
                  openTime: "",
                  closeTime: "",
                ));
                geoJSON["features"][0]["geometry"]["coordinates"]
                    .forEach((entry) {
                  points.add(LatLng(entry[1], entry[0]));
                });

                mapController.move(trailLatLng, 18.0);
                polylines.add(Polyline(
                  points: points,
                  color: entry["difficulty"] == 1
                      ? const Color.fromRGBO(87, 252, 255, 0.8)
                      : entry["difficulty"] == 2
                          ? const Color.fromRGBO(72, 255, 201, 0.8)
                          : entry["difficulty"] == 3
                              ? const Color.fromRGBO(194, 283, 255, 0.8)
                              : entry["difficulty"] == 4
                                  ? const Color.fromRGBO(253, 210, 59, 0.8)
                                  : entry["difficulty"] == 5
                                      ? const Color.fromRGBO(87, 252, 255, 0.8)
                                      : Colors.transparent,
                  strokeWidth: 3.0,
                  borderColor: const Color(0xFF1967D2),
                  borderStrokeWidth: 0.1,
                ));
                showPanel = true;
                updateScreen();
              },
              child: SizedBox(
                height: 35,
                width: 35,
                child: Image.asset(
                  "assets/icons/start/start-${entry["difficulty"]}.png",
                ),
              ),
            ),
          ),
        );
      });
      setLoading(false);
    }
  }
}
