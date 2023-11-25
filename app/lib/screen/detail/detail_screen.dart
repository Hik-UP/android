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

class DetailScreen extends StatelessWidget {
  final TrailFields field;
  const DetailScreen({required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<DetailScreenViewModel>(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(field: field),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CustomBtn(
                      content: "Planifier",
                      onPress: () => print("ok"),
                    ),
                    const Gap(16),
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
      ),
    );
  }
}
