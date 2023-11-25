import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/screen/detail/detail_screen.dart';
import 'package:hikup/screen/main/mapbox/Components/map.dart';
import 'package:hikup/widget/Header/header.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/viewmodel/map_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hikup/widget/display_detail_trails.dart';
import 'package:gap/gap.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hikup/screen/main/hike/detail_hike_invite.dart';
import 'package:hikup/widget/custom_btn.dart';

class MapBoxScreen extends StatefulWidget {
  const MapBoxScreen({
    super.key,
  });

  @override
  State<MapBoxScreen> createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> with RouteAware {
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
      Color trailColor = model.trailsList.isEmpty
          ? Colors.transparent
          : model.trailsList[0].difficulty == 1
              ? const Color.fromRGBO(87, 252, 255, 0.8)
              : model.trailsList[0].difficulty == 2
                  ? const Color.fromRGBO(72, 255, 201, 0.8)
                  : model.trailsList[0].difficulty == 3
                      ? const Color.fromRGBO(194, 283, 255, 0.8)
                      : model.trailsList[0].difficulty == 4
                          ? const Color.fromRGBO(253, 210, 59, 0.8)
                          : model.trailsList[0].difficulty == 5
                              ? const Color.fromRGBO(87, 252, 255, 0.8)
                              : Colors.transparent;

      Future<void> _launchUrl(String url) async {
        if (!await launchUrl(Uri.parse(url))) {
          throw Exception('Could not launch URL');
        }
      }

      model.mapController.mapEventStream.listen((event) {
        if (model.polylines.isNotEmpty &&
            model.mapController.camera.zoom <= 12) {
          model.polylines.clear();
          setState(() {
            model.showPanel = false;
          });
        }
      });

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
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            MapBox(
              mapController: model.mapController,
              zoom: model.zoom,
              polylines: model.polylines,
              markers: model.markers,
              onPositionChange: (Position position) =>
                  {model.position = position},
            ),
            model.showPanel == true && model.trailsList.isNotEmpty
                ? Positioned(
                    top: 70,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () => {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DetailScreen(
                                        field: model.trailsList[0],
                                      );
                                    }))
                                  },
                              child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 5, 5),
                                  width: 310,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: trailColor, width: 2),
                                          top: BorderSide(
                                              color: trailColor, width: 2),
                                          right: BorderSide(
                                              color: trailColor, width: 2),
                                          bottom: BorderSide(
                                              color: trailColor, width: 6)),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(0),
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(0)),
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.2)),
                                  child: Row(children: [
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        width: 265,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.trailsList[0].name,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic,
                                                  height: 1.2),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                            ),
                                            const Gap(4),
                                            DisplayDetailTrails(
                                              fontSize: 10,
                                              trailId: model.trailsList[0].id,
                                              duration:
                                                  model.trailsList[0].duration,
                                              distance:
                                                  model.trailsList[0].distance,
                                              upHill:
                                                  model.trailsList[0].uphill,
                                              downHill:
                                                  model.trailsList[0].downhill,
                                              difficulty: model
                                                  .trailsList[0].difficulty,
                                            ),
                                          ],
                                        )),
                                    SvgPicture.asset(
                                        "assets/icons/details/left-arrow.svg",
                                        height: 25,
                                        width: 25,
                                        colorFilter: ColorFilter.mode(
                                            trailColor, BlendMode.srcIn),
                                        semanticsLabel: 'select')
                                  ]))),
                          const Gap(5.0),
                          RatingBarIndicator(
                            rating: model.trailsList[0].difficulty.toDouble(),
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
                        ]),
                  )
                : Container(),
            model.showPanel == true &&
                    model.trailsList.isNotEmpty &&
                    model.showJoin == true
                ? Positioned(
                    bottom: 80,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 310,
                            child: CustomBtn(
                              bgColor: trailColor.withOpacity(0.2),
                              borderColor: trailColor,
                              content: "Participer",
                              onPress: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailHikeInvite(hike: model.hike[0]),
                                ),
                              ),
                            ),
                          )
                        ]))
                : Container()
          ],
        ),
      );
    });
  }
}
