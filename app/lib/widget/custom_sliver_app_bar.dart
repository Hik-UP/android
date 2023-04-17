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
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: BlackPrimary,
        statusBarIconBrightness: Brightness.light,
      ),
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
            child: Text(
              field.name,
              style: WhiteTitleTextStyle,
              overflow: TextOverflow.ellipsis,
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
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: BlackPrimary,
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton(
              tooltip: "Image's Author Url",
              padding: EdgeInsets.zero,
              icon: const Icon(
                CupertinoIcons.info,
                color: GreenPrimary,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  enabled: false,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: HOPA,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "",
                      style: HOPASTYLE,
                    ),
                  ),
                ),
                PopupMenuItem(
                    //onTap: () => launch(field.authorUrl),
                    child: ListTile(
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(
                    "",
                    style: HOPASTYLE,
                  ),
                )),
                PopupMenuItem(
                    //onTap: () => launch(field.imageUrl),
                    child: ListTile(
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  //leading: const Icon(Icons.image_outlined),
                  title: Text(
                    "",
                    style: HOPASTYLE,
                  ),
                )),
              ],
            ),
          ),
        )
      ],
      expandedHeight: 300,
    );
  }
}
