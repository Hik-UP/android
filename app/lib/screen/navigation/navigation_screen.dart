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
import 'package:hikup/locator.dart';
import 'package:hikup/service/custom_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final Function() onLeave;
  const Header({super.key, required this.onLeave});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 156, 156, 156),
      ),
      centerTitle: true,
      title: Text(
        "HIK'UP",
        style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.italic),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Row(
          children: [
            GestureDetector(
              onTap: () => onLeave(),
              child: const Icon(
                FontAwesomeIcons.arrowRightFromBracket,
              ),
            ),
            const Gap(16.0),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
  final _navigator = locator<CustomNavigationService>();
  late HikerStats stats;
  String? lastPosition;
  late List<dynamic> _hikers;
  late Marker marker;
  late Polyline polyline;
  final List<dynamic> _coins = [];
  bool panelContent = false;

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

    for (var i = 0; i < widget.hike.coins.length; i += 1) {
      _coins.add({
        "obj": widget.hike.coins[i],
        "marker": Marker(
            width: 35,
            height: 35,
            point: LatLng(
                widget.hike.coins[i].latitude, widget.hike.coins[i].longitude),
            child: Image.asset(
              "assets/icons/coin.gif",
            ))
      });
    }
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
        coins: widget.stats["coins"],
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
        "skinState": entry["hiker"]["skinState"],
        "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
        "marker": Marker(
          width: 56.0,
          height: 56.0,
          point: hikerLatLng,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Column(children: <Widget>[
                Text(
                  entry["hiker"]["username"],
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                ),
                CachedNetworkImage(
                  imageUrl: entry["hiker"]["skin"][entry["hiker"]["skinState"]],
                  errorWidget: (context, url, error) => const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                    child: Column(children: [
                      Text(
                          "${calcDistance(lastPosition ?? "0,0", "${hikerLatLng.latitude},${hikerLatLng.longitude}")} m",
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              height: 1.2,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontStyle: FontStyle.italic)),
                    ])),
              ])),
        ),
        "stats": entry["hiker"]["stats"]
      };
    }).toList();
    SocketService().hike.onJoin((data) {
      dynamic entry = json.decode(data);
      late LatLng hikerLatLng =
          LatLng(entry["hiker"]["latitude"], entry["hiker"]["longitude"]);

      _navigator.showSnackBack(
        content: "${entry["hiker"]["username"]} a rejoint la randonnée.",
        isError: false,
      );
      setState(() {
        _hikers = [
          ..._hikers,
          {
            "id": entry["hiker"]["id"],
            "username": entry["hiker"]["username"],
            "picture": entry["hiker"]["picture"],
            "skin": entry["hiker"]["skin"],
            "skinState": entry["hiker"]["skinState"],
            "LatLng": "${hikerLatLng.latitude},${hikerLatLng.longitude}",
            "marker": Marker(
              width: 56.0,
              height: 56.0,
              point: hikerLatLng,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(children: <Widget>[
                    Text(
                      entry["hiker"]["username"],
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    CachedNetworkImage(
                      imageUrl: entry["hiker"]["skin"]
                          [entry["hiker"]["skinState"]],
                      errorWidget: (context, url, error) => const Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                        child: Column(children: [
                          Text(
                              "${calcDistance(lastPosition ?? "0,0", "${hikerLatLng.latitude},${hikerLatLng.longitude}")} m",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                        ])),
                  ])),
            ),
            "stats": entry["hiker"]["stats"]
          }
        ];
      });
    });
    SocketService().hike.onLeave((data) {
      dynamic entry = json.decode(data);
      int index =
          _hikers.indexWhere((item) => item["id"] == entry["hiker"]["id"]);

      _navigator.showSnackBack(
        content: "${_hikers[index]["username"]} a quitté la randonnée.",
        isError: true,
      );
      setState(() {
        _hikers.removeAt(index);
      });
    });
    SocketService().hike.onMove((data) {
      dynamic entry = json.decode(data);
      late LatLng hikerLatLng =
          LatLng(entry["hiker"]["latitude"], entry["hiker"]["longitude"]);
      int index =
          _hikers.indexWhere((item) => item["id"] == entry["hiker"]["id"]);

      if (index >= 0 && _hikers[index]["LatLng"] != null) {
        setState(() {
          _hikers[index]["LatLng"] =
              "${hikerLatLng.latitude},${hikerLatLng.longitude}";
          _hikers[index]["stats"]["steps"] = entry["hiker"]["stats"]["steps"];
          _hikers[index]["stats"]["distance"] =
              entry["hiker"]["stats"]["distance"];
          _hikers[index]["stats"]["completed"] =
              entry["hiker"]["stats"]["completed"];
          _hikers[index]["marker"] = Marker(
            width: 56.0,
            height: 56.0,
            point: hikerLatLng,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Column(children: <Widget>[
                  Text(
                    _hikers[index]["username"],
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                  CachedNetworkImage(
                    imageUrl: _hikers[index]["skin"]
                        [_hikers[index]["skinState"]],
                    errorWidget: (context, url, error) => const Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                      child: Column(children: [
                        Text(
                            "${calcDistance(lastPosition ?? "0,0", "${hikerLatLng.latitude},${hikerLatLng.longitude}")} m",
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                height: 1.2,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontStyle: FontStyle.italic)),
                      ])),
                ])),
          );
        });
      }
    });
    SocketService().hike.onAnimate((data) {
      dynamic entry = json.decode(data);
      int index =
          _hikers.indexWhere((item) => item["id"] == entry["hiker"]["id"]);

      if (index >= 0 && entry["hiker"]["skinState"] != null) {
        setState(() {
          _hikers[index]["skinState"] = entry["hiker"]["skinState"];
          _hikers[index]["marker"] = Marker(
            width: 56.0,
            height: 56.0,
            point: LatLng(double.parse(_hikers[index]["LatLng"].split(',')[0]),
                double.parse(_hikers[index]["LatLng"].split(',')[1])),
            child: FittedBox(
                fit: BoxFit.contain,
                child: Column(children: <Widget>[
                  Text(
                    _hikers[index]["username"],
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                  CachedNetworkImage(
                    imageUrl: _hikers[index]["skin"]
                        [entry["hiker"]["skinState"]],
                    errorWidget: (context, url, error) => const Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                      child: Column(children: [
                        Text(
                            "${calcDistance(lastPosition ?? "0,0", "${_hikers[index]["LatLng"]}")} m",
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                height: 1.2,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontStyle: FontStyle.italic)),
                      ])),
                ])),
          );
        });
      }
    });
    SocketService().hike.onGetCoin((data) {
      dynamic entry = json.decode(data);

      onGetCoin(entry["coin"]["id"], entry["hiker"]["id"],
          entry["hiker"]["stats"]["coins"]);
    });
    SocketService().hike.onEnd((_) {
      onHikeEnd();
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

  void onGetCoin(String coinId, String userId, int coins) {
    if (userId != "") {
      int index = _hikers.indexWhere((item) => item["id"] == userId);

      setState(() {
        _hikers[index]["stats"]["coins"] = coins;
        _coins.removeWhere((item) => item["obj"].id == coinId);
      });
    } else {
      setState(() {
        stats.coins = coins;
        _coins.removeWhere((item) => item["obj"].id == coinId);
      });
    }
  }

  void onHikeEnd() {
    _navigator.showSnackBack(
      content: "Félicitations, vous avez terminé cette randonnée !",
      isError: false,
    );
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
        appBar: Header(
          onLeave: () {
            SocketService().disconnect();
            Navigator.pop(context);
          },
        ),
        extendBodyBehindAppBar: true,
        body: SlidingUpPanel(
            renderPanelSheet: false,
            minHeight: 100,
            isDraggable: _hikers.isNotEmpty,
            onPanelSlide: (value) => value != 0 && panelContent == false
                ? setState(() {
                    panelContent = true;
                  })
                : null,
            onPanelClosed: () => panelContent == true
                ? setState(() {
                    panelContent = false;
                  })
                : null,
            collapsed: Consumer<AppState>(builder: (context, state, child) {
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0)),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          LoadPictureProfil(appState: state, size: 48),
                          const Gap(10),
                          Text(state.username,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Icon(
                            Icons.hiking_rounded,
                            color: Colors.white,
                          ),
                          const Gap(5.0),
                          Text("${stats.distance}" " m",
                              style: subTitleTextStyle),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/coins.svg",
                            height: 22,
                            width: 22,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            semanticsLabel: 'error',
                          ),
                          const Gap(5.0),
                          Text("${stats.coins}", style: subTitleTextStyle),
                        ],
                      ),
                    ]),
              );
            }),
            panel: panelContent == true
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(children: <Widget>[
                      const Gap(20),
                      Text("Randonneurs",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontStyle: FontStyle.italic)),
                      const Gap(20),
                      Column(
                        children: _hikers.map((entry) {
                          return InkWell(
                              onTap: () => {
                                    model.mapController.move(
                                        LatLng(
                                            double.parse(
                                                entry["LatLng"].split(',')[0]),
                                            double.parse(
                                                entry["LatLng"].split(',')[1])),
                                        18)
                                  },
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 5.0, 15.0, 5.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          loadHikerPicture(
                                              48, entry["picture"].toString()),
                                          const Gap(10),
                                          Text(entry["username"].toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic)),
                                        ],
                                      ),
                                      const Gap(15),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.hiking_rounded,
                                            color: Colors.white,
                                          ),
                                          const Gap(5.0),
                                          Text(
                                              "${entry["stats"]["distance"]} m",
                                              style: subTitleTextStyle)
                                        ],
                                      ),
                                      const Gap(15),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/coins.svg",
                                            height: 22,
                                            width: 22,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                            semanticsLabel: 'error',
                                          ),
                                          const Gap(5.0),
                                          Text("${entry["stats"]["coins"]}",
                                              style: subTitleTextStyle)
                                        ],
                                      ),
                                    ]),
                              ));
                        }).toList(),
                      ),
                    ]),
                  )
                : Container(),
            body: MapBox(
              mapController: model.mapController,
              zoom: 17,
              polylines: [polyline],
              markers: [
                _coins.map((entry) => entry["marker"] as Marker).toList(),
                [marker],
                _hikers.map((entry) => entry["marker"] as Marker).toList(),
              ].expand((x) => x).toList(),
              onPositionChange: (Position position) {
                final newPosition =
                    "${position.latitude},${position.longitude}";

                if (lastPosition == null || lastPosition != newPosition) {
                  final HikerStats newStats = HikerStats(
                      coins: stats.coins,
                      steps: stats.steps,
                      distance: stats.distance +
                          calcDistance(
                              lastPosition ?? newPosition, newPosition),
                      completed: stats.completed);
                  lastPosition = newPosition;
                  SocketService().hike.move(position, newStats, (data) {
                    dynamic jsonData = json.decode(data);
                    final coin = jsonData["coin"];
                    final end = jsonData["end"];

                    if (coin != null) {
                      onGetCoin(coin, "", (stats.coins + 1));
                    }
                    if (end == true) {
                      onHikeEnd();
                    }
                  });
                  setState(() {
                    stats = newStats;
                  });
                }
              },
              onSkinStateChange: (int skinState) {
                SocketService().hike.animate(skinState);
              },
            )),
      );
    });
  }
}
