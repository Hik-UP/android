import 'package:flutter/material.dart';
import 'package:hikup/model/rando_field.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/screen/search_screen.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/dummy_data.dart';
import 'package:hikup/widget/category_card.dart';
import 'package:hikup/widget/header.dart';
import 'package:hikup/widget/rando_field_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RandoField> fieldList = recommendedSportField;
    AppState _appState = context.read<AppState>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Header(
            name:
                "${_appState.username[0].toUpperCase()}${_appState.username.substring(1)}",
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Text(
                    "Hik'Up!",
                    style: greetingTextStyle,
                  ),
                ),
                const CategoryListView(),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Les plus recommandé",
                        style: subTitleTextStyle,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const SearchScreen(
                                selectedDropdownItem: "Toutes",
                              );
                            }));
                          },
                          child: const Text("Tous voir"))
                    ],
                  ),
                ),
                // RECOMMENDED FIELDS
                Column(
                    children: fieldList
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
  }
}
