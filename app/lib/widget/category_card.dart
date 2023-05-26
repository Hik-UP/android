import 'package:flutter/material.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/model/rando_category.dart';
import 'package:hikup/utils/dummy_data.dart';
import 'package:hikup/theme.dart';

typedef void IntCallback(String label);

class CategoryListView extends StatefulWidget {
  final List<TrailFields> trailsList;
  final IntCallback onTap;
  const CategoryListView(
      {required this.trailsList, required this.onTap, Key? key})
      : super(key: key);

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  List<TrailFields> _trailsList = [];

  @override
  void initState() {
    super.initState();
    _trailsList = widget.trailsList;
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryCard> categoryList = [];

    categoryList.add(CategoryCard(
      title: trailsLabels[0].title,
      imageAsset: trailsLabels[0].imageAsset,
      onTap: widget.onTap,
    ));
    for (int i = 0; i < _trailsList.length; i++) {
      for (int j = 0; j < _trailsList[i].labels.length; j++) {
        var labelInfos = trailsLabels.firstWhere(
            (card) => card.title == _trailsList[i].labels[j],
            orElse: () => RandoCategory(title: "", imageAsset: ""));
        var newLabel = CategoryCard(
          title: labelInfos.title,
          imageAsset: labelInfos.imageAsset,
          onTap: widget.onTap,
        );
        if (labelInfos.title.length > 0 &&
            categoryList.indexWhere(
                    (card) => card.title == _trailsList[i].labels[j]) <
                0) {
          categoryList.add(newLabel);
        }
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: categoryList,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final IntCallback onTap;

  const CategoryCard({
    required this.title,
    required this.imageAsset,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Material(
        color: BlackPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          //highlightColor: primaryColor500.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          //splashColor: primaryColor500.withOpacity(0.5),
          onTap: () => onTap(title),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    imageAsset,
                    //color: primaryColor500,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  title,
                  style: subTitleTextStyle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
