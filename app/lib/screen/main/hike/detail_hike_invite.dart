import "package:flutter/material.dart";
import 'dart:convert';
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/guest.dart";
import "package:hikup/model/hike.dart";
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

class DetailHikeInvite extends StatelessWidget {
  final Hike hike;
  static String routeName = "/detail-hike-invite";
  const DetailHikeInvite({
    Key? key,
    required this.hike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigator = locator<CustomNavigationService>();
    double maxHeight = MediaQuery.of(context).size.height;
    AppState appState = context.read<AppState>();
    final Marker marker = Marker(
      width: 50.0,
      height: 50.0,
      point: LatLng(hike.trail.latitude, hike.trail.longitude),
      child: const Icon(
        Icons.fiber_manual_record_rounded,
        color: Colors.blue,
        size: 24.0,
      ),
    );
    final Polyline polyline = Polyline(
      points: json
          .decode(hike.trail.geoJSON)["features"][0]["geometry"]["coordinates"]
          .map<LatLng>((entry) => LatLng(entry[1], entry[0]))
          .toList(),
      color: Colors.red,
      strokeWidth: 3.0,
      borderColor: const Color(0xFF1967D2),
      borderStrokeWidth: 0.1,
    );
    bool joinInProgress = false;

    String durationToString(int minutes) {
      var d = Duration(minutes: minutes);
      List<String> parts = d.toString().split(':');
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }

    Marker(
      width: 50.0,
      height: 50.0,
      point: LatLng(hike.trail.latitude, hike.trail.longitude),
      child: const Icon(
        Icons.fiber_manual_record_rounded,
        color: Colors.blue,
        size: 24.0,
      ),
    );

    return BaseView<DetailHikeInviteViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.green,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      width: double.infinity,
                      height: maxHeight * .4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: MapBox(
                        interactiveFlags: InteractiveFlag.none,
                        enableScrollWheel: false,
                        zoom: 13,
                        center:
                            LatLng(hike.trail.latitude, hike.trail.longitude),
                        showSkin: false,
                        polylines: [polyline],
                        markers: [marker],
                      )),
                  // Positioned(
                  //   bottom: 10,
                  //   right: 20,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8.0),
                  //     decoration: BoxDecoration(
                  //       gradient: loginButtonColor,
                  //       borderRadius: BorderRadius.circular(30.0),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         const Icon(
                  //           FontAwesomeIcons.locationArrow,
                  //           color: Colors.white,
                  //         ),
                  //         const Gap(8.0),
                  //         Text(
                  //           AppMessages.seeAll,
                  //           style: GoogleFonts.poppins(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 14.0,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
              const Gap(20.0),
              DisplayAddress(address: hike.address),
              const Gap(16.0),
              Row(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: hike.trail.labels
                        .map(
                          (label) => Container(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4.0),
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
              const Gap(10.0),
              Text(
                "Détails",
                style: subTitleTextStyle,
              ),
              const Gap(10.0),
              DisplayDetailTrails(
                trailId: hike.trail.id,
                duration: durationToString(hike.trail.duration),
                upHill: "${hike.trail.uphill} m",
                downHill: "${hike.trail.downhill} m",
                tools: hike.trail.tools,
                difficulty: hike.trail.difficulty.toString(),
                articles: hike.trail.relatedArticles,
              ),
              const Gap(10.0),
              Text(
                AppMessages.guest,
                style: subTitleTextStyle,
              ),
              const Gap(4.0),
              hike.guests.isNotEmpty
                  ? ListOfGuestOrAttendee(
                      elements: hike.guests,
                    )
                  : EmptyLabel(
                      label: AppMessages.noGuest,
                    ),
              const Gap(10.0),
              Text(
                AppMessages.attended,
                style: subTitleTextStyle,
              ),
              const Gap(4.0),
              hike.attendee.isNotEmpty
                  ? ListOfGuestOrAttendee(
                      elements: hike.attendee,
                    )
                  : EmptyLabel(
                      label: AppMessages.noAttended,
                    ),
              const Gap(30.0),
              Visibility(
                visible: hike.attendee
                        .map((e) => e.username)
                        .toList()
                        .contains(appState.username) &&
                    hike.status != "DONE",
                child: CustomBtn(
                    isLoading: model.loadingDelete,
                    bgColor: Colors.green,
                    textColor: Colors.white,
                    content: "Rejoindre",
                    onPress: () async {
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
                    }),
              ),
              const Gap(30.0),
              Visibility(
                visible: hike.attendee
                        .map((e) => e.username)
                        .toList()
                        .contains(appState.username) &&
                    hike.status != "DONE",
                child: CustomBtn(
                  isLoading: model.loadingDelete,
                  bgColor: Colors.red,
                  textColor: Colors.white,
                  content: appState.username == hike.organizers.username
                      ? AppMessages.finish
                      : AppMessages.quit,
                  onPress: () {
                    if (appState.username == hike.organizers.username) {
                      model.finishByOrganizer(
                        hikeId: hike.id,
                        appState: appState,
                      );
                    } else {
                      model.leaveHike(
                        hikeId: hike.id,
                        appState: appState,
                      );
                    }
                  },
                ),
              ),
              const Gap(30.0),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfGuestOrAttendee extends StatelessWidget {
  final List<Guest> elements;
  const ListOfGuestOrAttendee({
    Key? key,
    required this.elements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
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
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        color: Colors.grey,
        fontSize: 12.0,
      ),
    );
  }
}
