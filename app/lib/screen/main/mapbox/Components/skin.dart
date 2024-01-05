import 'dart:async';
import 'package:flutter/foundation.dart';
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
import 'package:pedometer/pedometer.dart';

class PlayerSkin extends StatefulWidget {
  final Function(Position)? onPositionChange;
  final Function(PedestrianStatus)? onPedestrianStatusChange;
  final Function(int)? onSkinStateChange;
  const PlayerSkin(
      {super.key,
      this.onPositionChange,
      this.onPedestrianStatusChange,
      this.onSkinStateChange});
  @override
  State<PlayerSkin> createState() => _PlayerSkinState();
}

class _PlayerSkinState extends State<PlayerSkin> {
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<CompassEvent>? _headingStream;
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late final StreamController<LocationMarkerHeading> _headingStreamController;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  var firstCameraMove = false;
  int skinState = 0;
  double _direction = 180;
  String _status = 'stopped';

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
    if (!kIsWeb) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream.listen((PedestrianStatus event) {
        setState(() {
          String status = event.status;

          if (status == 'stopped') {
            if ((_direction >= 315 || _direction < 45) && skinState != 2) {
              // UP
              widget.onSkinStateChange!(2);
              setState(() {
                skinState = 2;
                _status = status;
              });
            } else if ((_direction >= 45 && _direction < 135) &&
                skinState != 3) {
              // RIGHT
              widget.onSkinStateChange!(3);
              setState(() {
                skinState = 3;
                _status = status;
              });
            } else if ((_direction >= 135 && _direction < 225) &&
                skinState != 0) {
              // DOWN
              widget.onSkinStateChange!(0);
              setState(() {
                skinState = 0;
                _status = status;
              });
            } else if ((_direction >= 225 && _direction < 315) &&
                skinState != 1) {
              // LEFT
              widget.onSkinStateChange!(1);
              setState(() {
                skinState = 1;
                _status = status;
              });
            }
          } else if (status == 'walking') {
            if ((_direction >= 315 || _direction < 45) && skinState != 6) {
              // UP
              widget.onSkinStateChange!(6);
              setState(() {
                skinState = 6;
                _status = status;
              });
            } else if ((_direction >= 45 && _direction < 135) &&
                skinState != 7) {
              // RIGHT
              widget.onSkinStateChange!(7);
              setState(() {
                skinState = 7;
                _status = status;
              });
            } else if ((_direction >= 135 && _direction < 225) &&
                skinState != 4) {
              // DOWN
              widget.onSkinStateChange!(4);
              setState(() {
                skinState = 4;
                _status = status;
              });
            } else if ((_direction >= 225 && _direction < 315) &&
                skinState != 5) {
              // LEFT
              widget.onSkinStateChange!(5);
              setState(() {
                skinState = 5;
                _status = status;
              });
            }
          } else if (skinState != 0) {
            widget.onSkinStateChange!(0);
            setState(() {
              skinState = 0;
            });
          }
          widget.onPedestrianStatusChange!(event);
        });
      });
    }
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

                if (direction != null && _status == 'stopped') {
                  if ((direction >= 315 || direction < 45) && skinState != 2) {
                    // UP
                    if (widget.onSkinStateChange != null) {
                      widget.onSkinStateChange!(2);
                    }
                    
                    setState(() {
                      skinState = 2;
                      _direction = direction;
                    });
                  } else if ((direction >= 45 && direction < 135) &&
                      skinState != 3) {
                    // RIGHT
                    widget.onSkinStateChange!(3);
                    setState(() {
                      skinState = 3;
                      _direction = direction;
                    });
                  } else if ((direction >= 135 && direction < 225) &&
                      skinState != 0) {
                    // DOWN
                    widget.onSkinStateChange!(0);
                    setState(() {
                      skinState = 0;
                      _direction = direction;
                    });
                  } else if ((direction >= 225 && direction < 315) &&
                      skinState != 1) {
                    // LEFT
                    widget.onSkinStateChange!(1);
                    setState(() {
                      skinState = 1;
                      _direction = direction;
                    });
                  }
                } else if (direction != null && _status == 'walking') {
                  if ((direction >= 315 || direction < 45) && skinState != 6) {
                    // UP
                    widget.onSkinStateChange!(6);
                    setState(() {
                      skinState = 6;
                      _direction = direction;
                    });
                  } else if ((direction >= 45 && direction < 135) &&
                      skinState != 7) {
                    // RIGHT
                    widget.onSkinStateChange!(7);
                    setState(() {
                      skinState = 7;
                      _direction = direction;
                    });
                  } else if ((direction >= 135 && direction < 225) &&
                      skinState != 4) {
                    // DOWN
                    widget.onSkinStateChange!(4);
                    setState(() {
                      skinState = 4;
                      _direction = direction;
                    });
                  } else if ((direction >= 225 && direction < 315) &&
                      skinState != 5) {
                    // LEFT
                    widget.onSkinStateChange!(5);
                    setState(() {
                      skinState = 5;
                      _direction = direction;
                    });
                  }
                } else if (skinState != 0) {
                  widget.onSkinStateChange!(0);
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
