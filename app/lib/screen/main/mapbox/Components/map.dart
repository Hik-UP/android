import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'dart:convert';
import 'skin.dart';

class MapBox extends StatefulWidget {
  MapBox({Key? key}) : super(key: key);

  final state = _MapState();
  @override
  _MapState createState() => state;
}

class _MapState extends State<MapBox> {
  late latlng.LatLng _center;
  late MapController _mapController;
  final double _zoom = 5.5;
  final double _markerWidth = 64.0;
  final double _markerHeight = 64.0;
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  bool loading = true;

  @override
  void initState() {
    _center = latlng.LatLng(46.227638, 2.213749);
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState _appState = context.read<AppState>();

    trails() async {
      var trailList = await WrapperApi().getTrail(
        id: _appState.id,
        roles: _appState.roles,
        token: _appState.token
      );
 
      if (trailList.statusCode == 200 || trailList.statusCode == 201) {
        trailList.data["trails"].forEach((entry) {
          late latlng.LatLng trailLatLng = latlng.LatLng(entry["latitude"], entry["longitude"]);
          var geoJSON = json.decode(entry["geoJSON"]);

          _markers.add(
            Marker(
              width: 50.0,
              height: 50.0,
              point: trailLatLng,
              builder: (ctx) => GestureDetector(
                onTap: () {
                  final List<latlng.LatLng> _points = [];

                  geoJSON["features"][0]["geometry"]["coordinates"].forEach((entry) {
                    _points.add(latlng.LatLng(entry[1], entry[0]));
                  });

                  _mapController.move(trailLatLng, 18.0);
                  _polylines.add(
                    Polyline(
                      points: _points,
                      color: Colors.red,
                      strokeWidth: 3.0,
                      borderColor: Color(0xFF1967D2),
                      borderStrokeWidth: 0.1,
                    )
                  );
                  setState(() {});
                },
                child: Icon(
                  Icons.fiber_manual_record_rounded,
                  color: Colors.blue,
                  size: 24.0
                )
              )
            )
          );
        });
        setState(() {
          loading = false;
        });
      }
    }

    if (loading) {
      trails();
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        pinchZoomThreshold: 69.99999999999991,
        center: _center,
        zoom: _zoom,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/hikupapp/cle0lx80a00j701qqki8kcxqd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGlrdXBhcHAiLCJhIjoiY2w4Mm5lM2l4MDMxbjN1a3A4MXVvNG0wZCJ9.BxVDSc16oILvNK7X5gWF5w",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoiaGlrdXBhcHAiLCJhIjoiY2w4Mm5lM2l4MDMxbjN1a3A4MXVvNG0wZCJ9.BxVDSc16oILvNK7X5gWF5w',
            'id': 'mapbox.mapbox-streets-v8'
          }
        ),
        PlayerSkin(),
        MarkerLayer(markers: loading ? [] : _markers),
        PolylineLayer(polylines: _polylines.length == 0 ? [] : _polylines)
      ],
    );
  }
}
