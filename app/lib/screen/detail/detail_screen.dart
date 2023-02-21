import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikup/model/rando_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/widget/back_icon.dart';

class DetailScreen extends StatelessWidget {
  final RandoField field;

  const DetailScreen({required this.field, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          customSliverAppBar(context, field),
          SliverPadding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/pin.png",
                      width: 24,
                      height: 24,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    /*Flexible(
                      child: Text(
                        field.address,
                        overflow: TextOverflow.visible,
                        style: addressTextStyle,
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      color: primaryColor500,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Details:",
                  style: subTitleTextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.hiking_rounded,
                      color: primaryColor500,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.escalator,
                      color: primaryColor500,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Duration:",
                      style: subTitleTextStyle,
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text("See Availability"))
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: primaryColor500,
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "${field.duration}",
                      style: descTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Tools:",
                  style: subTitleTextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                //FacilityCardList(facilities: field.tools),
              ]),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: lightBlue300,
            offset: Offset(0, 0),
            blurRadius: 10,
          ),
        ]),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadiusSize))),
            onPressed: () {
              print("CHECKOUT");
              /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CheckoutScreen(
                  field: field,
                );
              }));*/
            },
            child: const Text("Réserver maintenant")),
      ),
    );
  }

  Widget customSliverAppBar(context, field) {
    return SliverAppBar(
      shadowColor: primaryColor500.withOpacity(.2),
      backgroundColor: colorWhite,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.4),
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
              color: colorWhite,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadiusSize))),
          child: Center(
            child: Text(
              field.name,
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        background: CachedNetworkImage(
          imageUrl: field.pictures[0],
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(
            Icons.warning,
            color: Colors.red,
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
              color: colorWhite,
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton(
              tooltip: "Image's Author Url",
              padding: EdgeInsets.zero,
              icon: const Icon(CupertinoIcons.info, color: darkBlue500),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                    enabled: false,
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: lightBlue100,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "",
                          style: subTitleTextStyle,
                        ))),
                PopupMenuItem(
                    //onTap: () => launch(field.authorUrl),
                    child: ListTile(
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(
                    "",
                    style: normalTextStyle,
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
                    style: normalTextStyle,
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
