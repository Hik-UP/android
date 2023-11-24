import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/Header/header.dart';
import 'package:hikup/widget/scaffold_with_custom_bg.dart';
import 'package:hikup/widget/trail_card.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/viewmodel/search_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String trailsFilter = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<SearchViewModel>(builder: (context, model, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (model.trailsList.isEmpty) {
          model.trails(appState: appState);
        }
      });

      return ScaffoldWithCustomBg(
          appBar: const Header(),
          child: Flex(direction: Axis.vertical, children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.93,
                    color: Colors.black,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: SearchBar(
                      backgroundColor: MaterialStateProperty.all(BlackPrimary),
                      hintText: "Rechercher un sentier",
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
                        (Set<MaterialState> states) {
                          return const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          );
                        },
                      ),
                      onChanged: (value) =>
                          model.searchFilterTrails(filter: value),
                      hintStyle: MaterialStateProperty.all(
                          const TextStyle(color: Colors.grey, fontSize: 14)),
                      textStyle: MaterialStateProperty.all(
                          const TextStyle(color: Colors.white, fontSize: 14)),
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      leading: const Icon(Icons.search, color: Colors.grey),
                    ))),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(5.0),
                    // RECOMMENDED FIELDS
                    model.filterTrailsList.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: model.filterTrailsList.length,
                            itemBuilder: (context, index) => TrailCard(
                              field: model.filterTrailsList[index],
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 200,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/cat-error.svg",
                                      height: 64,
                                      width: 64,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.grey, BlendMode.srcIn),
                                      semanticsLabel: 'error'),
                                  const Gap(20),
                                  Center(
                                    child: Text(
                                      "Aucun résultat",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ]),
                          ),
                    const Gap(80.0),
                  ],
                ),
              ),
            ),
          ]));
    });
  }
}
