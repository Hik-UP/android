import 'package:cached_network_image/cached_network_image.dart';
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
        background: CachedNetworkImage(
          imageUrl: field.pictures[0],
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(
            Icons.warning,
            color: GreenPrimary,
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: const BackIcon(),
      actions: [],
      expandedHeight: 300,
    );
  }
}
