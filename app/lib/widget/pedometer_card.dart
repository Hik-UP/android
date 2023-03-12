import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/dummy_data.dart';

class PedometerCard extends StatelessWidget {
  const PedometerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  PedometerCardState(
          title: "Pedometer",
          imageAsset: "assets/icons/home_fill.png");
    }
}

class PedometerCardState extends StatelessWidget {
  final String title;
  final String imageAsset;

  const PedometerCardState({
    required this.title,
    required this.imageAsset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: Material(
        color: colorWhite,
        shadowColor: primaryColor500.withOpacity(0.1),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          highlightColor: primaryColor500.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          splashColor: primaryColor500.withOpacity(0.5),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor100,
                    child: Image.asset(
                      imageAsset,
                      color: primaryColor500,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  title,
                  style: descTextStyle,
                )
              ],
            ),
          ),
           onTap: () { 
                Navigator.pushNamed(context, "/pedometer");
           },
        ),
      ),
    );
  }
}
