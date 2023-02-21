import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:latlong2/latlong.dart' as latlng;

class MapViewModel extends BaseModel {
  final List<Marker> markers = [];
  late MapController mapController = MapController();
  final List<Polyline> polylines = [];
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
        late latlng.LatLng trailLatLng =
            latlng.LatLng(entry["latitude"], entry["longitude"]);
        var geoJSON = json.decode(entry["geoJSON"]);

        markers.add(
          Marker(
            width: 50.0,
            height: 50.0,
            point: trailLatLng,
            builder: (ctx) => GestureDetector(
              onTap: () {
                final List<latlng.LatLng> points = [];

                geoJSON["features"][0]["geometry"]["coordinates"]
                    .forEach((entry) {
                  points.add(latlng.LatLng(entry[1], entry[0]));
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
              child: const Icon(Icons.fiber_manual_record_rounded,
                  color: Colors.blue, size: 24.0),
            ),
          ),
        );
      });
      setLoading(false);
    }
  }
}
