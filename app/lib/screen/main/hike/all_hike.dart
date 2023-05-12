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

class AllHike extends StatefulWidget {
  final List<String> targets;
  const AllHike({
    Key? key,
    required this.targets,
  }) : super(key: key);

  @override
  State<AllHike> createState() => _AllHikeState();
}

class _AllHikeState extends State<AllHike> {
  @override
  Widget build(BuildContext context) {
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
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: HikeCard(
                  hike: snapshot.data![index],
                  update: () => setState(() {}),
                ),
              ),
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: Text(
                  AppMessages.noHike,
                  style: subErrorTitleTextStyle,
                ),
              ),
            );
          }
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
