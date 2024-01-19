import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/hike/all_hike.dart';
import 'package:hikup/viewmodel/hikes_create_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/utils/app_messages.dart';

class HikesCreate extends StatefulWidget {
  static String routeName = "/hikes-create";
  const HikesCreate({super.key});

  @override
  State<HikesCreate> createState() => _HikesCreateState();
}

class _HikesCreateState extends State<HikesCreate> {
  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return BaseView<HikeCreateViewModel>(builder: (context, model, child) {
      if (isInit == false && arguments['goToInvite'] == true) {
        model.currentIndex = 1;
        isInit = true;
      }

      return Scaffold(
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(
            children: [
              DefaultTabController(
                initialIndex: arguments['goToInvite'] == true ? 1 : 0,
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
                        targets: model.targets[model.currentIndex],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}
