import 'package:flutter/material.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/category_card.dart';
import 'package:hikup/widget/header.dart';
import 'package:hikup/widget/rando_field_card.dart';
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
    return BaseView<SearchViewModel>(builder: (context, model, child) {
      if (model.loading) {
        model.trails(
          appState: context.read<AppState>(),
          updateScreen: () => setState(
            () {},
          ),
        );
      }

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: const Header(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0),
                    child: Text(
                      "Hik'Up!",
                      style: greetingTextStyle,
                    ),
                  ),
                  const CategoryListView(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Les plus recommandé",
                          style: subTitleTextStyle,
                        )
                      ],
                    ),
                  ),
                  // RECOMMENDED FIELDS
                  Column(
                      children: model.trailsList
                          .map((fieldEntity) => RandoFieldCard(
                                field: fieldEntity,
                              ))
                          .toList()),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
