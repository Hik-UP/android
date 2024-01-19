import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/hike.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/utils/wrapper_api.dart';
import 'package:hikup/widget/hike_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class AllHike extends StatefulWidget {
  final List<String> targets;
  const AllHike({
    super.key,
    required this.targets,
  });

  @override
  State<AllHike> createState() => _AllHikeState();
}

class _AllHikeState extends State<AllHike> {
  bool isLoading = true;

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
          onLoad: () {
            isLoading = true;
          },
          onRetrieved: () {
            isLoading = false;
          }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return error();
        }
        if (snapshot.data != null && isLoading == false) {
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: HikeCard(
                  hike: snapshot.data![index],
                  guest: widget.targets[0] == "guest",
                  update: () => setState(() {}),
                ),
              ),
            );
          } else {
            return error();
          }
        }

        return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ));
      },
    );
  }
}
