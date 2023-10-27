import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/screen/main/mapbox/Components/map_over_time.dart';
import 'package:hikup/utils/constant.dart';
import 'skin.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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
      this.onPositionChange});

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  @override
  void initState() {
    super.initState();
  }

  final Future<String> _mapCachePath = getMapCachePath();

  static Future<String> getMapCachePath() async {
    late String mapCachePath;

    if (kIsWeb) {
      mapCachePath = 'HiveCacheStore';
    } else {
      mapCachePath = (await getTemporaryDirectory()).path;
    }
    return mapCachePath;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _mapCachePath,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final mapCachePath = snapshot.data!;
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
                  additionalOptions: {
                    'accessToken': accessTokenMapBox,
                    'id': getMapId()
                  },
                  tileProvider: CachedTileProvider(
                    keyBuilder: (request) {
                      return const Uuid().v5(
                        Uuid.NAMESPACE_URL,
                        request.uri.replace(queryParameters: {}).toString(),
                      );
                    },
                    maxStale: const Duration(days: 30),
                    store: HiveCacheStore(
                      mapCachePath,
                      hiveBoxName: 'HiveCacheStore',
                    ),
                  ),
                ),
                Visibility(
                    visible: widget.showSkin ?? true,
                    child:
                        PlayerSkin(onPositionChange: widget.onPositionChange)),
                PolylineLayer(
                  polylines: widget.polylines ?? [],
                ),
                MarkerLayer(
                  markers: widget.markers ?? [],
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
