import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../model/trail_fields.dart';
import '../screen/detail/detail_screen.dart';
import '../theme.dart';

class TrailCard extends StatelessWidget {
  final TrailFields field;

  const TrailCard({required this.field, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 16, left: 16, top: 8.0, bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailScreen(
              field: field,
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.white.withOpacity(0.4), width: 1),
                      ),
                    ),
                    child: CarouselSlider(
                      options:
                          CarouselOptions(autoPlay: false, viewportFraction: 1),
                      items: field.pictures.map((picture) {
                        return CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: 1000.0,
                          imageUrl: picture,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.warning,
                            color: HOPA,
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              Container(
                padding: const EdgeInsets.only(
                    right: 15, left: 15, top: 10.0, bottom: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      field.name,
                      maxLines: 2,
                      style: subTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/icons/pin.png",
                          width: 16,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Flexible(
                          child: Text(
                            field.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GreenAddressTextStyle,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Difficulty ${field.difficulty}/5",
                          style: GreenAddressTextStyle,
                        ),
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
