import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/base_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/comment.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomPin extends StatelessWidget {
  const CustomPin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      width: 10,
      child: Image.asset(
        "assets/icons/flag.png",
      ),
    );
  }
}

class MapViewModel extends BaseModel {
  final List<Marker> markers = [];
  late MapController mapController = MapController();
  final List<Polyline> polylines = [];
  final List<TrailFields> trailsList = [];
  final double zoom = 5.5;
  bool loading = true;

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  Future<void> launchUrlFun(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch URL');
    }
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
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
    List<TrailFields> trails = [];

    if (trailListReq.statusCode == 200 || trailListReq.statusCode == 201) {
      (trailListReq.data["trails"] as List).forEach((element) {
        trails.add(TrailFields.fromMap(element));
      });

      setLoading(false);
    }

    trails.forEach((trail) {
      late LatLng trailLatLng = LatLng(trail.latitude, trail.longitude);
      var geoJSON = json.decode(trail.geoJSON);

      markers.add(
        Marker(
          width: 26.0,
          height: 26.0,
          point: trailLatLng,
          child: GestureDetector(
            onTap: () {
              final List<LatLng> points = [];

              trailsList.clear();

              trailsList.add(trail);
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
            child: const CustomPin(),
          ),
        ),
      );
    });
  }
}
