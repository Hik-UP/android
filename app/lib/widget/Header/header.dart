import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/hike/hikes_create.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:hikup/screen/main/setting/settings_screen.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 156, 156, 156),
      ),
      centerTitle: true,
      title: Text(
        "HIK'UP",
        style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.italic),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                HikesCreate.routeName,
              ),
              child: const Icon(
                FontAwesomeIcons.personHiking,
              ),
            ),
            const Gap(10),
            Consumer<AppState>(
              builder: (context, state, child) {
                return state.picture.isEmpty
                    ? Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: BlackPrimary,
                        ),
                      )
                    : LoadPictureProfil(
                        size: 35,
                        appState: state,
                      );
              },
            ),
            const Gap(16.0),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
