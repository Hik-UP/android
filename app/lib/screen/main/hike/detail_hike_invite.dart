import "package:flutter/material.dart";
import 'dart:convert';
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/guest.dart";
import "package:hikup/model/hike.dart";
import "package:hikup/model/trail_fields.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/main/mapbox/Components/map.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/viewmodel/detail_hike_invite.dart";
import "package:hikup/widget/base_view.dart";
import "package:hikup/widget/custom_btn.dart";
import "package:hikup/widget/display_address.dart";
import "package:hikup/widget/display_detail_trails.dart";
import "package:hikup/widget/guest_cmp.dart";
import "package:provider/provider.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import "package:hikup/screen/navigation/navigation_screen.dart";
import 'package:hikup/service/custom_navigation.dart';
import 'package:hikup/locator.dart';
import 'package:hikup/utils/socket/socket.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikup/widget/custom_sliver_app_bar.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailHikeInvite extends StatelessWidget {
  final Hike hike;
  static String routeName = "/detail-hike-invite";
  const DetailHikeInvite({
    super.key,
    required this.hike,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = locator<CustomNavigationService>();
    double maxHeight = MediaQuery.of(context).size.height;
    AppState appState = context.read<AppState>();
    final Marker marker = Marker(
      width: 35,
      height: 35,
      point: LatLng(hike.trail.latitude, hike.trail.longitude),
      child: SizedBox(
        height: 35,
        width: 35,
        child: Image.asset(
          "assets/icons/start/start-${hike.trail.difficulty}.png",
        ),
      ),
    );
    final Polyline polyline = Polyline(
      points: json
          .decode(hike.trail.geoJSON)["features"][0]["geometry"]["coordinates"]
          .map<LatLng>((entry) => LatLng(entry[1], entry[0]))
          .toList(),
      color: hike.trail.difficulty == 1
          ? const Color.fromRGBO(87, 252, 255, 0.8)
          : hike.trail.difficulty == 2
              ? const Color.fromRGBO(72, 255, 201, 0.8)
              : hike.trail.difficulty == 3
                  ? const Color.fromRGBO(194, 283, 255, 0.8)
                  : hike.trail.difficulty == 4
                      ? const Color.fromRGBO(253, 210, 59, 0.8)
                      : hike.trail.difficulty == 5
                          ? const Color.fromRGBO(87, 252, 255, 0.8)
                          : Colors.transparent,
      strokeWidth: 3.0,
      borderColor: const Color(0xFF1967D2),
      borderStrokeWidth: 0.1,
    );
    bool joinInProgress = false;
    final trail = TrailFields(
        id: hike.trail.id,
        name: hike.trail.name,
        address: hike.address,
        description: hike.trail.description,
        pictures: hike.trail.pictures,
        latitude: hike.trail.latitude,
        longitude: hike.trail.longitude,
        difficulty: hike.trail.difficulty,
        duration: hike.trail.duration,
        distance: hike.trail.distance,
        uphill: hike.trail.uphill,
        downhill: hike.trail.downhill,
        tools: hike.trail.tools,
        relatedArticles: hike.trail.relatedArticles,
        labels: hike.trail.labels,
        geoJSON: hike.trail.geoJSON,
        comments: hike.trail.comments,
        imageAsset: "",
        price: 0,
        openTime: "",
        closeTime: "");

    String formatDate() {
      var replaceDate = hike.schedule.replaceAll(RegExp(r'T'), ' ');
      var splitDate = replaceDate.split(' ');

      return "${splitDate[0]} ${splitDate[1].split(':').sublist(0, 2).join(':')}";
    }

    return BaseView<DetailHikeInviteViewModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(field: trail, date: formatDate()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      "Description :",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    const Gap(5.0),
                    Text(
                      trail.description.toString(),
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    const Gap(15.0),
                    Text(
                      "Difficulté :",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    const Gap(5.0),
                    RatingBarIndicator(
                      rating: trail.difficulty.toDouble(),
                      itemBuilder: (context, index) => SvgPicture.asset(
                          "assets/icons/details/lightning.svg",
                          colorFilter: const ColorFilter.mode(
                              Colors.amber, BlendMode.srcIn),
                          semanticsLabel: 'difficulty'),
                      itemCount: 5,
                      itemSize: 20,
                      unratedColor: Colors.amber.withAlpha(50),
                      direction: Axis.horizontal,
                    ),
                    const Gap(15.0),
                    Text(
                      "Équipements recommandés :",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    const Gap(5.0),
                    WrapperApi().showTools(
                      toolsBack: trail.tools,
                    ),
                    const Gap(15.0),
                    Text(
                      "Détails :",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    const Gap(5.0),
                    DisplayDetailTrails(
                      fontSize: 12,
                      trailId: trail.id,
                      duration: trail.duration,
                      distance: trail.distance,
                      upHill: trail.uphill,
                      downHill: trail.downhill,
                      difficulty: trail.difficulty,
                    ),
                    const Gap(15.0),
                    Text(
                      "Invitation(s)",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    const Gap(5.0),
                    hike.guests.isNotEmpty
                        ? ListOfGuestOrAttendee(
                            elements: hike.guests,
                          )
                        : const EmptyLabel(
                            label: "Aucune invitation en attente",
                          ),
                    const Gap(15.0),
                    Text(
                      "Participant(s)",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                    const Gap(5.0),
                    hike.attendee.isNotEmpty
                        ? ListOfGuestOrAttendee(
                            elements: hike.attendee,
                          )
                        : const EmptyLabel(
                            label: "Aucun participant",
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
          decoration: const BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                //color: GreenPrimary,
                offset: Offset(0, 0),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  LocationPermission permission =
                      await Geolocator.checkPermission();

                  if (permission != LocationPermission.whileInUse &&
                          permission != LocationPermission.always ||
                      !(await Geolocator.isLocationServiceEnabled())) {
                    navigator.showSnackBack(
                      content: 'Localisation inaccessible',
                      isError: true,
                    );
                    await Geolocator.requestPermission();
                    return;
                  }

                  if (joinInProgress == false) {
                    joinInProgress = true;
                    SocketService().connect(
                        token: appState.token,
                        userId: appState.id,
                        userRoles: appState.roles);
                    SocketService().onError((_) {
                      joinInProgress = false;
                      SocketService().disconnect();
                    });

                    await SocketService().hike.join(hike.id, (data) {
                      dynamic jsonData = json.decode(data);
                      dynamic stats = jsonData["stats"];
                      List<dynamic> hikers = jsonData["hikers"];

                      joinInProgress = false;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => NavigationScreen(
                                hike: hike, stats: stats, hikers: hikers),
                          ),
                          (r) => false);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    backgroundColor: const Color.fromRGBO(12, 60, 40, 1),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      width: 1.0,
                      color: Color.fromRGBO(21, 255, 120, 1),
                    )),
                child: const Text(
                  "Rejoindre",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Gap(5.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print("ok");
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    backgroundColor: const Color.fromRGBO(132, 16, 42, 1),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      width: 1.0,
                      color: Color.fromRGBO(255, 21, 63, 1),
                    )),
                child: const Text(
                  "Quitter",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ListOfGuestOrAttendee extends StatelessWidget {
  final List<Guest> elements;
  const ListOfGuestOrAttendee({
    super.key,
    required this.elements,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: elements.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: GuestCmp(
            picture: elements[index].picture,
            username: elements[index].username,
          ),
        ),
      ),
    );
  }
}

class EmptyLabel extends StatelessWidget {
  final String label;
  const EmptyLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          fontStyle: FontStyle.italic),
    );
  }
}
