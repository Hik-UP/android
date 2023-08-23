import 'package:flutter/material.dart';
import 'package:hikup/theme.dart';
import 'package:hikup/utils/app_messages.dart';

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
        children: [],
      ),
    );
  }
}
