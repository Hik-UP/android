import 'package:flutter/material.dart';
import 'package:hikup/model/field_facility.dart';

import '../theme.dart';

class FacilityCardList extends StatelessWidget {
  final List<FieldFacility> facilities;

  const FacilityCardList({
    required this.facilities,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      physics: const ClampingScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: EdgeInsets.zero,
      childAspectRatio: (1 / 1),
      shrinkWrap: true,
      children: facilities.map((facility) {
        return FacilityCard(
            name: facility.name, imageIcon: facility.imageAsset);
      }).toList(),
    );
  }
}

class FacilityCard extends StatefulWidget {
  final String imageIcon;
  final String name;

  const FacilityCard({
    required this.imageIcon,
    required this.name,
    super.key,
  });

  @override
  State<FacilityCard> createState() => _FacilityCardState();
}

class _FacilityCardState extends State<FacilityCard> {
  bool showName = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HOPA,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: HOPA,
        onTap: () {
          setState(() {
            showName = !showName;
          });
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: !showName
                  ? Image.asset(
                      widget.imageIcon,
                      width: 30,
                      height: 30,
                      color: HOPA,
                    )
                  : Text(
                      widget.name,
                      style: HOPASTYLE,
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
