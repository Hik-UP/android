import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/trail_fields.dart';
import '../screen/detail/detail_screen.dart';
import '../theme.dart';

class TrailCard extends StatelessWidget {
  final TrailFields field;

  const TrailCard({required this.field, super.key});

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
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.white.withOpacity(0.4), width: 1),
                      ),
                    ),
                    child: field.pictures.length > 1
                        ? CarouselSlider(
                            options: CarouselOptions(
                                autoPlay: false, viewportFraction: 1),
                            items: field.pictures.map((picture) {
                              return Image.asset(
                                'trails/$picture',
                                fit: BoxFit.cover,
                                width: 1000.0,
                                errorBuilder: (context, url, error) =>
                                    const Icon(
                                  Icons.warning,
                                  color: HOPA,
                                ),
                              );
                            }).toList(),
                          )
                        : Image.asset(
                            'trails/${field.pictures[0]}',
                            fit: BoxFit.cover,
                            width: 1000.0,
                            errorBuilder: (context, url, error) => const Icon(
                              Icons.warning,
                              color: HOPA,
                            ),
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
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          height: 1.2),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/pin.png",
                              width: 12,
                              height: 12,
                              color: Colors.white,
                            ),
                            const Gap(3),
                            Text(
                              field.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RatingBarIndicator(
                                rating: 1,
                                itemBuilder: (context, index) =>
                                    SvgPicture.asset(
                                        "assets/icons/details/lightning.svg",
                                        colorFilter: const ColorFilter.mode(
                                            Colors.amber, BlendMode.srcIn),
                                        semanticsLabel: 'difficulty'),
                                itemCount: 1,
                                itemSize: 18,
                                unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                              ),
                              const Gap(2),
                              Text(
                                "${field.difficulty}",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ]),
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
