import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hikup/model/detail_trail_model.dart";
import "package:hikup/providers/app_state.dart";
import "package:hikup/theme.dart";
import "package:hikup/utils/app_messages.dart";
import "package:hikup/utils/wrapper_api.dart";
import "package:hikup/widget/show_burn_calories.dart";
import "package:provider/provider.dart";

class DisplayDetailTrails extends StatelessWidget {
  final String trailId;
  final int duration;
  final List<String> tools;

  const DisplayDetailTrails({
    Key? key,
    required this.trailId,
    required this.duration,
    required this.tools,
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
                          Navigator.of(context).pushNamed("/community");
                        },
                        child: const Icon(
                          Icons.add_box,
                          color: GreenPrimary,
                          size: 24.0,
                        ),
                      ),
                      const Gap(16.0),
                      Text(
                        "Users comments",
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
                        "${putZero(value: data.temperature)} deg",
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
          children: const [
            Icon(
              Icons.escalator,
              color: GreenPrimary,
            ),
            SizedBox(
              width: 16.0,
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
          height: 4,
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
              "$duration",
              style: WhiteAddressTextStyle,
            ),
          ],
        ),
        const Gap(10.0),
        Text(
          "Équipements",
          style: subTitleTextStyle,
        ),
        const Gap(4.0),
        WrapperApi().showTools(
          toolsBack: tools,
        ),
      ],
    );
  }
}
