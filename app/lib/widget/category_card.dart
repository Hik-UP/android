import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/dummy_data.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> categoryList = [];
    for (int i = 0; i < sportCategories.length; i++) {
      categoryList.add(CategoryCard(
          title: sportCategories[i].name,
          imageAsset: sportCategories[i].image));
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

  const CategoryCard({
    required this.title,
    required this.imageAsset,
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
          onTap: () {},
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
