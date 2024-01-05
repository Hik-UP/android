import 'dart:convert';
import 'package:collection/collection.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/comment.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/model/hike.dart';

class MapViewModel extends BaseModel {
  final List<Marker> markers = [];
  late MapController mapController = MapController();
  late List<Hike> hikesList;
  List<Hike> hike = [];
  Position position = Position(
      longitude: 1.7191036,
      latitude: 46.71109,
      timestamp: DateTime.now().toLocal(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0);
  final List<Polyline> polylines = [];
  final List<TrailFields> trailsList = [];
  final double zoom = 5.5;
  bool loading = true;
  bool showPanel = false;
  bool showJoin = false;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void handleJoin(TrailFields trail) {
    var newHike =
        hikesList.firstWhereOrNull((element) => element.trail.id == trail.id);

    hike.clear();
    if (newHike != null) {
      hike.add(newHike);
    }

    if (trailsList.isNotEmpty &&
        hike.isNotEmpty &&
        calculateDistance(position.latitude, position.longitude,
                trailsList[0].latitude, trailsList[0].longitude) <
            1000.100) {
      showJoin = true;
    } else {
      showJoin = false;
    }
  }

  trails({
    required AppState appState,
    required Function updateScreen,
  }) async {
    var trailListReq = await WrapperApi().getTrail(
      id: appState.id,
      roles: appState.roles,
      token: appState.token,
    );

    if (trailListReq.statusCode == 200 || trailListReq.statusCode == 201) {
      trailListReq.data["trails"].forEach((entry) {
        late LatLng trailLatLng = LatLng(entry["latitude"], entry["longitude"]);
        var geoJSON = json.decode(entry["geoJSON"]);
        var trailField = TrailFields(
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
                  date: DateTime.parse(value["date"]).toLocal()))
              .toList()
              .cast<Comment>(),
          imageAsset: "",
          price: 0,
          openTime: "",
          closeTime: "",
        );

        markers.add(
          Marker(
            width: 35,
            height: 35,
            point: trailLatLng,
            child: GestureDetector(
              onTap: () async {
                final List<LatLng> points = [];

                trailsList.clear();
                polylines.clear();
                trailsList.add(trailField);
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
                hikesList = await WrapperApi().getAllHike(
                    path: getHikePath,
                    appState: appState,
                    target: ["attendee"],
                    onLoad: () => null,
                    onRetrieved: () => null);
                handleJoin(trailField);
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
