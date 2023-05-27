import 'package:flutter/material.dart';
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

class NavigationScreen extends StatefulWidget {
  final Hike hike;
  final List<dynamic> hikers;
  const NavigationScreen({
    Key? key,
    required this.hike,
    required this.hikers,
  }) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late List<Marker> hikersMarkers;

  @override
  void initState() {
    super.initState();
    AppState appState = context.read<AppState>();
    hikersMarkers = widget.hikers.map((entry) {
      late latlng.LatLng hikerLatLng = latlng.LatLng(
          entry["hiker"]["latitude"], entry["hiker"]["longitude"]);

      return Marker(
        width: 26.0,
        height: 26.0,
        point: hikerLatLng,
        builder: (ctx) => const Icon(Icons.fiber_manual_record_rounded,
            color: Colors.blue, size: 24.0),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MapViewModel>(builder: (context, model, child) {
      print(hikersMarkers);
      SocketService().onHikeJoined((data) {
        dynamic entry = json.decode(data);
        late latlng.LatLng hikerLatLng = latlng.LatLng(
            entry["hiker"]["latitude"], entry["hiker"]["longitude"]);

        setState(() {
          hikersMarkers = [
            ...hikersMarkers,
            Marker(
              width: 26.0,
              height: 26.0,
              point: hikerLatLng,
              builder: (ctx) => const Icon(Icons.fiber_manual_record_rounded,
                  color: Colors.blue, size: 24.0),
            )
          ];
        });
      });

      return Scaffold(
        extendBodyBehindAppBar: true,
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
            const PlayerSkin(),
            PolylineLayer(
              polylines: model.polylines.isEmpty ? [] : model.polylines,
            ),
            MarkerLayer(
              markers: hikersMarkers.isEmpty ? [] : hikersMarkers,
            ),
          ],
        ),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: BlackPrimary,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: loginButtonColor,
                borderRadius: BorderRadius.circular(borderRadiusSize),
              ),
              constraints: const BoxConstraints(
                minWidth: 100,
                minHeight: 45,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadiusSize),
                  ),
                ),
                onPressed: () => SocketService().test(),
                child: Text(
                  "ok",
                  style: subTitleTextStyle,
                ),
              ),
            )),
      );
    });
  }
}
