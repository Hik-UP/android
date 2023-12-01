import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PlayerSkin extends StatefulWidget {
  final Function(Position)? onPositionChange;
  const PlayerSkin({super.key, this.onPositionChange});
  @override
  State<PlayerSkin> createState() => _PlayerSkinState();
}

class _PlayerSkinState extends State<PlayerSkin> {
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<CompassEvent>? _headingStream;
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late final StreamController<LocationMarkerHeading> _headingStreamController;
  var firstCameraMove = false;
  int skinState = 0;

  @override
  void initState() {
    super.initState();
    _positionStreamController = StreamController()
      ..add(
        LocationMarkerPosition(
          latitude: 46.71109,
          longitude: 1.7191036,
          accuracy: 0,
        ),
      );
    _headingStreamController = StreamController()
      ..add(
        LocationMarkerHeading(
          heading: 0,
          accuracy: 0,
        ),
      );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _positionStreamController.close();
    _headingStream?.cancel();
    _headingStreamController.close();
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
              _headingStream?.cancel();
              _headingStream = null;
            default:
              _positionStream ??= Geolocator.getPositionStream(
                      locationSettings: const LocationSettings(
                          accuracy: LocationAccuracy.high,
                          distanceFilter: 1,
                          timeLimit: Duration(seconds: 5)))
                  .listen((Position position) {
                if (firstCameraMove == false) {
                  MapController.of(context)
                      .move(LatLng(position.latitude, position.longitude), 18);
                  setState(() {
                    firstCameraMove = true;
                  });
                }
                _positionStreamController.add(
                  LocationMarkerPosition(
                    latitude: position.latitude,
                    longitude: position.longitude,
                    accuracy: 0,
                  ),
                );
                widget.onPositionChange!(position);
              });
              _headingStream ??=
                  FlutterCompass.events?.listen((CompassEvent event) {
                double? direction = event.heading! < 0
                    ? 360 - event.heading!.abs()
                    : event.heading;

                if (direction != null) {
                  if (direction >= 315 || direction < 45) {
                    // UP
                    setState(() {
                      skinState = 2;
                    });
                  } else if (direction >= 45 && direction < 135) {
                    // RIGHT
                    setState(() {
                      skinState = 3;
                    });
                  } else if (direction >= 135 && direction < 225) {
                    // DOWN
                    setState(() {
                      skinState = 0;
                    });
                  } else if (direction >= 225 && direction < 315) {
                    // LEFT
                    setState(() {
                      skinState = 1;
                    });
                  } else {
                    setState(() {
                      skinState = 0;
                    });
                  }
                } else {
                  setState(() {
                    skinState = 0;
                  });
                }
              });
          }
        },
        child: CurrentLocationLayer(
          positionStream: _positionStreamController.stream,
          headingStream: _headingStreamController.stream,
          followOnLocationUpdate: FollowOnLocationUpdate.once,
          turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
          style: LocationMarkerStyle(
            marker: appState.skin.model.isNotEmpty
                ? firstCameraMove
                    ? CachedNetworkImage(
                        imageUrl: appState.skin.pictures[skinState],
                        errorWidget: (context, url, error) => const Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                      )
                    : ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.modulate,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: appState.skin.pictures[skinState],
                          errorWidget: (context, url, error) => const Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                        ),
                      )
                : firstCameraMove
                    ? const Image(
                        image: AssetImage(
                          'assets/images/skin.png',
                        ),
                      )
                    : const ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.modulate,
                        ),
                        child: Image(
                          image: AssetImage(
                            'assets/images/skin.png',
                          ),
                        ),
                      ),
            markerSize: const Size(40, 40),
            markerDirection: MarkerDirection.heading,
          ),
        ));
  }
}
