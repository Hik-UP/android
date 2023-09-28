import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/utils/constant.dart';
import 'skin.dart';
import 'package:latlong2/latlong.dart';

class MapBox extends StatefulWidget {
  final MapController? mapController;
  final int? interactiveFlags;
  final bool? enableScrollWheel;
  final double? zoom;
  final LatLng? center;
  final bool? showSkin;
  final List<Polyline>? polylines;
  final List<Marker>? markers;
  const MapBox(
      {Key? key,
      this.mapController,
      this.interactiveFlags,
      this.enableScrollWheel,
      this.zoom,
      this.center,
      this.showSkin,
      this.polylines,
      this.markers})
      : super(key: key);

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        interactiveFlags: widget.interactiveFlags ?? InteractiveFlag.all,
        enableScrollWheel: widget.enableScrollWheel ?? true,
        zoom: widget.zoom ?? 18,
        //center: const LatLng(46.227638, 2.213749),
        center: widget.center,
        maxZoom: 17,
        maxBounds:
            LatLngBounds(const LatLng(-90, -180.0), const LatLng(90.0, 180.0)),
        pinchZoomThreshold: 69.99999999999991,
      ),
      children: [
        TileLayer(urlTemplate: mapUrl, retinaMode: true, maxZoom: 18
            /*additionalOptions: {
                      'accessToken': accessTokenMapBox,
                      'id': getMapId()
                    },*/
            ),
        Visibility(visible: widget.showSkin ?? true, child: const PlayerSkin()),
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
