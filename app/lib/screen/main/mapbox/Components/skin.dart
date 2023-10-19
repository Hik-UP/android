import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PlayerSkin extends StatefulWidget {
  final Function(Position)? onPositionChange;
  const PlayerSkin({Key? key, this.onPositionChange}) : super(key: key);
  @override
  State<PlayerSkin> createState() => _PlayerSkinState();
}

class _PlayerSkinState extends State<PlayerSkin> {
  StreamSubscription<Position>? _positionStream;
  late final StreamController<LocationMarkerPosition> _positionStreamController;

  @override
  void initState() {
    super.initState();
    _positionStreamController = StreamController()
      ..add(
        LocationMarkerPosition(
          latitude: 0,
          longitude: 0,
          accuracy: 0,
        ),
      );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _positionStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return VisibilityDetector(
        key: const Key('mapSkin'),
        onVisibilityChanged: (visibilityInfo) {
          final visiblePercentage = visibilityInfo.visibleFraction * 100;

          switch (visiblePercentage) {
            case 0:
              _positionStream?.cancel();
              _positionStream = null;
            default:
              _positionStream ??= Geolocator.getPositionStream(
                      locationSettings: const LocationSettings(
                          accuracy: LocationAccuracy.high,
                          distanceFilter: 1,
                          timeLimit: Duration(seconds: 5)))
                  .listen((Position position) {
                _positionStreamController.add(
                  LocationMarkerPosition(
                    latitude: position.latitude,
                    longitude: position.longitude,
                    accuracy: 0,
                  ),
                );
                widget.onPositionChange!(position);
              });
          }
        },
        child: CurrentLocationLayer(
          positionStream: _positionStreamController.stream,
          followOnLocationUpdate: FollowOnLocationUpdate.once,
          turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
          style: LocationMarkerStyle(
            marker: appState.skin.pictures.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: appState.skin.model,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                  )
                : const DefaultLocationMarker(),
            markerSize: const Size(40, 40),
            markerDirection: MarkerDirection.heading,
          ),
        ));
  }
}
