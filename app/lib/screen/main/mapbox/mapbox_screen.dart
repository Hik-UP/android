import 'package:flutter/material.dart';
import 'package:hikup/widget/header.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/comment.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import 'Components/skin.dart';
import 'Components/map_over_time.dart';

class MapBoxScreen extends StatefulWidget {
  const MapBoxScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapBoxScreen> createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> {
  PanelController _pc = new PanelController();

  @override
  void initState() {
    super.initState();
    AppState appState = context.read<AppState>();
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
        model.mapController.mapEventStream.listen((event) {
          if (!model.polylines.isEmpty && model.mapController.zoom <= 12) {
            model.polylines.clear();
             _pc.hide();
          }
        });
        if (_pc.isAttached && !model.trailsList.isEmpty) {
          _pc.show();
        } else if (_pc.isAttached) {
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

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: Header(),
          body: SlidingUpPanel(
            controller: _pc,
            renderPanelSheet: false,
            minHeight: 120,

            /* PANEL */
            panel: Container(
              decoration: BoxDecoration(
                color:BlackPrimary,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Text(
                  model.trailsList.isEmpty ? "" : model.trailsList[0].name,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            /* MAP */
            body: FlutterMap(
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
            )
          )
        );
      }
    );
  }
}
