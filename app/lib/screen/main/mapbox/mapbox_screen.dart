import 'package:flutter/material.dart';
import 'package:hikup/screen/main/mapbox/Components/map.dart';
import 'package:hikup/widget/Header/header.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/community/comments/home.dart';

class MapBoxScreen extends StatefulWidget {
  const MapBoxScreen({
    super.key,
  });

  @override
  State<MapBoxScreen> createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> with RouteAware {
  final PanelController _pc = PanelController();

  //_pc.hide();
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
    context.read<AppState>().getUserFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MapViewModel>(builder: (context, model, child) {
      Future<void> _launchUrl(String url) async {
        if (!await launchUrl(Uri.parse(url))) {
          throw Exception('Could not launch URL');
        }
      }

      String durationToString(int minutes) {
        var d = Duration(minutes: minutes);
        List<String> parts = d.toString().split(':');
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }

      model.mapController.mapEventStream.listen((event) {
        if (model.polylines.isNotEmpty && model.mapController.zoom <= 12) {
          model.polylines.clear();
          _pc.hide();
        }
      });

      if (_pc.isAttached && model.trailsList.isNotEmpty) {
        _pc.show();
      } else if (_pc.isAttached) {
        _pc.hide();
      }

      if (model.loading == true) {
        model.trails(
          appState: context.read<AppState>(),
          updateScreen: () => setState(
            () {},
          ),
        );
      }

      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const Header(),
          body: SlidingUpPanel(
              controller: _pc,
              renderPanelSheet: false,
              minHeight: 110,

              /* COLLAPSED PANEL */
              collapsed: Container(
                margin: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                decoration: BoxDecoration(
                  color: BlackPrimary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Text(
                        model.trailsList.isEmpty
                            ? ""
                            : model.trailsList[0].name,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]),
              ),

              /* PANEL */
              panel: Container(
                decoration: BoxDecoration(
                  color: BlackPrimary,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                child: model.trailsList.isEmpty
                    ? null
                    : Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 90,
                                    child: Center(
                                      child: Text(
                                        model.trailsList.isEmpty
                                            ? ""
                                            : model.trailsList[0].name,
                                        maxLines: 2,
                                        style: subTitleTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: loginButtonColor,
                                          borderRadius: BorderRadius.circular(
                                              borderRadiusSize),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 70,
                                          minHeight: 25,
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      borderRadiusSize),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (model.trailsList.isNotEmpty) {
                                              _launchUrl(
                                                  "https://maps.google.com/?q=${model.trailsList[0].latitude},${model.trailsList[0].longitude}");
                                            }
                                          },
                                          child: Text(
                                            "Direction",
                                            style: subTitleTextStyle,
                                          ),
                                        ),
                                      ),
                                      const Gap(10.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: loginButtonColor,
                                          borderRadius: BorderRadius.circular(
                                              borderRadiusSize),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 70,
                                          minHeight: 25,
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      borderRadiusSize),
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CommunityView(
                                                trailId: model.trailsList[0].id,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Avis",
                                            style: subTitleTextStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(20.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Labels:",
                                        style: subTitleTextStyle,
                                      ),
                                      const Gap(10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: model.trailsList[0].labels
                                            .map(
                                              (label) => Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                margin: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Text(
                                                  label,
                                                  style: subTitleTextStyle,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                  const Gap(20.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Difficulté:",
                                        style: subTitleTextStyle,
                                      ),
                                      const Gap(10.0),
                                      Text(
                                        "${model.trailsList[0].difficulty} / 5",
                                        style: subTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                  const Gap(10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Distance:",
                                        style: subTitleTextStyle,
                                      ),
                                      const Gap(10.0),
                                      Text(
                                        "${model.trailsList[0].distance / 1000} km",
                                        style: subTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                  const Gap(10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Durée:",
                                        style: subTitleTextStyle,
                                      ),
                                      const Gap(10.0),
                                      Text(
                                        durationToString(
                                            model.trailsList[0].duration),
                                        style: subTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                  const Gap(10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Dénivelé ↗:",
                                        style: subTitleTextStyle,
                                      ),
                                      const Gap(10.0),
                                      Text(
                                        "${model.trailsList[0].uphill} m",
                                        style: subTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                  const Gap(10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Dénivelé ↘:",
                                        style: subTitleTextStyle,
                                      ),
                                      const Gap(10.0),
                                      Text(
                                        "${model.trailsList[0].downhill} m",
                                        style: subTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              /* MAP */
              body: MapBox(
                mapController: model.mapController,
                zoom: model.zoom,
                polylines: model.polylines,
                markers: model.markers,
              )));
    });
  }
}
