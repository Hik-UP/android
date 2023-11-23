import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/model/hike.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/main/hike/detail_hike_invite.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/viewmodel/hike_card_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hikup/widget/display_detail_trails.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HikeCard extends StatelessWidget {
  final Hike hike;
  final bool guest;
  final Function() update;
  const HikeCard({
    super.key,
    required this.hike,
    required this.guest,
    required this.update,
  });

  String formatDate() {
    var replaceDate = hike.schedule.replaceAll(RegExp(r'T'), ' ');
    var splitDate = replaceDate.split(' ');

    return "${splitDate[0]} ${splitDate[1].split(':').sublist(0, 2).join(':')}";
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    Color trailColor = hike.trail.difficulty == 1
        ? const Color.fromRGBO(87, 252, 255, 0.8)
        : hike.trail.difficulty == 2
            ? const Color.fromRGBO(72, 255, 201, 0.8)
            : hike.trail.difficulty == 3
                ? const Color.fromRGBO(194, 283, 255, 0.8)
                : hike.trail.difficulty == 4
                    ? const Color.fromRGBO(253, 210, 59, 0.8)
                    : hike.trail.difficulty == 5
                        ? const Color.fromRGBO(87, 252, 255, 0.8)
                        : Colors.transparent;

    return BaseView<HikeCardViewModel>(
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailHikeInvite(
                hike: hike,
              ),
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: trailColor.withAlpha(60),
              border: Border(
                  left: BorderSide(color: trailColor, width: 2),
                  top: BorderSide(color: trailColor, width: 2),
                  right: BorderSide(color: trailColor, width: 2),
                  bottom: BorderSide(color: trailColor, width: 2)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(color: trailColor, width: 0),
                              top: BorderSide(color: trailColor, width: 0),
                              right: BorderSide(color: trailColor, width: 0),
                              bottom: BorderSide(color: trailColor, width: 4))),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 1000.0,
                        imageUrl: hike.trail.pictures[0],
                        errorWidget: (context, url, error) => const Icon(
                          Icons.warning,
                          color: HOPA,
                        ),
                      )),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hike.trail.name,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                        const Gap(5),
                        DisplayDetailTrails(
                          fontSize: 12,
                          trailId: hike.trail.id,
                          duration: hike.trail.duration,
                          distance: hike.trail.distance,
                          upHill: hike.trail.uphill,
                          downHill: hike.trail.downhill,
                          difficulty: hike.trail.difficulty,
                        ),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(
                            formatDate(),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                          const Gap(10),
                          SvgPicture.asset("assets/icons/details/smile.svg",
                              height: 16,
                              width: 16,
                              colorFilter:
                                  ColorFilter.mode(trailColor, BlendMode.srcIn),
                              semanticsLabel: 'attendent'),
                          const Gap(1),
                          Text(
                            hike.attendee.length.toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                          const Gap(5),
                          SvgPicture.asset("assets/icons/details/lightning.svg",
                              height: 16,
                              width: 16,
                              colorFilter: const ColorFilter.mode(
                                  Colors.amber, BlendMode.srcIn),
                              semanticsLabel: 'difficulty'),
                          const Gap(1),
                          Text(
                            hike.trail.difficulty.toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                        ]),
                        guest == false
                            ? model.labelStatus(
                                status: hike.status, bgColor: trailColor)
                            : Container(),
                      ]),
                ),
                guest == true
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => {
                                  model.acceptOrRefuse(
                                    routeName: acceptInvitePath,
                                    hikeId: hike.id,
                                    appState: appState,
                                    load: () => model.setAcceptLoader(true),
                                    stop: () {
                                      model.setAcceptLoader(false);
                                      update();
                                    },
                                  )
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 20),
                                    backgroundColor:
                                        const Color.fromRGBO(12, 60, 40, 1),
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: Color.fromRGBO(21, 255, 120, 1),
                                    )),
                                child: model.acceptLoader
                                    ? const SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text(
                                        "Accepter",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const Gap(5),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  model.acceptOrRefuse(
                                    routeName: declineInvitePath,
                                    hikeId: hike.id,
                                    appState: appState,
                                    load: () => model.setDeclineLoader(true),
                                    stop: () {
                                      model.setDeclineLoader(false);
                                      update();
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 20),
                                    backgroundColor:
                                        const Color.fromRGBO(132, 16, 42, 1),
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: Color.fromRGBO(255, 21, 63, 1),
                                    )),
                                child: model.declineLoader
                                    ? const SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text(
                                        "Refuser",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ))
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
