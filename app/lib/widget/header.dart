import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/search_screen.dart';
import 'package:hikup/theme.dart';

class Header extends StatelessWidget {
  final String name;
  const Header({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        // SEARCH Icon
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          AssetImage("assets/images/user_profile_example.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenue,",
                      style: descTextStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      name,
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      FontAwesomeIcons.bell,
                      size: 23,
                    ),
                    Positioned(
                      right: 0,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: const BoxDecoration(
                          color: primaryColor500,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16.0),
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor500,
                      borderRadius: BorderRadius.circular(borderRadiusSize)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchScreen(
                          selectedDropdownItem: "",
                        );
                      }));
                    },
                    icon: const Icon(Icons.search, color: colorWhite),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
