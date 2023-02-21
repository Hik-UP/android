import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/rando_field.dart';
import '../screen/detail/detail_screen.dart';
import '../theme.dart';

class RandoFieldCard extends StatelessWidget {
  final RandoField field;

  const RandoFieldCard({required this.field, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 16, left: 16, top: 4.0, bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailScreen(
              field: field,
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: colorWhite,
              boxShadow: [
                BoxShadow(
                  color: primaryColor500.withOpacity(0.1),
                  blurRadius: 20,
                )
              ]),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(borderRadiusSize)),
                child: CachedNetworkImage(
                  imageUrl: field.pictures[0],
                  errorWidget: (context, url, error) => const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      field.name,
                      maxLines: 2,
                      style: subTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/pin.png",
                          width: 20,
                          height: 20,
                          color: primaryColor500,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        /*Flexible(
                          child: Text(
                            field.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: addressTextStyle,
                          ),
                        ),*/
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
