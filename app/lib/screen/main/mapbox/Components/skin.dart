import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import "package:hikup/utils/constant.dart";

class PlayerSkin extends StatefulWidget {
  final Function(Position? position)? onLocationUpdate;
  const PlayerSkin({Key? key, this.onLocationUpdate}) : super(key: key);
  @override
  State<PlayerSkin> createState() => _PlayerSkinState();
}

class _PlayerSkinState extends State<PlayerSkin> {
  @override
  void initState() {
    super.initState();
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen(widget.onLocationUpdate);
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return CurrentLocationLayer(
      positionStream:
          LocationMarkerDataStreamFactory().fromGeolocatorPositionStream(
        stream: Geolocator.getPositionStream(locationSettings: locationSettings)
            .asBroadcastStream(),
      ),
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
    );
  }
}

class MarkerComponent extends StatelessWidget {
  const MarkerComponent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DefaultLocationMarker(
      child: Icon(
        Icons.navigation,
        color: Colors.white,
      ),
    );
  }
}
