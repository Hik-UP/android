import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/guest.dart";
import "package:hikup/model/hike.dart";
import "package:hikup/model/trail_fields.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/utils/constant.dart";
import "package:hikup/viewmodel/detail_hike_invite.dart";
import "package:hikup/widget/base_view.dart";
import "package:hikup/widget/display_detail_trails.dart";
import "package:hikup/widget/guest_cmp.dart";
import "package:provider/provider.dart";
import 'package:hikup/screen/navigation/navigation_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikup/widget/custom_sliver_app_bar.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hikup/widget/custom_btn.dart';

class DetailHikeInvite extends StatefulWidget {
  static String routeName = "/detail-hike-invite";
  final Hike hike;
  const DetailHikeInvite({super.key, required this.hike});

  @override
  State<DetailHikeInvite> createState() => _DetailHikeInviteState();
}

class _DetailHikeInviteState extends State<DetailHikeInvite> {
  @override
  Widget build(BuildContext context) {
    final hike = widget.hike;
    AppState appState = context.read<AppState>();
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
    bool isLeaved = hike.attendee
        .where(((element) => element.username == appState.username))
        .isEmpty;

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
            child: isLeaved == false
                ? Row(children: [
                    Expanded(
                      child: CustomBtn(
                        isLoading: model.getState == ViewState.join,
                        content: "Rejoindre",
                        onPress: () => model.joinHike(
                            appState: appState,
                            hike: hike,
                            onComplete: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NavigationScreen(
                                    hike: hike,
                                    stats: model.stats,
                                    hikers: model.hikers),
                              ));
                            }),
                      ),
                    ),
                    const Gap(5.0),
                    Expanded(
                      child: CustomBtn(
                        isLoading: model.getState == ViewState.deletion,
                        content: "Quitter",
                        onPress: () {
                          if (hike.organizers.username == appState.username) {
                            model.leaveHike(
                                hikeId: hike.id,
                                appState: appState,
                                isOrganizer: true);
                          } else {
                            model.leaveHike(
                                hikeId: hike.id,
                                appState: appState,
                                isOrganizer: false);
                          }
                        },
                        borderColor: const Color.fromRGBO(255, 21, 63, 1),
                        bgColor: const Color.fromRGBO(132, 16, 42, 1),
                      ),
                    ),
                  ])
                : Row(children: [
                    Expanded(
                      child: CustomBtn(
                        isLoading: model.getState == ViewState.busy,
                        content: "Supprimer",
                        onPress: () {
                          if (hike.organizers.username == appState.username) {
                            model.removeHike(
                                hikeId: hike.id,
                                appState: appState,
                                isOrganizer: true);
                          } else {
                            model.removeHike(
                                hikeId: hike.id,
                                appState: appState,
                                isOrganizer: false);
                          }
                        },
                        borderColor: const Color.fromRGBO(255, 21, 63, 1),
                        bgColor: const Color.fromRGBO(132, 16, 42, 1),
                      ),
                    ),
                  ])),
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
