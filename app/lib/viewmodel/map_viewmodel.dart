import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
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
            width: 26.0,
            height: 26.0,
            point: trailLatLng,
            builder: (ctx) => GestureDetector(
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
                  color: Colors.red,
                  strokeWidth: 3.0,
                  borderColor: const Color(0xFF1967D2),
                  borderStrokeWidth: 0.1,
                ));
                updateScreen();
              },
              child: SizedBox(
                height: 10,
                width: 10,
                child: Image.asset(
                  "assets/icons/flag.png",
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
