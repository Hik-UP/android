import "package:any_link_preview/any_link_preview.dart";
import "package:flutter/material.dart";
import 'dart:math' as math;
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/detail_trail_model.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/screen/main/community/comments/home.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/utils/wrapper_api.dart";
import "package:hikup/widget/show_burn_calories.dart";
import "package:provider/provider.dart";

class DisplayDetailTrails extends StatelessWidget {
  final String trailId;
  final String duration;
  final String upHill;
  final String downHill;
  final List<String> tools;
  final String difficulty;
  final List<String> labels;
  final List<String> articles;

  const DisplayDetailTrails({
    Key? key,
    required this.trailId,
    required this.duration,
    required this.upHill,
    required this.downHill,
    required this.tools,
    required this.difficulty,
    required this.labels,
    required this.articles,
  }) : super(key: key);

  String putZero({required int value}) {
    return value >= 0 && value <= 9 ? "0$value" : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<DetailTrailMode>(
          future: WrapperApi().getDetailsTrails(
            appState: context.read<AppState>(),
            trailId: trailId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  AppMessages.anErrorOcur,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 10.0,
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              // boxtrailId.put("trailId", field.id);
              var data = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommunityView(
                                trailId: trailId,
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.add_box,
                          color: GreenPrimary,
                          size: 24.0,
                        ),
                      ),
                      const Gap(16.0),
                      Text(
                        "Avis",
                        style: WhiteAddressTextStyle,
                      ),
                      const Gap(16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: GreenPrimary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Image.network(
                          data!.iconTemp,
                          height: 24.0,
                        ),
                      ),
                      const Gap(16.0),
                      Text(
                        "${putZero(value: data.temperature)} °C",
                        style: WhiteAddressTextStyle,
                      ),
                    ],
                  ),
                  const Gap(16.0),
                  ShowBurnCalories(calories: data.calories),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.escalator,
              color: GreenPrimary,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              upHill,
              style: WhiteAddressTextStyle,
            ),
            const Gap(16.0),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: const Icon(
                Icons.escalator,
                color: GreenPrimary,
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              downHill,
              style: WhiteAddressTextStyle,
            ),
          ],
        ),
        const Gap(10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Durée",
              style: subTitleTextStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: GreenPrimary,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              duration,
              style: WhiteAddressTextStyle,
            ),
          ],
        ),
        const Gap(10.0),
        Text(
          "Équipements",
          style: subTitleTextStyle,
        ),
        const Gap(8.0),
        WrapperApi().showTools(
          toolsBack: tools,
        ),
        Text(
          "Difficulté",
          style: subTitleTextStyle,
        ),
        const Gap(8.0),
        Row(
          children: [
            const Icon(
              Icons.emoji_events,
              color: GreenPrimary,
              size: 24.0,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              "$difficulty +  / 5",
              textAlign: TextAlign.justify,
              style: WhiteAddressTextStyle,
            ),
          ],
        ),
        const Gap(10.0),
        Text(
          "Label",
          style: subTitleTextStyle,
        ),
        const Gap(8.0),
        WrapperApi().showTools(
          toolsBack: labels,
        ),
        const Gap(10.0),
        Text(
          "Articles",
          style: subTitleTextStyle,
        ),
        const Gap(8.0),
        SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: articles.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AnyLinkPreview(
                link: articles[index],
                displayDirection: UIDirection.uiDirectionVertical,
                showMultimedia: true,
                bodyMaxLines: 5,
                bodyTextOverflow: TextOverflow.ellipsis,
                titleStyle: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                bodyStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                errorBody: 'Show my custom error body',
                errorTitle: 'Show my custom error title',
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: const Text('Oops!'),
                ),
                errorImage: "https://google.com/",
                cache: const Duration(days: 7),
                backgroundColor: Colors.grey[300],
                borderRadius: 12,
                removeElevation: false,
                boxShadow: const [
                  BoxShadow(blurRadius: 3, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        const Gap(10.0),
      ],
    );
  }
}
