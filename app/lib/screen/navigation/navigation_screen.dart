import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:convert';
import 'package:hikup/screen/main/mapbox/Components/map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hikup/theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:hikup/utils/socket/socket.dart';
import "package:hikup/model/hike.dart";
import 'package:geolocator/geolocator.dart';
import 'package:hikup/model/navigation.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:hikup/widget/custom_btn.dart";

class NavigationScreen extends StatefulWidget {
  final Hike hike;
  final dynamic stats;
  final List<dynamic> hikers;
  const NavigationScreen({
    super.key,
    required this.hike,
    required this.stats,
    required this.hikers,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late HikerStats stats;
  String? lastPosition;
  late List<dynamic> _hikers;
  late Marker marker;
  late Polyline polyline;

  @override
  void initState() {
    super.initState();

    marker = Marker(
      width: 35,
      height: 35,
      point: LatLng(widget.hike.trail.latitude, widget.hike.trail.longitude),
      child: SizedBox(
        height: 35,
        width: 35,
        child: Image.asset(
          "assets/icons/start/start-${widget.hike.trail.difficulty}.png",
        ),
      ),
    );
    polyline = Polyline(
      points: json
          .decode(widget.hike.trail.geoJSON)["features"][0]["geometry"]
              ["coordinates"]
          .map<LatLng>((entry) => LatLng(entry[1], entry[0]))
          .toList(),
      color: widget.hike.trail.difficulty == 1
          ? const Color.fromRGBO(87, 252, 255, 0.8)
          : widget.hike.trail.difficulty == 2
              ? const Color.fromRGBO(72, 255, 201, 0.8)
              : widget.hike.trail.difficulty == 3
                  ? const Color.fromRGBO(194, 283, 255, 0.8)
                  : widget.hike.trail.difficulty == 4
                      ? const Color.fromRGBO(253, 210, 59, 0.8)
                      : widget.hike.trail.difficulty == 5
                          ? const Color.fromRGBO(87, 252, 255, 0.8)
                          : Colors.transparent,
      strokeWidth: 3.0,
      borderColor: const Color(0xFF1967D2),
      borderStrokeWidth: 0.1,
    );
    stats = HikerStats(
        steps: widget.stats["steps"],
        distance: widget.stats["distance"],
        completed: widget.stats["completed"]);
    _hikers = widget.hikers.map((entry) {
      late LatLng hikerLatLng =
          LatLng(entry["hiker"]["latitude"], entry["hiker"]["longitude"]);

      return {
        "id": entry["hiker"]["id"],
        "username": entry["hiker"]["username"],
        "picture": entry["hiker"]["picture"],
        "skin": entry["hiker"]["skin"],
        "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
        "marker": Marker(
          width: 56.0,
          height: 56.0,
          point: hikerLatLng,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Column(children: <Widget>[
                CachedNetworkImage(
                  imageUrl: entry["hiker"]["skin"],
                  errorWidget: (context, url, error) => const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      entry["hiker"]["username"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ])),
        ),
        "stats": entry["hiker"]["stats"]
      };
    }).toList();
    SocketService().hike.onJoin((data) {
      dynamic entry = json.decode(data);
      late LatLng hikerLatLng =
          LatLng(entry["hiker"]["latitude"], entry["hiker"]["longitude"]);

      setState(() {
        _hikers = [
          ..._hikers,
          {
            "id": entry["hiker"]["id"],
            "username": entry["hiker"]["username"],
            "picture": entry["hiker"]["picture"],
            "skin": entry["hiker"]["skin"],
            "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
            "marker": Marker(
              width: 56.0,
              height: 56.0,
              point: hikerLatLng,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: entry["hiker"]["skin"],
                      errorWidget: (context, url, error) => const Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          entry["hiker"]["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ])),
            ),
            "stats": entry["hiker"]["stats"]
          }
        ];
      });
    });
    SocketService().hike.onLeave((data) {
      dynamic entry = json.decode(data);

      setState(() {
        _hikers.removeWhere((item) => item["id"] == entry["hiker"]["id"]);
      });
    });
    SocketService().hike.onMove((data) {
      dynamic entry = json.decode(data);
      late LatLng hikerLatLng =
          LatLng(entry["hiker"]["latitude"], entry["hiker"]["longitude"]);
      final newHiker = {
        "id": entry["hiker"]["id"],
        "username": entry["hiker"]["username"],
        "picture": entry["hiker"]["picture"],
        "skin": entry["hiker"]["skin"],
        "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
        "marker": Marker(
          width: 56.0,
          height: 56.0,
          point: hikerLatLng,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Column(children: <Widget>[
                CachedNetworkImage(
                  imageUrl: entry["hiker"]["skin"],
                  errorWidget: (context, url, error) => const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      entry["hiker"]["username"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ])),
        ),
        "stats": entry["hiker"]["stats"]
      };
      int index =
          _hikers.indexWhere((item) => item["id"] == entry["hiker"]["id"]);

      if (index >= 0 &&
          _hikers[index]["LatLng"] != null &&
          newHiker["LatLng"] != _hikers[index]["LatLng"]) {
        setState(() {
          _hikers[index] = newHiker;
        });
      }
    });
  }

  @override
  void dispose() {
    SocketService().disconnect();
    super.dispose();
  }

  int calcDistance(String latLng1, String latLng2) {
    List<double> splitLatLng1 = [
      double.parse(latLng1.split(',')[0]),
      double.parse(latLng1.split(',')[1])
    ];
    List<double> splitLatLng2 = [
      double.parse(latLng2.split(',')[0]),
      double.parse(latLng2.split(',')[1])
    ];
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((splitLatLng2[0] - splitLatLng1[0]) * p) / 2 +
        c(splitLatLng1[0] * p) *
            c(splitLatLng2[0] * p) *
            (1 - c((splitLatLng2[1] - splitLatLng1[1]) * p)) /
            2;
    return ((12742 * asin(sqrt(a))) * 1000).round();
  }

  CachedNetworkImage loadHikerPicture(double size, String picture) {
    return CachedNetworkImage(
      imageUrl: picture,
      progressIndicatorBuilder: (context, url, progress) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: BlackPrimary,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: BlackSecondary,
        ),
        child: const Icon(
          FontAwesomeIcons.triangleExclamation,
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: BlackPrimary,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: imageProvider,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MapViewModel>(builder: (context, model, child) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        body: SlidingUpPanel(
            renderPanelSheet: false,
            minHeight: 100,
            collapsed: Consumer<AppState>(builder: (context, state, child) {
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 10.0),
                decoration: const BoxDecoration(
                  color: BlackPrimary,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      LoadPictureProfil(appState: state, size: 48),
                      const Gap(10),
                      Text(state.username, style: subTitleTextStyle),
                      const Gap(20),
                      const Icon(
                        Icons.hiking_rounded,
                        color: Colors.white,
                      ),
                      const Gap(5.0),
                      Text("${stats.distance}" " m", style: subTitleTextStyle),
                      const Gap(20),
                      CustomBtn(
                          bgColor: Colors.red,
                          textColor: Colors.white,
                          content: "X",
                          onPress: () {
                            SocketService().disconnect();
                            Navigator.pop(context);
                          }),
                    ]),
              );
            }),
            panel: Container(
              decoration: BoxDecoration(
                color: BlackPrimary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(children: <Widget>[
                const Gap(20),
                Text("Randonneurs", style: subTitleTextStyle),
                const Gap(20),
                Column(
                  children: _hikers.map((entry) {
                    int index =
                        _hikers.indexWhere((item) => item["id"] == entry["id"]);

                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.white.withOpacity(0.16)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            loadHikerPicture(48, entry["picture"].toString()),
                            const Gap(10),
                            Text(entry["username"].toString(),
                                style: subTitleTextStyle),
                            const Gap(20),
                            const Icon(
                              Icons.hiking_rounded,
                              color: Colors.white,
                            ),
                            const Gap(5.0),
                            Text("${entry["stats"]["distance"]} m",
                                style: subTitleTextStyle)
                          ]),
                    );
                  }).toList(),
                ),
              ]),
            ),
            body: MapBox(
              mapController: model.mapController,
              zoom: 17,
              polylines: [polyline],
              markers:
                  _hikers.map((entry) => entry["marker"] as Marker).toList(),
              onPositionChange: (Position position) {
                final newPosition =
                    "${position.latitude},${position.longitude}";

                if (lastPosition == null || lastPosition != newPosition) {
                  final HikerStats newStats = HikerStats(
                      steps: stats.steps,
                      distance: stats.distance +
                          calcDistance(
                              lastPosition ?? newPosition, newPosition),
                      completed: stats.completed);
                  lastPosition = newPosition;
                  SocketService().hike.move(position, newStats);
                  setState(() {
                    stats = newStats;
                  });
                }
              },
            )),
      );
    });
  }
}
