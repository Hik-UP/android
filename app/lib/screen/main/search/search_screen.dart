import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/Header/header.dart';
import 'package:hikup/widget/trail_card.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/viewmodel/search_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:hikup/widget/category_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
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
      if (model.trailsList.isEmpty) {
        model.trails(appState: appState);
      }

      model.genTrailLabel();

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
              CategoryListView(
                labels: model.genTrailLabel(),
                onTap: (String label) {
                  print(label);
                  if (label == "Tout") {
                    model.filterTrails(filter: "");
                  } else {
                    model.filterTrails(filter: label);
                  }
                },
              ),
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
                      "Recommandation",
                      style: WhiteTitleTextStyle,
                      //style: subTitleTextStyle,
                    )
                  ],
                ),
              ),
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
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gap(10.0),
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
              const Gap(80.0),
            ],
          ),
        ),
      );
    });
  }
}
