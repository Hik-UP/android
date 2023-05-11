import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/widget/category_card.dart';
import 'package:hikup/widget/header.dart';
import 'package:hikup/widget/trail_card.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/viewmodel/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<SearchViewModel>(builder: (context, model, child) {
      return Scaffold(
        backgroundColor: BlackSecondary,
        appBar: const Header(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(8.0),
              Text(
                  "Hik'Up!",
                  style: GreenTitleTextStyle,
              ),
              const CategoryListView(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommendation",
                      style: WhiteTitleTextStyle,
                      //style: subTitleTextStyle,
                    )
                  ],
                ),
              ),
              // RECOMMENDED FIELDS
              FutureBuilder<List<TrailFields>>(
                future: model.trails(appState: appState),
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    return Text(
                      AppMessages.anErrorOcur,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  if (snapshots.data != null && snapshots.data!.isNotEmpty) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshots.data!.length,
                      itemBuilder: (context, index) => TrailCard(
                        field: snapshots.data![index],
                      ),
                    );
                  }
                  if (snapshots.data != null && snapshots.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            AppMessages.unAvailableRecommendHike,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Gap(10.0),
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
