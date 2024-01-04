import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/detail_screen_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/custom_sliver_app_bar.dart';
import 'package:hikup/widget/display_detail_trails.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hikup/widget/custom_btn.dart';
import 'package:hikup/widget/invite_friend_cmp.dart';
import 'package:hikup/widget/plan_component.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final TrailFields field;
  const DetailScreen({required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();
    bool hikeLoading = false;

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

    Future<void> openURL(String url) async {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch URL');
      }
    }

    return BaseView<DetailScreenViewModel>(
      builder: (context, model, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                field: field,
              ),
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
                        field.description.toString(),
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
                        rating: field.difficulty.toDouble(),
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
                        toolsBack: field.tools,
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
                        trailId: field.id,
                        duration: field.duration,
                        distance: field.distance,
                        upHill: field.uphill,
                        downHill: field.downhill,
                        difficulty: field.difficulty,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
              height: 75,
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
                  child: CustomBtn(
                    content: "Planifier",
                    onPress: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              scrollable: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 10),
                              backgroundColor: Colors.black.withOpacity(0.9),
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              title: Text('Nouvelle randonnée',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic)),
                              content: StatefulBuilder(
                                  // You need this, notice the parameters below:
                                  builder: (BuildContext context,
                                          StateSetter setState) =>
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Invité(s)",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                            const Gap(5),
                                            InviteFriendCmp(
                                              guestList: model.emailFriends,
                                              onGuestRemove: (index) =>
                                                  setState(() => model
                                                          .removeInEmailFriends(
                                                        value:
                                                            model.emailFriends[
                                                                index],
                                                      )),
                                              value: (data) => setState(
                                                () => model.pushInEmailFirends(
                                                  value: data,
                                                ),
                                              ),
                                            ),
                                            const Gap(15.0),
                                            Text("Date",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                            const Gap(5),
                                            PlanComponent(
                                              dateCtrl: model.dateCtrl,
                                              timeCtrl: model.timeCtrl,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    model.dateCtrl.text = "";
                                                    model.timeCtrl.text = "";
                                                  },
                                                  child: const Text(
                                                    "Réinitialiser",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Gap(15),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: CustomBtn(
                                                        content: "Commencer",
                                                        isLoading: hikeLoading,
                                                        onPress: () {
                                                          model.createAHike(
                                                              appState:
                                                                  appState,
                                                              trailField: field,
                                                              timeStamps: model
                                                                          .dateCtrl
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      model
                                                                          .timeCtrl
                                                                          .text
                                                                          .isNotEmpty
                                                                  ? model
                                                                      .timeStampOrNull()
                                                                  : null,
                                                              guests: model
                                                                  .emailFriends,
                                                              onLoad: () {
                                                                setState(() =>
                                                                    hikeLoading =
                                                                        false);
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel');
                                                              });
                                                          setState(() =>
                                                              hikeLoading =
                                                                  true);
                                                        })),
                                                const Gap(5),
                                                Expanded(
                                                    child: CustomBtn(
                                                  content: "Annuler",
                                                  bgColor: const Color.fromRGBO(
                                                      132, 16, 42, 1),
                                                  borderColor:
                                                      const Color.fromRGBO(
                                                          255, 21, 63, 1),
                                                  onPress: () => Navigator.pop(
                                                      context, 'OK'),
                                                ))
                                              ],
                                            ),
                                          ])),
                            )),
                  ),
                ),
                const Gap(5.0),
                Expanded(
                  child: CustomBtn(
                      content: "Direction",
                      bgColor: trailColor.withOpacity(0.2),
                      borderColor: trailColor,
                      onPress: () => openURL(
                          "https://maps.google.com/?q=${field.latitude},${field.longitude}")),
                ),
              ]))),
    );
  }
}
