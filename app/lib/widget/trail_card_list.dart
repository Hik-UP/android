import 'package:flutter/material.dart';
import 'package:hikup/model/trail_fields.dart';
import 'package:hikup/screen/detail/detail_screen.dart';
import 'package:hikup/theme.dart';

class TrailCardList extends StatelessWidget {
  final TrailFields field;

  const TrailCardList({required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16.0),
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
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: HOPA,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadiusSize),
                child: Image.asset(field.imageAsset,
                    height: 65, width: 100, fit: BoxFit.cover),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      maxLines: 1,
                      style: subTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/pin.png",
                          width: 20,
                          height: 20,
                          color: HOPA,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Flexible(
                          child: Text(
                            field.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HOPASTYLE,
                          ),
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
