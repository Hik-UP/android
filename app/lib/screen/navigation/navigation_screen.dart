import 'package:flutter/material.dart';
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
  static String routeName = "/navigation";
  const NavigationScreen({
    Key? key,
    required this.hike,
  }) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  void initState() {
    super.initState();
    AppState appState = context.read<AppState>();
    context.read<AppState>().getUserFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MapViewModel>(builder: (context, model, child) {
      SocketService().onHikeJoined((data) => print(data));
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
              markers: model.loading ? [] : model.markers,
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
