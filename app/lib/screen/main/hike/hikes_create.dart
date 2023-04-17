import "package:flutter/material.dart";
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
        backgroundColor: BlackSecondary,
        appBar: AppBar(
          title: Text(
            AppMessages.myHike,
            style: titleTextStyleWhite,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: GreenPrimary, // Couleur de la flèche retour
          ),
          backgroundColor: BlackPrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 00.0),
          child: Column(
            children: [
              DefaultTabController(
                length: model.tabs.length,
                child: Builder(builder: (context) {
                  final TabController tabController =
                      DefaultTabController.of(context)!;

                  tabController.addListener(() {
                    if (!tabController.indexIsChanging) {
                      model.setCurrentIndex(index: tabController.index);
                    }
                  });

                  return Column(
                    children: [
                      TabBar(
                        labelColor: GreenPrimary,
                        unselectedLabelColor: Color.fromARGB(255, 255, 255, 255),
                        indicatorColor: GreenPrimary,
                        tabs: model.tabs,
                      ),
                      const Gap(20.0),
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
      ),
    );
  }
}
