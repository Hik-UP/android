import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/back_icon.dart';

class CustomSliverAppBar extends StatelessWidget {
  final TrailFields field;
  const CustomSliverAppBar({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: BlackSecondary,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight,
          decoration: const BoxDecoration(
              color: BlackPrimary,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadiusSize))),
          child: Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(50.0, 4.0, 50.0, 4.0),
              child: Text(
                field.name,
                maxLines: 2,
                style: subTitleTextStyle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        background: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            height: MediaQuery.of(context).size.height
          ),
          items: field.pictures.map((picture) {
            return CachedNetworkImage(
              fit: BoxFit.cover, width: 1000.0,
              imageUrl: picture,
              errorWidget: (context, url, error) => const Icon(
                Icons.warning,
                color: HOPA,
              ),
            );
          }).toList(),
        ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: const BackIcon(),
      actions: [],
      expandedHeight: 300,
    );
  }
}
