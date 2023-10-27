import 'package:flutter/material.dart';
import 'package:hikup/utils/dummy_data.dart';
import 'package:hikup/theme.dart';

class CategoryListView extends StatefulWidget {
  final List<String> labels;
  final Function(String label) onTap;
  const CategoryListView({
    required this.labels,
    required this.onTap,
    super.key,
  });

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    selectedValue = widget.labels[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: widget.labels
              .map<Widget>(
                (e) => CategoryCard(
                  isSelect: selectedValue == e,
                  title: e,
                  imageAsset: trailsLabels
                      .firstWhere((element) => element.title == e)
                      .imageAsset,
                  onTap: (String value) {
                    setState(() {
                      selectedValue = value;
                    });
                    widget.onTap(value);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final bool isSelect;
  final Function(String label) onTap;

  const CategoryCard({
    required this.title,
    required this.imageAsset,
    required this.onTap,
    this.isSelect = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Material(
        color: BlackPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelect
              ? const BorderSide(color: Colors.white)
              : BorderSide.none,
        ),
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
                    width: 30,
                    height: 30,
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
