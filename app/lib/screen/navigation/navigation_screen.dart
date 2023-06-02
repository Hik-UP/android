import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hikup/theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/mapbox/Components/skin.dart';
import 'package:hikup/screen/main/mapbox/Components/map_over_time.dart';
import 'package:gap/gap.dart';
import 'package:hikup/utils/socket.dart';
import "package:hikup/model/hike.dart";
import 'package:geolocator/geolocator.dart';
import 'package:hikup/model/navigation.dart';

class NavigationScreen extends StatefulWidget {
  final Hike hike;
  final dynamic stats;
  final List<dynamic> hikers;
  const NavigationScreen({
    Key? key,
    required this.hike,
    required this.stats,
    required this.hikers,
  }) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late HikerStats stats;
  String? lastPosition;
  late List<dynamic> _hikers;

  @override
  void initState() {
    super.initState();
    AppState appState = context.read<AppState>();
    stats = HikerStats(
        steps: widget.stats["steps"],
        distance: widget.stats["distance"],
        completed: widget.stats["completed"]);
    _hikers = widget.hikers.map((entry) {
      late latlng.LatLng hikerLatLng = latlng.LatLng(
          entry["hiker"]["latitude"], entry["hiker"]["longitude"]);

      return {
        "id": entry["hiker"]["id"],
        "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
        "marker": Marker(
          width: 26.0,
          height: 26.0,
          point: hikerLatLng,
          builder: (ctx) => const Icon(Icons.fiber_manual_record_rounded,
              color: Colors.blue, size: 24.0),
        ),
        "stats": entry["hiker"]["stats"]
      };
    }).toList();
    SocketService().onDisconnect(
      (data) => Navigator.of(context, rootNavigator: true).pop(),
    );
    SocketService().onError((_) => SocketService().disconnect());
    SocketService().onHikeJoined((data) {
      dynamic entry = json.decode(data);
      late latlng.LatLng hikerLatLng = latlng.LatLng(
          entry["hiker"]["latitude"], entry["hiker"]["longitude"]);

      setState(() {
        _hikers = [
          ..._hikers,
          {
            "id": entry["hiker"]["id"],
            "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
            "marker": Marker(
              width: 26.0,
              height: 26.0,
              point: hikerLatLng,
              builder: (ctx) => const Icon(Icons.fiber_manual_record_rounded,
                  color: Colors.blue, size: 24.0),
            ),
            "stats": entry["hiker"]["stats"]
          }
        ];
      });
    });
    SocketService().onHikeLeaved((data) {
      dynamic entry = json.decode(data);

      setState(() {
        _hikers.removeWhere((item) => item["id"] == entry["hiker"]["id"]);
      });
    });
    SocketService().onHikerMoved((data) {
      dynamic entry = json.decode(data);
      late latlng.LatLng hikerLatLng = latlng.LatLng(
          entry["hiker"]["latitude"], entry["hiker"]["longitude"]);
      final newHiker = {
        "id": entry["hiker"]["id"],
        "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
        "marker": Marker(
          width: 26.0,
          height: 26.0,
          point: hikerLatLng,
          builder: (ctx) => const Icon(Icons.fiber_manual_record_rounded,
              color: Colors.blue, size: 24.0),
        ),
        "stats": entry["hiker"]["stats"]
      };
      int index =
          _hikers.indexWhere((item) => item["id"] == entry["hiker"]["id"]);

      if (index >= 0 &&
          _hikers[index]["LatLng"] != null &&
          newHiker["LatLng"] != _hikers[index]["LatLng"]) {
        setState(() {
          _hikers[index] = newHiker;
        });
      }
    });
  }

  int calcDistance(String latLng1, String latLng2) {
    List<double> splitLatLng1 = [
      double.parse(latLng1.split(',')[0]),
      double.parse(latLng1.split(',')[1])
    ];
    List<double> splitLatLng2 = [
      double.parse(latLng2.split(',')[0]),
      double.parse(latLng2.split(',')[1])
    ];
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((splitLatLng2[0] - splitLatLng1[0]) * p) / 2 +
        c(splitLatLng1[0] * p) *
            c(splitLatLng2[0] * p) *
            (1 - c((splitLatLng2[1] - splitLatLng1[1]) * p)) /
            2;
    return ((12742 * asin(sqrt(a))) * 1000).round();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MapViewModel>(builder: (context, model, child) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        body: SlidingUpPanel(
          renderPanelSheet: false,
          minHeight: 100,
          collapsed: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadiusSize),
              ),
            ),
            onPressed: () => SocketService().disconnect(),
            child: Text(
              "Leave",
              style: subTitleTextStyle,
            ),
          ),
          panel: Container(
            decoration: BoxDecoration(
              color: BlackPrimary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: _hikers
                  .map((entry) => Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("User:", style: subTitleTextStyle),
                              Gap(5),
                              Text(entry["stats"]["distance"].toString(),
                                  style: subTitleTextStyle)
                            ]),
                      ))
                  .toList(),
            ),
          ),
          body: FlutterMap(
            mapController: model.mapController,
            options: MapOptions(
              pinchZoomThreshold: 69.99999999999991,
              center: latlng.LatLng(46.227638, 2.213749),
              zoom: model.zoom,
              maxBounds: LatLngBounds(
                  latlng.LatLng(-90, -180.0), latlng.LatLng(90.0, 180.0)),
            ),
            children: [
              TileLayer(
                urlTemplate: getMap(),
                additionalOptions: const {
                  'accessToken': accessTokenMapBox,
                  'id': idMapBox
                },
              ),
              PlayerSkin(
                onLocationUpdate: (Position? position) {
                  final newPosition =
                      "${position?.latitude},${position?.longitude}";

                  if (position != null && lastPosition == null ||
                      position != null && lastPosition != newPosition) {
                    stats.distance +=
                        calcDistance(lastPosition ?? newPosition, newPosition);
                    lastPosition = newPosition;
                    SocketService().move(position, stats);
                  }
                },
              ),
              PolylineLayer(
                polylines: model.polylines.isEmpty ? [] : model.polylines,
              ),
              MarkerLayer(
                markers: _hikers.isEmpty
                    ? []
                    : _hikers
                        .map((entry) => entry["marker"] as Marker)
                        .toList(),
              ),
            ],
          ),
        ),
      );
    });
  }
}