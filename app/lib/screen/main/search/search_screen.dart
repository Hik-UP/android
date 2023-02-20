import 'package:flutter/material.dart';
import 'package:hikup/model/rando_field.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/dummy_data.dart';
import 'package:hikup/widget/category_card.dart';
import 'package:hikup/widget/header.dart';
import 'package:hikup/widget/rando_field_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    List<RandoField> fieldList = recommendedSportField;

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
                      )
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
