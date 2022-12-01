import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;

class MapBox extends StatefulWidget {
  MapBox({Key? key, required this.geolocation}) : super(key: key);
  final Map<String, double> geolocation;

  final state = _MapState();
  @override
  _MapState createState() => state;

  void setGeolocation(Map<String, double> coords) =>
      state.setGeolocation(coords);
  void move(Map<String, double> coords) => state.move(coords);
  void addMarker(Map<String, double> props, Widget child) =>
      state.addMarker(props, child);
  void setMainMarker(Map<String, double> props, Widget child) =>
      state.setMainMarker(props, child);
}

class _MapState extends State<MapBox> {
  late latlng.LatLng _geolocation;
  late latlng.LatLng _center;
  late MapController _mapController;
  final double _zoom = 18.0;
  final double _markerWidth = 64.0;
  final double _markerHeight = 64.0;
  final List<Marker> _markers = [];

  @override
  void initState() {
    _geolocation =
        latlng.LatLng(widget.geolocation['x']!, widget.geolocation['y']!);
    _center = _geolocation;
    _mapController = MapController();
    super.initState();
  }

  void setGeolocation(Map<String, double> geolocation) {
    setState(() {
      _geolocation = latlng.LatLng(geolocation['x']!, geolocation['y']!);
    });
  }

  void move(Map<String, double> coords) {
    setState(() {
      _center = latlng.LatLng(coords['x']!, coords['y']!);
      _mapController.move(_center, _zoom);
    });
  }

  void addMarker(Map<String, double> props, Widget child) {
    setState(() {
      _markers.add(Marker(
          point: latlng.LatLng(props['x']!, props['y']!),
          builder: (ctx) => child,
          width: props['width']!,
          height: props['height']!));
    });
  }

  void setMainMarker(Map<String, double> props, Widget child) {
    setState(() {
      _markers[0] = Marker(
          point: latlng.LatLng(props['x']!, props['y']!),
          builder: (ctx) => child,
          width: props['width']!,
          height: props['height']!);
    });
  }

  List<Marker> getMarkers() {
    Marker geolocation = Marker(
      width: _markerWidth,
      height: _markerHeight,
      point: _geolocation,
      builder: (ctx) => const Icon(
        Icons.fiber_manual_record_rounded,
        color: Colors.blue,
        size: 24.0,
        semanticLabel: 'Text to announce in accessibility modes',
      ),
    );
    List<Marker> markers = List.from(_markers);
    markers.add(geolocation);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        pinchZoomThreshold: 69.99999999999991,
        center: _center,
        zoom: _zoom,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/sosobi93/ckw3j5g09bruf14plx1jdnu2d/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic29zb2JpOTMiLCJhIjoiY2t0anJlNGxzMWVrbjJ6cW5nd2RzNGQ5YyJ9.uHmz0NhV5QjGdD3zOOVVhg",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1Ijoic29zb2JpOTMiLCJhIjoiY2t0anJlNGxzMWVrbjJ6cW5nd2RzNGQ5YyJ9.uHmz0NhV5QjGdD3zOOVVhg',
            'id': 'mapbox.mapbox-streets-v8'
          },
          attributionBuilder: (_) {
            return const Text(
              '© Mapbox ',
              style:
                  TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
            );
          },
        ),
        MarkerLayerOptions(markers: getMarkers()),
      ],
    );
  }
}
