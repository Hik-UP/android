import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';

class PlayerSkin extends StatefulWidget {
  const PlayerSkin({Key? key}) : super(key: key);
  @override
  State<PlayerSkin> createState() => _PlayerSkinState();
}

class _PlayerSkinState extends State<PlayerSkin> {
  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return CurrentLocationLayer(
      followOnLocationUpdate: FollowOnLocationUpdate.once,
      turnOnHeadingUpdate: TurnOnHeadingUpdate.always,
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
