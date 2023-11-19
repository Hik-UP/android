import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/hike/all_hike.dart';
import 'package:hikup/viewmodel/hikes_create_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/utils/app_messages.dart';
import '../../../theme.dart';

class HikesCreate extends StatelessWidget {
  static String routeName = "/hikes-create";
  const HikesCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HikeCreateViewModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            AppMessages.myHike,
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 00.0),
          child: Column(
            children: [
              DefaultTabController(
                length: model.tabs.length,
                child: Builder(builder: (context) {
                  final TabController tabController =
                      DefaultTabController.of(context);

                  tabController.addListener(() {
                    if (!tabController.indexIsChanging) {
                      model.setCurrentIndex(index: tabController.index);
                    }
                  });

                  return Column(
                    children: [
                      TabBar(
                        labelColor: Colors.white,
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.transparent,
                        tabs: model.tabs,
                      ),
                      const Gap(10.0),
                      AllHike(
                        menuIndex: model.currentIndex,
                        targets: model.targets[model.currentIndex],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
