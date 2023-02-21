import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import 'skin.dart';

class MapBox extends StatefulWidget {
  const MapBox({Key? key}) : super(key: key);

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
    return BaseView<MapViewModel>(
      builder: (context, model, child) {
        /*model.mapController.mapEventStream.listen((event) {
          if (model.mapController.zoom >= 12) {
            print("OK");
          }
        });*/
        if (model.loading) {
          model.trails(
            appState: context.read<AppState>(),
            updateScreen: () => setState(
              () {},
            ),
          );
        }

        return FlutterMap(
          mapController: model.mapController,
          options: MapOptions(
            pinchZoomThreshold: 69.99999999999991,
            center: latlng.LatLng(46.227638, 2.213749),
            zoom: model.zoom,
            maxBounds: LatLngBounds(latlng.LatLng(-90, -180.0), latlng.LatLng(90.0, 180.0))
          ),
          children: [
            TileLayer(
              urlTemplate: urlTemplateMapBox,
              additionalOptions: const {
                'accessToken': accessTokenMapBox,
                'id': idMapBox
              },
            ),
            const PlayerSkin(),
            MarkerLayer(
              markers: model.loading ? [] : model.markers,
            ),
            PolylineLayer(
              polylines: model.polylines.isEmpty ? [] : model.polylines,
            )
          ],
        );
      },
    );
  }
}
