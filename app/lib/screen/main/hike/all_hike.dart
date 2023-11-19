import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/hike.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/widget/hike_card.dart';
import 'package:provider/provider.dart';
import '../../../theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class AllHike extends StatefulWidget {
  final int menuIndex;
  final List<String> targets;
  const AllHike({
    Key? key,
    required this.menuIndex,
    required this.targets,
  }) : super(key: key);

  @override
  State<AllHike> createState() => _AllHikeState();
}

class _AllHikeState extends State<AllHike> {
  @override
  Widget build(BuildContext context) {
    error() {
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/icons/cat-error.svg",
                    height: 64,
                    width: 64,
                    colorFilter:
                        const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    semanticsLabel: 'error'),
                const Gap(20),
                Center(
                  child: Text(
                    "Rien à afficher ici",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
              ]));
    }

    return FutureBuilder<List<Hike>>(
      future: WrapperApi().getAllHike(
        path: getHikePath,
        appState: context.read<AppState>(),
        target: widget.targets,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              AppMessages.anErrorOcur,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
          );
        }
        if (snapshot.data != null) {
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => (widget.menuIndex == 0 &&
                          snapshot.data![index].status != "DONE") ||
                      (widget.menuIndex == 1) ||
                      (widget.menuIndex == 2 &&
                          snapshot.data![index].status == "DONE")
                  ? Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: HikeCard(
                        hike: snapshot.data![index],
                        guest: widget.menuIndex == 1,
                        update: () => Future.delayed(
                            const Duration(
                              seconds: 3,
                            ), () {
                          setState(() {});
                        }),
                      ),
                    )
                  : error(),
            );
          } else {
            return error();
          }
        }

        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
