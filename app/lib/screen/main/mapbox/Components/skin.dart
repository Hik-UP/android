import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class PlayerSkin extends StatefulWidget {
  const PlayerSkin({Key? key}) : super(key: key);

  @override
  State<PlayerSkin> createState() => _PlayerSkinState();
}

class _PlayerSkinState extends State<PlayerSkin> {
  @override
  Widget build(BuildContext context) {
    return CurrentLocationLayer(
        followOnLocationUpdate: FollowOnLocationUpdate.always,
        turnOnHeadingUpdate: TurnOnHeadingUpdate.always,
        style: const LocationMarkerStyle(
          marker: DefaultLocationMarker(
            child: Icon(
              Icons.navigation,
              color: Colors.white,
            ),
          ),
          markerSize: Size(40, 40),
          markerDirection: MarkerDirection.heading,
        ));
  }
}
