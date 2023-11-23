import 'dart:convert';
import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/screen/main/mapbox/Components/map.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/back_icon.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSliverAppBar extends StatelessWidget {
  final TrailFields field;
  final String? date;
  const CustomSliverAppBar({
    super.key,
    this.date,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    Color trailColor = field.difficulty == 1
        ? const Color.fromRGBO(87, 252, 255, 0.8)
        : field.difficulty == 2
            ? const Color.fromRGBO(72, 255, 201, 0.8)
            : field.difficulty == 3
                ? const Color.fromRGBO(194, 283, 255, 0.8)
                : field.difficulty == 4
                    ? const Color.fromRGBO(253, 210, 59, 0.8)
                    : field.difficulty == 5
                        ? const Color.fromRGBO(87, 252, 255, 0.8)
                        : Colors.transparent;
    final Polyline polyline = Polyline(
      points: json
          .decode(field.geoJSON)["features"][0]["geometry"]["coordinates"]
          .map<LatLng>((entry) => LatLng(entry[1], entry[0]))
          .toList(),
      color: trailColor,
      strokeWidth: 3.0,
      borderColor: const Color(0xFF1967D2),
      borderStrokeWidth: 0.1,
    );
    final Marker marker = Marker(
      width: 35,
      height: 35,
      point: LatLng(field.latitude, field.longitude),
      child: SizedBox(
        height: 35,
        width: 35,
        child: Image.asset(
          "assets/icons/start/start-${field.difficulty}.png",
        ),
      ),
    );

    return SliverAppBar(
      clipBehavior: Clip.none,
      backgroundColor: Colors.black,
      pinned: true,
      toolbarHeight: date != null ? 70 : kToolbarHeight,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          width: MediaQuery.of(context).size.width,
          height: date != null ? 70 : kToolbarHeight,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: trailColor, width: 4),
            ),
            color: Colors.black,
          ),
          child: Center(
            child: Container(
                margin: const EdgeInsets.fromLTRB(50.0, 4.0, 50.0, 4.0),
                child: Column(children: [
                  Text(
                    field.name,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  date != null ? const Gap(5) : Container(),
                  date != null
                      ? Text(
                          date ?? '',
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        )
                      : Container()
                ])),
          ),
        ),
        background: MapBox(
          interactiveFlags: InteractiveFlag.none,
          enableScrollWheel: false,
          zoom: 13,
          center: LatLng(field.latitude, field.longitude),
          showSkin: false,
          polylines: [polyline],
          markers: [marker],
        ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: const BackIcon(),
      actions: const [],
      expandedHeight: 400,
    );
  }
}
