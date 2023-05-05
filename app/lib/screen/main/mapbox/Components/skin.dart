import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hikup/model/skin.dart';

import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'retail.dart';

class PlayerSkin extends StatefulWidget {
  const PlayerSkin({Key? key}) : super(key: key);

  @override
  State<PlayerSkin> createState() => _PlayerSkinState();
}

class _PlayerSkinState extends State<PlayerSkin> {
  Future<Skin>? _skinFuture;

  @override
  void initState() {
    super.initState();
    _skinFuture = retailSkin(context.read<AppState>());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Skin>(
      future: _skinFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final appState = context.read<AppState>();
          appState.skin = snapshot.data!;

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
        } else if (snapshot.hasError) {
          return Text('Error fetching skin data');
        } else {
          return const CircularProgressIndicator();
        }
      },
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
