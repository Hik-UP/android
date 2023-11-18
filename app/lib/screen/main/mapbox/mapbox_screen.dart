import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/screen/detail/detail_screen.dart';
import 'package:hikup/screen/main/mapbox/Components/map.dart';
import 'package:hikup/widget/header.dart';
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
    Key? key,
  }) : super(key: key);

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

      String durationToString(int minutes) {
        var d = Duration(minutes: minutes);
        List<String> parts = d.toString().split(':');
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
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
            ),
            model.showPanel == true && model.trailsList.isNotEmpty
                ? Positioned(
                    top: 70,
                    child: InkWell(
                        onTap: () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailScreen(
                                  field: model.trailsList[0],
                                );
                              }))
                            },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                            width: 310,
                            decoration: BoxDecoration(
                                border: Border(
                                    left:
                                        BorderSide(color: trailColor, width: 2),
                                    top:
                                        BorderSide(color: trailColor, width: 2),
                                    right:
                                        BorderSide(color: trailColor, width: 2),
                                    bottom: BorderSide(
                                        color: trailColor, width: 6)),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(0),
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(0)),
                                color: const Color.fromRGBO(0, 0, 0, 0.2)),
                            child: Row(children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  width: 265,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.trailsList[0].name,
                                        style: subTitleTextStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/details/clock.svg",
                                              height: 10,
                                              width: 10,
                                              colorFilter: ColorFilter.mode(
                                                  trailColor, BlendMode.srcIn),
                                              semanticsLabel: 'duration'),
                                          const Gap(2),
                                          Text(
                                              "${durationToString(model.trailsList[0].duration)} h",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: trailColor)),
                                          const Gap(10),
                                          SvgPicture.asset(
                                              "assets/icons/details/shoe.svg",
                                              height: 11,
                                              width: 11,
                                              colorFilter: ColorFilter.mode(
                                                  trailColor, BlendMode.srcIn),
                                              semanticsLabel: 'distance'),
                                          const Gap(2),
                                          Text(
                                              "${model.trailsList[0].distance / 1000} km",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: trailColor)),
                                          const Gap(10),
                                          SvgPicture.asset(
                                              "assets/icons/details/down-arrow.svg",
                                              height: 8,
                                              width: 8,
                                              colorFilter: ColorFilter.mode(
                                                  trailColor, BlendMode.srcIn),
                                              semanticsLabel: 'downhill'),
                                          const Gap(2),
                                          Text(
                                              "${model.trailsList[0].downhill} m",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: trailColor)),
                                          const Gap(10),
                                          SvgPicture.asset(
                                              "assets/icons/details/up-arrow.svg",
                                              height: 8,
                                              width: 8,
                                              colorFilter: ColorFilter.mode(
                                                  trailColor, BlendMode.srcIn),
                                              semanticsLabel: 'uphill'),
                                          const Gap(2),
                                          Text(
                                              "${model.trailsList[0].uphill} m",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: trailColor))
                                        ],
                                      )
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
                  )
                : Container()
          ],
        ),
      );
    });
  }
}
