import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import 'skin.dart';
import 'map_over_time.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/comment.dart';

typedef void IntCallback(int id);

class MapBox extends StatefulWidget {
  final PanelController panelController;

  const MapBox({required this.panelController, Key? key}) : super(key: key);

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  PanelController _pc = new PanelController();

  @override
  void initState() {
    super.initState();
    AppState appState = context.read<AppState>();
    _pc = widget.panelController;
    //Here , techincally MapBox is the first widget that called after login/register
    //So, here we simulate an request
    //If the token of user is expired, our logout on the interceptors will be executed
    WrapperApi().getProfile(
      id: appState.id,
      roles: appState.roles,
      token: appState.token,
    );
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
        if (!model.polylines.isEmpty) {
          _pc.show();
        } else {
          _pc.hide();
        }
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
              maxBounds: LatLngBounds(
                  latlng.LatLng(-90, -180.0), latlng.LatLng(90.0, 180.0))),
          children: [
            TileLayer(
              urlTemplate: getMap(),
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
