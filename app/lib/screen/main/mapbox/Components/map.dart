import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/utils/constant.dart';
import 'skin.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedometer/pedometer.dart';

Future<String> getMapCachePath() async {
  final cacheDirectory = await getTemporaryDirectory();
  return cacheDirectory.path;
}

class MapBox extends StatefulWidget {
  final MapController? mapController;
  final int? interactiveFlags;
  final bool? enableScrollWheel;
  final double? zoom;
  final LatLng? center;
  final bool? showSkin;
  final List<Polyline>? polylines;
  final List<Marker>? markers;
  final Function(Position)? onPositionChange;
  final Function(PedestrianStatus)? onPedestrianStatusChange;
  final Function(int)? onSkinStateChange;
  const MapBox(
      {super.key,
      this.mapController,
      this.interactiveFlags,
      this.enableScrollWheel,
      this.zoom,
      this.center,
      this.showSkin,
      this.polylines,
      this.markers,
      this.onPositionChange,
      this.onPedestrianStatusChange,
      this.onSkinStateChange});

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  @override
  void initState() {
    super.initState();
  }

  /*static Future<String> getMapCachePath() async {
    late String mapCachePath;

    if (kIsWeb) {
      mapCachePath = 'HiveCacheStore';
    } else {
      mapCachePath = (await getTemporaryDirectory()).path;
    }
    return mapCachePath;
  }*/

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        interactionOptions: InteractionOptions(
            enableScrollWheel: widget.enableScrollWheel ?? true,
            flags: widget.interactiveFlags ?? InteractiveFlag.all,
            pinchZoomThreshold: 69.99999999999991),
        initialZoom: widget.zoom ?? 18,
        initialCenter: widget.center ?? const LatLng(0, 0),
        maxZoom: 18,
        minZoom: 5,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
              const LatLng(-90, -180.0), const LatLng(90.0, 180.0)),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: mapUrl,
          userAgentPackageName: 'hikup.flutter.com',
          retinaMode: true,
          maxZoom: 18,
          minZoom: 5,
          additionalOptions: const {
            'accessToken': accessTokenMapBox,
            'id': mapIdDay
          },
          tileProvider: CancellableNetworkTileProvider(),
        ),
        Visibility(
            visible: widget.showSkin ?? true,
            child: PlayerSkin(
              onPositionChange: widget.onPositionChange,
              onPedestrianStatusChange: widget.onPedestrianStatusChange,
              onSkinStateChange: widget.onSkinStateChange,
            )),
        PolylineLayer(
          polylines: widget.polylines ?? [],
        ),
        MarkerLayer(
          markers: widget.markers ?? [],
        ),
      ],
    );
  }
}
