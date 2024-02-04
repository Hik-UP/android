import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hikup/model/comment.dart';
import 'package:hikup/providers/app_state.dart';
import 'package:hikup/viewmodel/community_page_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/comment_card.dart';
import 'package:hikup/widget/comment_bar.dart';
import 'package:provider/provider.dart';
import "package:gap/gap.dart";
import 'package:flutter_svg/flutter_svg.dart';

class CommunityView extends StatefulWidget {
  final String trailId;
  static String routeName = "/community";
  const CommunityView({
    super.key,
    required this.trailId,
  });

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    AppState appState = context.read<AppState>();

    return BaseView<CommunityPageViewModel>(
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              "Avis",
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white, // Couleur de la flèche retour
            ),
            backgroundColor: Colors.black,
          ),
          body: Stack(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 80),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<Comment>>(
                      future: model.retrieveData(
                        appState: appState,
                        trailId: widget.trailId,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/cat-error.svg",
                                  height: 64,
                                  width: 64,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                                  semanticsLabel: 'error',
                                ),
                                const Gap(20),
                                Center(
                                  child: Text(
                                    "Une erreur est survenue",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data!.isNotEmpty) {
                            snapshot.data!.sort((a, b) {
                              var adate = a.date;
                              var bdate = b.date;
                              return bdate.compareTo(adate);
                            });
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 10.0,
                                  left: 0.0,
                                ),
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 10,
                                    ),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.25),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: CommentCard(
                                        comment: snapshot.data![index],
                                        update: () => setState(() {}),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/cat-error.svg",
                                    height: 64,
                                    width: 64,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.srcIn,
                                    ),
                                    semanticsLabel: 'error',
                                  ),
                                  const Gap(20),
                                  Center(
                                    child: Text(
                                      "Aucun avis",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return const Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Center(child: CircularProgressIndicator())
                            ]));
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: CommentBar(
                  trailId: widget.trailId,
                  update: () => setState(() {}),
                ))
          ])),
    );
  }
}
