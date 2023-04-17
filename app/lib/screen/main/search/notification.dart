import "package:flutter/material.dart";
import 'package:gap/gap.dart';
import 'package:hikup/viewmodel/notification_viewmodel.dart';
import 'package:hikup/widget/back_icon.dart';
import 'package:hikup/widget/base_view.dart';
import 'package:hikup/widget/notification_card.dart';
import 'package:hikup/utils/app_messages.dart';
import '../../../theme.dart';

class NotificationView extends StatelessWidget {
  static String routeName = "/notification";
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: kTextTabBarHeight,
          title: Text(
            AppMessages.notificationText,
            style: titleTextStyleWhite,
          ),
          iconTheme: IconThemeData(
            color: GreenPrimary, // Couleur de la flèche retour
          ),
          backgroundColor: BlackPrimary,
          elevation: 0,
          centerTitle: true,
      ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            children: [
              Column(
                children: List.generate(
                  7,
                  (index) => const NotificationCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
