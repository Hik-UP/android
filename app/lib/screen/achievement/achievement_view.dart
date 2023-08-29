import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';
import 'package:hikup/utils/constant.dart';
import 'package:hikup/widget/achievement_card.dart';

class AchievementView extends StatelessWidget {
  static String routeName = "/achievement";
  const AchievementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          AppMessages.successLabel,
          style: titleTextStyleWhite,
        ),
        iconTheme: const IconThemeData(
          color: GreenPrimary, // Couleur de la flèche retour
        ),
        backgroundColor: BlackPrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Gap(14.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: achievementSampleData.length,
            itemBuilder: (context, index) => AchievementCard(
              achievement: achievementSampleData[index],
            ),
          ),
        ],
      ),
    );
  }
}
