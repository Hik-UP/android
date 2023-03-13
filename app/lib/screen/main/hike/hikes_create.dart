import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/screen/main/hike/all_hike.dart';
import 'package:hikup/viewmodel/hikes_create_viewmodel.dart';
import 'package:hikup/widget/base_view.dart';

class HikesCreate extends StatelessWidget {
  static String routeName = "/hikes-create";
  const HikesCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HikeCreateViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
